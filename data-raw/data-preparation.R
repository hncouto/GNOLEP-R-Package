# data-raw/data-preparation.R
# -----------------------

# Load necessary libraries
library(RSQLite)
library(dplyr)

# Paths to the raw data
DistributionData_path <- "data/RawData/CurrentVersion/DistributionData.csv"
WDNnL_db_path <- "data/RawData/CurrentVersion/WDNnL.sqlite"

# Read the CSV file
DistributionData <- read.csv(DistributionData_path, stringsAsFactors = FALSE, sep = ";")

# Connect to the database
con <- dbConnect(SQLite(), WDNnL_db_path)

# Read table1
NativeDistribution <- dbReadTable(con, "NativeDistribution")
Realms <- dbReadTable(con, "Realms")
Records <- dbReadTable(con, "Records")
References <- dbReadTable(con, "References")
Regions <- dbReadTable(con, "Regions")
Taxonomy <- dbReadTable(con, "Taxonomy")

# Perform the join as specified
database <- Records %>%
  left_join(Taxonomy, by = c("SpeciesID" = "SpeciesID")) %>%
  left_join(Regions, by = c("AreaID" = "AreaID")) %>%
  left_join(Realms, by = c("RealmID" = "RealmID")) %>%
  left_join(References, by = c("ReferenceID" = "ReferenceID")) %>%
  select(-SpeciesID, -AreaID, -RealmID, -ReferenceID, -AcceptedSpeciesID)


# Disconnect from the database
dbDisconnect(con)


usethis::use_data(
  DistributionData, NativeDistribution, Realms, Records,
  References, Regions, Taxonomy, database,
  overwrite = TRUE, compress = "xz"
)
