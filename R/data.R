# R/data.R

#' Joined distribution database
#'
#' A processed dataset containing distribution `Records` joined with taxonomy, regions,
#' realms and references. This dataset is produced from the WDNnL SQLite database
#' and the distribution CSV file (see `data-raw/prepare-data.R`).
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
"database"

#' Raw distribution CSV
#'
#' Original CSV read into R as `DistributionData`.
#' @format A data frame with ... (describe columns)
"DistributionData"

#' NativeDistribution table
#' @format A data frame...
"NativeDistribution"

#' Realms table
#' @format A data frame...
"Realms"

#' Records table
#' @format A data frame...
"Records"

#' References table
#' @format A data frame...
"References"

#' Regions table
#' @format A data frame...
"Regions"

#' Taxonomy table
#' @format A data frame...
"Taxonomy"
