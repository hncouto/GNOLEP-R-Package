# data-raw/data-preparation.R
# -----------------------

# Load necessary libraries
library(dplyr)

# Paths to the raw data
#WDNnL_db_path <- "https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/main/Database%20Tables/"

# Read Tables

#Natives <- read.csv(paste0(WDNnL_db_path,"Obs_NativesDB.csv"), stringsAsFactors = FALSE, sep = ",")
#Records <- read.csv(paste0(WDNnL_db_path,"Obs_Records_DB.csv"), stringsAsFactors = FALSE, sep = ",")
#References <- read.csv(paste0(WDNnL_db_path,"Base_References.csv"), stringsAsFactors = FALSE, sep = ",")
#Taxonomy <- read.csv(paste0(WDNnL_db_path,"Base_Taxonomy.csv"), stringsAsFactors = FALSE, sep = ",")
#Regions <- read.csv(paste0(WDNnL_db_path,"Geography_Regions.csv"), stringsAsFactors = FALSE, sep = ",")
#Realms <- read.csv(paste0(WDNnL_db_path,"Geography_Realms.csv"), stringsAsFactors = FALSE, sep = ",")

######While database is private use this (delete when public):
library(gh)
library(jsonlite)

read_private_csv <- function(path, sep = ",") {
  res <- gh(
    "/repos/{owner}/{repo}/contents/{path}",
    owner = "hncouto",
    repo = "Worldwide_Database_on_Non-native_Lepidoptera",
    path = path)
  tmp <- tempfile(fileext = ".csv")
  writeBin(base64_dec(res$content), tmp)
  read.csv(tmp,
    stringsAsFactors = FALSE,
    sep = sep)}

Natives <- read_private_csv("Database Tables/Obs_NativesDB.csv")
Records <- read_private_csv("Database Tables/Obs_Records_DB.csv")
References <- read_private_csv("Database Tables/Base_References.csv")
Taxonomy <- read_private_csv("Database Tables/Base_Taxonomy.csv")
Regions <- read_private_csv("Database Tables/Geography_Regions.csv")
Realms <- read_private_csv("Database Tables/Geography_Realms.csv")
############

# Perform the join as specified
WDnNL <- Records %>%
  left_join(Taxonomy, by = c("SpeciesID" = "SpeciesID")) %>%
  left_join(Regions, by = c("AreaID" = "AreaID")) %>%
  left_join(Realms, by = c("RealmID" = "RealmID")) %>%
  left_join(References, by = c("ReferenceID" = "ReferenceID")) %>%
  select(-SpeciesID, -AreaID, -RealmID, -ReferenceID, -AcceptedSpeciesID)

NativeDatabase <- Natives %>%
  left_join(Taxonomy, by = c("SpeciesID" = "SpeciesID")) %>%
  left_join(Realms, by = c("RealmID" = "RealmID")) %>%
  left_join(References, by = c("ReferenceID" = "ReferenceID")) %>%
  select(Species, Realm, Continent, BibliographicReference, ReferenceYear)


class(WDnNL) <- append("WDnNL", class(WDnNL))

save(WDnNL, file = "data/WDnNL.rda", compress = "xz")


# Condensed Database

Taxonomy_keyd <- Taxonomy %>%
  left_join(
    Taxonomy %>%
      select(SpeciesID, Species) %>%
      rename(AcceptedSpeciesID = SpeciesID,
             AcceptedSpecies = Species),
    by = "AcceptedSpeciesID") %>%
  select(SpeciesID, AcceptedSpeciesID, AcceptedSpecies)

RankedObservations <- Records %>%
  inner_join(Taxonomy_keyd, by = "SpeciesID") %>%
  inner_join(Regions, by = "AreaID") %>%
  inner_join(Realms, by = "RealmID") %>%
  inner_join(References, by = "ReferenceID") %>%
  filter(Introduced == 1 | is.na(Introduced)) %>%
  group_by(AcceptedSpeciesID, AreaName, Realm) %>%
  mutate(RefRank = row_number(desc(ReferenceYear))) %>%
  ungroup() %>%
  group_by(AcceptedSpecies, AreaName, Realm) %>%
  mutate(First_Observation = min(Year, na.rm = TRUE)) %>%
  ungroup()

UniqueRecords <- RankedObservations %>%
  transmute(
    SpeciesID = AcceptedSpeciesID,
    Species = AcceptedSpecies,
    AreaID,
    AreaName,
    Continent,
    Realm,
    First_Observation) %>%
  distinct()

pick_first_non_na <- function(value, rank) {
  idx <- which(!is.na(value))
  if (length(idx) == 0) return(NA)
  value[idx[which.min(rank[idx])]]
}

ObservationsSummary <- RankedObservations %>%
  group_by(SpeciesID, AcceptedSpecies,
           AreaID, AreaName, Continent, Realm, First_Observation) %>%

  summarise(
    Cryptogenic = pick_first_non_na(Cryptogenic, RefRank),
    Dispersal = pick_first_non_na(Dispersal, RefRank),
    Eradicated = pick_first_non_na(Eradicated, RefRank),
    Established = pick_first_non_na(Established, RefRank),
    IntentionalRelease = pick_first_non_na(IntentionalRelease, RefRank),
    Introduced = pick_first_non_na(Introduced, RefRank),
    Latest_Reference = BibliographicReference[which.min(ifelse(RefRank == 1, 0, 1))][1],
    Latest_Reference_Year = ReferenceYear[RefRank == 1][1],
    .groups = "drop")

CondensedDatabase <- ObservationsSummary %>%
  mutate(
    First_Observation = if_else(
      is.infinite(First_Observation),
      NA_real_,
      First_Observation))

usethis::use_data(
  CondensedDatabase,
  Natives, Realms, Records,
  References, Regions, Taxonomy, NativeDatabase,
  overwrite = TRUE, compress = "xz")


#source("data-raw/data-preparation.R")
