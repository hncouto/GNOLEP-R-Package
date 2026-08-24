# data-raw/data-preparation.R
# -----------------------

# Load necessary libraries
library(dplyr)

# Paths to the raw data
#GNOLEP_db_path <- "https://raw.githubusercontent.com/hncouto/Global_Database_on_Non-native_Lepidoptera/main/Database%20Tables/"

# Read Tables

#Natives <- read.csv(paste0(GNOLEP_db_path,"Obs_NativesDB.csv"), stringsAsFactors = FALSE, sep = ",")
#Records <- read.csv(paste0(GNOLEP_db_path,"Obs_Records_DB.csv"), stringsAsFactors = FALSE, sep = ",")
#References <- read.csv(paste0(GNOLEP_db_path,"Base_References.csv"), stringsAsFactors = FALSE, sep = ",")
#Taxonomy <- read.csv(paste0(GNOLEP_db_path,"Base_Taxonomy.csv"), stringsAsFactors = FALSE, sep = ",")
#Regions <- read.csv(paste0(GNOLEP_db_path,"Geography_Regions.csv"), stringsAsFactors = FALSE, sep = ",")
#Realms <- read.csv(paste0(GNOLEP_db_path,"Geography_Realms.csv"), stringsAsFactors = FALSE, sep = ",")

######While database is private use this (delete when public):
library(gh)
library(jsonlite)

read_private_csv <- function(path, sep = ",") {
  res <- gh("/repos/hncouto/Global_Database_on_Non-native_Lepidoptera/contents/{path}", path = path)
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

Taxonomy_keyd <- Taxonomy %>%
  left_join(
    Taxonomy %>%
      select(SpeciesID, Species) %>%
      rename(AcceptedSpeciesID = SpeciesID,
             AcceptedSpecies = Species),
    by = "AcceptedSpeciesID")

GNOLEP <- Records %>%
  left_join(Taxonomy_keyd, by = c("SpeciesID" = "SpeciesID")) %>%
  left_join(Regions, by = c("AreaID" = "AreaID")) %>%
  left_join(Realms, by = c("RealmID" = "RealmID")) %>%
  left_join(References, by = c("ReferenceID" = "ReferenceID")) %>%
  select(-SpeciesID, -AreaID, -RealmID, -ReferenceID, -AcceptedSpeciesID)



class(GNOLEP) <- append("GNOLEP", class(GNOLEP))

save(GNOLEP, file = "data/GNOLEP.rda", compress = "xz")


# Condensed Database

Taxonomy_keyd <-
  Taxonomy_keyd %>% select(SpeciesID, AcceptedSpeciesID, AcceptedSpecies)

Observations <- Records %>%
  inner_join(Taxonomy_keyd, by = "SpeciesID") %>%
  inner_join(Regions, by = "AreaID") %>%
  inner_join(Realms, by = "RealmID") %>%
  inner_join(References, by = "ReferenceID") %>%
  select(-SpeciesID, -AreaID, -RealmID, -ReferenceID, -AcceptedSpeciesID)

RankedObservations <- Observations %>%
  filter(Introduced == 1 | is.na(Introduced)) %>%
  group_by(AcceptedSpecies, AreaName, Realm) %>%
  mutate(RefRank = row_number(desc(ReferenceYear))) %>%
  ungroup() %>%
  group_by(AcceptedSpecies, AreaName, Realm) %>%
  mutate(First_Record = min(Year, na.rm = TRUE)) %>%
  ungroup()

UniqueRecords <- RankedObservations %>%
  transmute(
    Species = AcceptedSpecies,
    AreaName,
    Continent,
    Realm,
    First_Record) %>%
  distinct()

pick_first_non_na <- function(value, rank) {
  idx <- which(!is.na(value))
  if (length(idx) == 0) return(NA)
  value[idx[which.min(rank[idx])]]
}

ObservationsSummary <- RankedObservations %>%
  group_by(AcceptedSpecies,
           AreaName, Continent, Realm, First_Record) %>%

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

CondensedGNOLEP <- ObservationsSummary %>%
  mutate(
    First_Record = if_else(
      is.infinite(First_Record),
      NA_real_,
      First_Record))

class(CondensedGNOLEP) <- c("CondensedGNOLEP", "GNOLEP", "data.frame")
save(CondensedGNOLEP, file = "data/CondensedGNOLEP.rda", compress = "xz")

NativesGNOLEP <- Natives
RealmsGNOLEP <- Realms
RecordsGNOLEP <- Records
ReferencesGNOLEP <- References
RegionsGNOLEP <- Regions
TaxonomyGNOLEP <- Taxonomy

usethis::use_data(
  NativesGNOLEP, RealmsGNOLEP, RecordsGNOLEP,
  ReferencesGNOLEP, RegionsGNOLEP, TaxonomyGNOLEP,
  overwrite = TRUE, compress = "xz")


#source("data-raw/data-preparation.R")
