#' All Individual WDnNL tables imports
#'
#'
#' @returns Import all individual database tables at once.
#' @export
#' @examples
#' # full_WDnNL()
#'
individual_WDnNL <- function() {
  data(NativesWDnNL)
  data(RealmsWDnNL)
  data(RecordsWDnNL)
  data(ReferencesWDnNL)
  data(RegionsWDnNL)
  data(TaxonomyWDnNL)}


library(gh)
library(jsonlite)

#' Import older versions of WDnNL
#'
#'
#' @returns Import all database tables at once.
#' @export
#' @examples
#'
#' # WDnNL_extract(NativesWDnNL, version = 0)
#' # WDnNL_extract(ReferencesWDnNL, version = 0)
#' # WDnNL_extract(WDnNL, version = 0)
#' # WDnNL_extract(CondensedWDnNL, version = 0)
#'
#'
#'
WDnNL_extract <- function(table, version = "", destination_file = NULL) {

  valid_tables <- c("NativesWDnNL", "RealmsWDnNL", "RecordsWDnNL", "ReferencesWDnNL",
    "RegionsWDnNL", "TaxonomyWDnNL", "WDnNL", "CondensedWDnNL")

  if (!table %in% valid_tables) {
    stop(sprintf("'%s' is not valid. Choose one of: %s.",
                 table, paste(valid_tables, collapse = ", ")), call. = FALSE)}

  if (is.null(version) || version == "" || is.na(version)) {
    stop(sprintf("For the current version of the database please use data(%s) instead.", table))}

      #URL = paste0("https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/tree/main/Previous%20Versions/V",version)
      #status <- tryCatch(httr::HEAD(url)$status_code, error = function(e) NULL)
      #if (is.null(status) || status != 200) {stop(sprintf("Version '%s' is not available. Please select a valid version of the database.",version), call. = FALSE)}


      url <- paste0("/repos/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/contents/Previous Versions/V", version)
      res <- GET(url,add_headers(Authorization = paste("Bearer", Sys.getenv("GITHUB_PAT"))))
      if (status_code(res) == 404) {stop(sprintf("Version '%s' is not available. Please select a valid version of the database.", version),call. = FALSE)}
      if (status_code(res) != 200) {stop(sprintf("GitHub API returned status %s.",status_code(res)),call. = FALSE)}



      #DEFINE PATH FOR VERSION
      #CHECK IF VERSION EXISTS IF NOT RETURN ERROR MESSAGE: VERSION DOES NOT EXIST

    if (table == "NativesWDnNL"){}

    if (table == "RealmsWDnNL"){}
    if (table == "RecordsWDnNL"){}
    if (table == "ReferencesWDnNL"){}
    if (table == "RegionsWDnNL"){}
    if (table == "TaxonomyWDnNL"){}
    if (table == "WDnNL"){}
    if (table == "CondensedWDnNL"){}
    }

