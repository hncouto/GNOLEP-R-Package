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
  if (is.null(version) || version == "" || is.na(version)) {
    message(sprintf("For the current version of the database please use data(%s) instead.", table))
    } else {

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
  }
