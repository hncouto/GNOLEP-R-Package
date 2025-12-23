# R/database_extract.R
# -----------------------


library(DBI)
library(RSQLite)
library(dplyr)

#' Table Extraction from previous database versions.
#'
#' @param version The database version to extract
#' @param table The table to extract from the version
#'
#' @returns The table from the specified version as a dataframe
#' @export
#'
#' @examples version_extract(1,"NativeDatabase") - not yet available
version_extract <- function(version = "", table, destination_file=NULL) {

  #URL = paste0("https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/tree/main/Previous%20Versions/V",version)

  #DistData_url_PreviousVersion <- paste0("https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/main/Previous%20Versions/V",version,"/DistributionData.csv")
  #df <- read.csv(DistData_url)

  #db_url <- "https://raw.githubusercontent.com/OWNER/WnDD/main/data/mydb.sqlite"
  #db_file <- tempfile(fileext = ".sqlite")
  #download.file(db_url, db_file, mode = "wb")
  #con <- DBI::dbConnect(RSQLite::SQLite(), db_file)


  if (is.null(version) || version == "" || is.na(version)) {
    DistributionData_path <- paste0("https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/main/Current%20Version/DistributionData.csv")
    WDNnL_db_path <- .get_WDNnL_db_current()
    #DistributionData_path <- "data/RawData/CurrentVersion/DistributionData.csv"
    #WDNnL_db_path <- "data/RawData/CurrentVersion/WDNnL.sqlite"
  } else {
    DistributionData_path <- paste0("https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/main/Previous%20Versions/V",version,"/DistributionData.csv")
    WDNnL_db_path <- .get_WDNnL_db_previous(version)
    #DistributionData_path <- file.path("data/RawData/", paste0("V", version), "/DistributionData.csv")
    #WDNnL_db_path <- file.path("data/RawData/", paste0("V", version), "/WDNnL.sqlite")}

  if (table == "CondensedDatabase"){
    CondensedDatabase <- read.csv(DistributionData_path, stringsAsFactors = FALSE, sep = ";")
    final_dataframe <- as.data.frame(CondensedDatabase)

  } else if (table == "Natives") {
    con <- DBI::dbConnect(RSQLite::SQLite(), WDNnL_db_path)
    Natives <- DBI::dbReadTable(con, "NativeDistribution")
    final_dataframe <- as.data.frame(Natives)
    dbDisconnect(con)

  } else if (table == "NativeDatabase"){
    con <- DBI::dbConnect(RSQLite::SQLite(), WDNnL_db_path)
    Natives <- DBI::dbReadTable(con, "NativeDistribution")
    Realms <- DBI::dbReadTable(con, "Realms")
    References <- DBI::dbReadTable(con, "References")
    Taxonomy <- DBI::dbReadTable(con, "Taxonomy")
    NativeDatabase <- Natives %>%
      left_join(Taxonomy, by = c("SpeciesID" = "SpeciesID")) %>%
      left_join(Realms, by = c("RealmID" = "RealmID")) %>%
      left_join(References, by = c("ReferenceID" = "ReferenceID")) %>%
      select(Species, AcceptedSpecies, Realm, Continent, Cosmopolitan, BibliographicReference, ReferenceYear)
    final_dataframe <- as.data.frame(NativeDatabase)
    dbDisconnect(con)

  } else if (table == "Realms") {
    con <- DBI::dbConnect(RSQLite::SQLite(), WDNnL_db_path)
    Realms <- DBI::dbReadTable(con, "Realms")
    final_dataframe <- as.data.frame(Realms)
    dbDisconnect(con)

  } else if (table == "Records") {
    con <- DBI::dbConnect(RSQLite::SQLite(), WDNnL_db_path)
    Records <- DBI::dbReadTable(con, "Records")
    final_dataframe <- as.data.frame(Records)
    dbDisconnect(con)

  } else if (table == "WDnNL") {
    con <- DBI::dbConnect(RSQLite::SQLite(), WDNnL_db_path)
    Natives <- DBI::dbReadTable(con, "NativeDistribution")
    Realms <- DBI::dbReadTable(con, "Realms")
    Records <- DBI::dbReadTable(con, "Records")
    References <- DBI::dbReadTable(con, "References")
    Regions <- DBI::dbReadTable(con, "Regions")
    Taxonomy <- DBI::dbReadTable(con, "Taxonomy")
    WDnNL <- Records %>%
      left_join(Taxonomy, by = c("SpeciesID" = "SpeciesID")) %>%
      left_join(Regions, by = c("AreaID" = "AreaID")) %>%
      left_join(Realms, by = c("RealmID" = "RealmID")) %>%
      left_join(References, by = c("ReferenceID" = "ReferenceID")) %>%
      select(-SpeciesID, -AreaID, -RealmID, -ReferenceID, -AcceptedSpeciesID)
    final_dataframe <- as.data.frame(WDnNL)
    class(final_dataframe) <- append("WDnNL", class(final_dataframe))
    dbDisconnect(con)

  } else if (table == "References") {
    con <- DBI::dbConnect(RSQLite::SQLite(), WDNnL_db_path)
    References <- DBI::dbReadTable(con, "References")
    final_dataframe <- as.data.frame(References)
    dbDisconnect(con)

  } else if (table == "Regions") {
    con <- DBI::dbConnect(RSQLite::SQLite(), WDNnL_db_path)
    Regions <- DBI::dbReadTable(con, "Regions")
    final_dataframe <- as.data.frame(Regions)
    dbDisconnect(con)

  } else if (table == "Taxonomy") {
    con <- DBI::dbConnect(RSQLite::SQLite(), WDNnL_db_path)
    Regions <- DBI::dbReadTable(con, "Taxonomy")
    final_dataframe <- as.data.frame(Taxonomy)
    dbDisconnect(con)}

  obj_name <- if (version == "" || is.null(version) || is.na(version)) {
    table
  } else {
    paste0(table,"V", version)
  }
  assign(obj_name, final_dataframe, envir = .GlobalEnv)

  if (is.null(version) || version == "" || is.na(version)) {
    cat(paste0("For current version please use data(\"", table, "\") instead.\n"))}
}


.get_WDNnL_db_current <- function() {
  cache_dir <- tools::R_user_dir("WnDD", which = "cache")
  dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)

  db_path <- file.path(cache_dir, "mydb.sqlite")

  if (!file.exists(db_path)) {
    download.file(
      "https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/main/Current%20Version/mydb.sqlite",
      db_path,
      mode = "wb"
    )
  }

  db_path
}


.get_WDNnL_db_previous <- function(version) {
  cache_dir <- tools::R_user_dir("WnDD", which = "cache")
  dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)

  db_path <- file.path(cache_dir, "mydb.sqlite")

  if (!file.exists(db_path)) {
    download.file(
      paste0("https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/main/Previous%20Versions/V",version,"/mydb.sqlite"),
      db_path,
      mode = "wb"
    )
  }

  db_path
}
