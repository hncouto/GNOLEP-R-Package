#' Title
#'
#' @param object
#' @param include_non_established
#' @param include_absent_establishment_data
#' @param include_intentional
#' @param include_absent_intentional_data
#' @param include_cryptogenic
#' @param include_absent_cryptogenic_data
#' @param include_non_Introduced
#' @param include_absent_Introduced_data
#' @param family_list
#' @param include_eradicated_data
#' @param include_eradication_records
#' @param include_records_pre_eradication
#' @param country_list
#' @param continent_list
#' @param realm_list
#'
#' @returns
#' @export
#'
#' @examples
summary.WDnNL <- function(
    object,
    include_non_established = TRUE,
    include_absent_establishment_data = TRUE,
    include_intentional = TRUE,
    include_absent_intentional_data = TRUE,
    include_cryptogenic = TRUE,
    include_absent_cryptogenic_data = TRUE,
    include_non_Introduced = TRUE,
    include_absent_Introduced_data = TRUE,
    include_eradicated_data = TRUE,
    include_eradication_records = TRUE,
    include_records_pre_eradication = TRUE,
    family_list = NULL,
    country_list = NULL,
    continent_list = NULL,
    realm_list = NULL
) {
  if (!is.null(family_list)) {
    object <- object[object$Family %in% family_list, ]}

  if (!is.null(country_list)) {
    object <- object[object$Country %in% country_list, ]}

  if (!is.null(continent_list)) {
    object <- object[object$Continent %in% continent_list, ]}

  if (!is.null(realm_list)) {
    object <- object[object$Realm %in% realm_list, ]}

  if (!include_non_established) {
    object <- object[object$Established != 0 | is.na(object$Established), ]}

  if (!include_intentional) {
    object <- object[object$IntentionalRelease != 1 | is.na(object$IntentionalRelease),  ]}

  if (!include_cryptogenic) {
    object <- object[object$Cryptogenic != 1 | is.na(object$Cryptogenic), ]}

  if (!include_non_Introduced) {
    object <- object[object$Introduced != 0 | is.na(object$Introduced), ]}

  if (!include_absent_establishment_data) {
    object <- object[!is.na(object$Established), ]}

  if (!include_absent_intentional_data) {
    object <- object[!is.na(object$IntentionalRelease), ]}

  if (!include_absent_cryptogenic_data) {
    object <- object[!is.na(object$Cryptogenic), ]}

  if (!include_absent_Introduced_data) {
    object <- object[!is.na(object$Introduced), ]}

  if (!include_eradicated_data) {
    object <- object[!is.na(object$Eradicated), ]}

  if (!include_eradication_records) {
    object <- object[object$Eradicated != 1 | is.na(object$Eradicated), ]}

  if (!include_records_pre_eradication) {
    object <- object
  }

  if(nrow(object) == 0) {
    stop("Data table is empty.\n")}

  result <- list(
    total_records = total_records,
    total_species = total_species,
    total_families = total_families,
    total_regions = total_regions,
    total_countries = total_countries,
    total_continents = total_continents,
    total_realms = total_realms,
    top_species_records = top_species_records,
    top_regions_records = top_regions_records,
    oldest_record_year = oldest_record_year,
    temporal_impact_counts = temporal_impact_counts,
    temporal_score_by_type = temporal_score_by_type,
    parameters = parameters,
    data_summary = data_summary
  )

  return(result)
}
