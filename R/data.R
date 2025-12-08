# R/data.R

#' Joined distribution database
#'
#' A processed dataset containing distribution `Records` joined with taxonomy, regions,
#' realms and references. This dataset is produced from the WDNnL SQLite database
#' and the distribution CSV file (see `data-raw/data-preparation.R`).
#'
#' @format A data frame with N rows and M variables:
#' \describe{
#'   \item{RecordID}{integer; unique record id}
#'   \item{Species}{character; species name}
#'   \item{Area}{character; region/area name}
#'   \item{Realm}{character; realm name}
#'   \item{Reference}{character; citation or reference id}
#'   # ... fill in the real column names and types
#' }
#' @source WDNnL SQLite database and DistributionData CSV (private source)
"WDnNL"

#' Condensed Database.
#'
#' Condensed Database to one Species per Region.
#' @format A data frame with a total of 10 variables.
#'
#' Taxonomic variables (3): Species, Family; Butterfly (1 for Papilionoidea Superfamily)
#'
#' Distribution Variables (3): Region, Realm, Continent;
#'
#' Introduction Variables (2): First Observation, Intentional Release;
#'
#' Reference Data (2): Latest Reference (in the Complete database), Latest Reference Year
#'
"CondensedDatabase"

#' Native Distribution Table
#'
#' Table with Native Distribution per Species
#' @format A data frame with
"Natives"

#' Realms table
#' @format A data frame...
"Realms"

#' References table
#' @format A data frame...
"References"

#' Regions table
#' @format A data frame...
"Regions"

#' Taxonomy table
#' @format A data frame...
"Taxonomy"

#' NativeDatabase table
#' @format A data frame...
"NativeDatabase"
