# data-raw/data-preparation.R
# -----------------------

# Load necessary libraries
library(dplyr)

# Paths to the raw data
#WDNnL_db_path <- "https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/main/Database%20Tables/"
#DistributionData_path <- "data/RawData/DistributionData.csv" #Needs to be updated

# Read the CSV file
#CondensedDatabase <- read.csv(DistributionData_path, stringsAsFactors = FALSE, sep = ";")

# Read Tables

#Natives <- read.csv(paste0(WDNnL_db_path,"Obs_NativesDB.csv"), stringsAsFactors = FALSE, sep = ",")
#Records <- read.csv(paste0(WDNnL_db_path,"Obs_Records_DB.csv"), stringsAsFactors = FALSE, sep = ",")
#References <- read.csv(paste0(WDNnL_db_path,"Base_References.csv"), stringsAsFactors = FALSE, sep = ",")
#Taxonomy <- read.csv(paste0(WDNnL_db_path,"Base_Taxonomy.csv"), stringsAsFactors = FALSE, sep = ",")
#Regions <- read.csv(paste0(WDNnL_db_path,"Geography_Regions.csv"), stringsAsFactors = FALSE, sep = ",")
#Realms <- read.csv(paste0(WDNnL_db_path,"Geography_Realms.csv"), stringsAsFactors = FALSE, sep = ",")

#While database is private use this (delete when public):
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
    sep = sep)
}
Natives <- read_private_csv("Database Tables/Obs_NativesDB.csv")
Records <- read_private_csv("Database Tables/Obs_Records_DB.csv")
References <- read_private_csv("Database Tables/Base_References.csv")
Taxonomy <- read_private_csv("Database Tables/Base_Taxonomy.csv")
Regions <- read_private_csv("Database Tables/Geography_Regions.csv")
Realms <- read_private_csv("Database Tables/Geography_Realms.csv")


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

usethis::use_data(
  #CondensedDatabase,
  Natives, Realms, Records,
  References, Regions, Taxonomy, NativeDatabase,
  overwrite = TRUE, compress = "xz")


#source("data-raw/data-preparation.R")
