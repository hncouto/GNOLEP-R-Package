# data-raw/data-preparation.R
# -----------------------

# Load necessary libraries
library(RSQLite)
library(dplyr)

# Paths to the raw data
DistributionData_path <- "data/RawData/CurrentVersion/DistributionData.csv"
WDNnL_db_path <- "data/RawData/CurrentVersion/WDNnL.sqlite"

# Read the CSV file
CondensedDatabase <- read.csv(DistributionData_path, stringsAsFactors = FALSE, sep = ";")

# Connect to the database
con <- dbConnect(SQLite(), WDNnL_db_path)

# Read Tables
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
dbDisconnect(con)


usethis::use_data(
  CondensedDatabase, Natives, Realms, Records,
  References, Regions, Taxonomy, WDnNL, NativeDatabase,
  overwrite = TRUE, compress = "xz")


#source("data-raw/data-preparation.R")
