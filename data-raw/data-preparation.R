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
      select(GNOLEP.speciesID, dwc.scientificName) %>%
      rename(GNOLEP.acceptedSpeciesID = GNOLEP.speciesID,
             GNOLEP.acceptedSpecies = dwc.scientificName),
    by = "GNOLEP.acceptedSpeciesID")

GNOLEP <- Records %>%
  left_join(Taxonomy_keyd, by = c("GNOLEP.speciesID" = "GNOLEP.speciesID")) %>%
  left_join(Regions, by = c("GNOLEP.areaID" = "GNOLEP.areaID")) %>%
  left_join(Realms, by = c("GNOLEP.realmID" = "GNOLEP.realmID")) %>%
  left_join(References, by = c("GNOLEP.referenceID" = "GNOLEP.referenceID")) %>%
  select(-GNOLEP.speciesID, -GNOLEP.areaID, -GNOLEP.realmID, -GNOLEP.referenceID, -GNOLEP.acceptedSpeciesID)



class(GNOLEP) <- append("GNOLEP", class(GNOLEP))

save(GNOLEP, file = "data/GNOLEP.rda", compress = "xz")


# Condensed Database

Taxonomy_keyd <-
  Taxonomy_keyd %>% select(GNOLEP.speciesID, GNOLEP.acceptedSpeciesID, GNOLEP.acceptedSpecies)

Observations <- Records %>%
  inner_join(Taxonomy_keyd, by = "GNOLEP.speciesID") %>%
  inner_join(Regions, by = "GNOLEP.areaID") %>%
  inner_join(Realms, by = "GNOLEP.realmID") %>%
  inner_join(References, by = "GNOLEP.referenceID") %>%
  select(-GNOLEP.speciesID, -GNOLEP.areaID, -GNOLEP.realmID, -GNOLEP.referenceID, -GNOLEP.acceptedSpeciesID)

RankedObservations <- Observations %>%
  rename(dwc.scientificName = GNOLEP.acceptedSpecies) %>%
  filter(GNOLEP.introduced == 1 | is.na(GNOLEP.introduced)) %>%
  group_by(dwc.scientificName, dwc.verbatimLocality, GNOLEP.realm) %>%
  mutate(RefRank = row_number(desc(GNOLEP.referenceYear))) %>%
  ungroup() %>%
  group_by(dwc.scientificName, dwc.verbatimLocality, GNOLEP.realm) %>%
  mutate(dwc.year = min(dwc.year, na.rm = TRUE)) %>%
  ungroup()

UniqueRecords <- RankedObservations %>%
  transmute(
    dwc.scientificName,
    dwc.verbatimLocality,
    dwc.continent,
    GNOLEP.realm,
    dwc.year) %>%
  distinct()

pick_first_non_na <- function(value, rank) {
  idx <- which(!is.na(value))
  if (length(idx) == 0) return(NA)
  value[idx[which.min(rank[idx])]]
}

ObservationsSummary <- RankedObservations %>%
  group_by(dwc.scientificName,
           dwc.verbatimLocality, dwc.continent, GNOLEP.realm, dwc.year) %>%

  summarise(
    GNOLEP.cryptogenic = pick_first_non_na(GNOLEP.cryptogenic, RefRank),
    GNOLEP.dispersal = pick_first_non_na(GNOLEP.dispersal, RefRank),
    GNOLEP.eradicated = pick_first_non_na(GNOLEP.eradicated, RefRank),
    GNOLEP.established = pick_first_non_na(GNOLEP.established, RefRank),
    GNOLEP.intentionalRelease = pick_first_non_na(GNOLEP.intentionalRelease, RefRank),
    GNOLEP.introduced = pick_first_non_na(GNOLEP.introduced, RefRank),
    Latest_Reference = dwc.associatedReferences[which.min(ifelse(RefRank == 1, 0, 1))][1],
    Latest_Reference_Year = GNOLEP.referenceYear[RefRank == 1][1],
    .groups = "drop")

CondensedGNOLEP <- ObservationsSummary %>%
  mutate(
    dwc.year = if_else(
      is.infinite(dwc.year),
      NA_real_,
      dwc.year))

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
