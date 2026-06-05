# data-raw/data-preparation.R
# -----------------------

# Load necessary libraries
library(RSQLite)
library(dplyr)

# Paths to the raw data
WDNnL_db_path <- "https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/main/Database%20Tables/"
DistributionData_path <- "data/RawData/CurrentVersion/DistributionData.csv"

# Read the CSV file
CondensedDatabase <- read.csv(DistributionData_path, stringsAsFactors = FALSE, sep = ";")

# Read Tables

Natives <- read.csv(paste0(WDNnL_db_path,"Obs_NativesDB.csv"), stringsAsFactors = FALSE, sep = ";")

Natives <- dbReadTable(con, "NativeDistribution")
Realms <- dbReadTable(con, "Realms")
Records <- dbReadTable(con, "Records")
References <- dbReadTable(con, "References")
Regions <- dbReadTable(con, "Regions")
Taxonomy <- dbReadTable(con, "Taxonomy")

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
  select(Species, AcceptedSpecies, Realm, Continent, Cosmopolitan, BibliographicReference, ReferenceYear)
# Disconnect from the database


class(WDnNL) <- append("WDnNL", class(WDnNL))

save(WDnNL, file = "data/WDnNL.rda", compress = "xz")

usethis::use_data(
  CondensedDatabase, Natives, Realms, Records,
  References, Regions, Taxonomy, NativeDatabase,
  overwrite = TRUE, compress = "xz")


#source("data-raw/data-preparation.R")
