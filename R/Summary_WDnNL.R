#' Summarize WDnNL
#'
#' @param object A WDnNL dataframe
#' @param include_non_established TRUE or FALSE - define if keep only established species or all
#' @param include_absent_establishment_data TRUE or FALSE - define if keep records with NA's on establishement data
#' @param include_intentional TRUE or FALSE - define if keep records from intentional release
#' @param include_absent_intentional_data TRUE or FALSE - define if keep records with NA's on intentional release
#' @param include_cryptogenic TRUE or FALSE - define if keep records with cryptogenic origin
#' @param include_absent_cryptogenic_data TRUE or FALSE - define if keep records with NA's on cryptogenic origin
#' @param include_non_Introduced TRUE or FALSE - define if keep species that arrived through natural dispersal
#' @param include_absent_Introduced_data TRUE or FALSE - define if keep records with NA's on introduction origin
#' @param family_list A list with Lepidoptera families
#' @param include_eradicated_data TRUE or FALSE - define if keep records with NA's on erradicated
#' @param include_eradication_records TRUE or FALSE - define if keep records with successful erradication
#' @param include_records_pre_eradication TRUE or FALSE - define if keep records of introductions after erradications
#' @param country_list A list of Countries
#' @param continent_list A list of Continents
#' @param realm_list A list of Biogeographic Realms
#'
#' @returns Summary of the dataframe as a summary.WDnNL object
#' @export
#'
#' @examples
#' # summary(WDnNL)
#'
#' # summary(WDnNL,
#'           include_non_established = FALSE,
#'           include_absent_establishment_data = FALSE,
#'           include_cryptogenic = FALSE,
#'           include_non_Introduced = FALSE,
#'           family_list = c("Noctuidae", "Gelechiidae", "Tortricidae"))
#'
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


  if (!is.null(family_list)) {object <- object[object$Family %in% family_list, ]}
  if (!is.null(country_list)) {object <- object[object$Country %in% country_list, ]}
  if (!is.null(continent_list)) {object <- object[object$Continent %in% continent_list, ]}
  if (!is.null(realm_list)) {object <- object[object$Realm %in% realm_list, ]}
  if (!include_non_established) {object <- object[object$Established != 0 | is.na(object$Established), ]}
  if (!include_intentional) {object <- object[object$IntentionalRelease != 1 | is.na(object$IntentionalRelease),  ]}
  if (!include_cryptogenic) {object <- object[object$Cryptogenic != 1 | is.na(object$Cryptogenic), ]}
  if (!include_non_Introduced) {object <- object[object$Introduced != 0 | is.na(object$Introduced), ]}
  if (!include_absent_establishment_data) {object <- object[!is.na(object$Established), ]}
  if (!include_absent_intentional_data) {object <- object[!is.na(object$IntentionalRelease), ]}
  if (!include_absent_cryptogenic_data) {object <- object[!is.na(object$Cryptogenic), ]}
  if (!include_absent_Introduced_data) {object <- object[!is.na(object$Introduced), ]}
  if (!include_eradicated_data) {object <- object[!is.na(object$Eradicated), ]}
  if (!include_eradication_records) {object <- object[object$Eradicated != 1 | is.na(object$Eradicated), ]}
  if (!include_records_pre_eradication) {object <- object}
  if (!include_records_pre_eradication) {
    filtered_data <- object %>% filter(Eradicated == 1)
    erad_years <- filtered_data %>% group_by(AcceptedSpecies, AreaName) %>%
      summarise( ReferenceYear = max(ReferenceYear, na.rm = FALSE),
                 .groups = "drop")
    names(erad_years)[names(erad_years) == "ReferenceYear"] <- "EradicationYear"
    object <- merge(object,erad_years, by = c("AcceptedSpecies", "AreaName"), all.x = TRUE)
    object <- object %>% filter(is.na(EradicationYear) | ReferenceYear >= EradicationYear)
    object$EradicationYear <- NULL}

  if(nrow(object) == 0) {stop("Data table is empty.\n")}

  total_records <- nrow(object)
  total_species <- length(unique(object$AcceptedSpecies))
  total_families <- length(unique(object$Family))
  total_regions <- length(unique(object$AreaName))
  total_countries <- length(unique(object$Country))
  total_continents <- length(unique(object$Continent))
  total_realms <- length(unique(object$Realm))
  total_references <- length(unique(object$BibliographicReference))
  top_species <- names(head(sort(table(object$AcceptedSpecies), decreasing = TRUE), 1))
  top_family <- names(head(sort(table(object$Family), decreasing = TRUE), 1))
  top_regions   <- names(head(sort(table(object$AreaName), decreasing = TRUE), 1))
  top_reference <- names(head(sort(table(object$BibliographicReference), decreasing = TRUE), 1))
  oldest_record_year <- min(object$Year, na.rm = TRUE)
  oldest_reference <- min(object$ReferenceYear, na.rm = TRUE)
  most_prevalent_species_records <- as.integer(head(sort(table(object$AcceptedSpecies), decreasing = TRUE), 1))
  most_prevalent_family_records <- as.integer(head(sort(table(object$Family), decreasing = TRUE), 1))
  most_prevalent_region_records <- as.integer(head(sort(table(object$AreaName), decreasing = TRUE), 1))
  most_prevalent_reference_records <- as.integer(head(sort(table(object$BibliographicReference), decreasing = TRUE), 1))

  result <- list (total_records = total_records,
                  total_species = total_species,
                  total_families = total_families,
                  total_regions = total_regions,
                  total_countries = total_countries,
                  total_continents = total_continents,
                  total_realms = total_realms,
                  total_references = total_references,
                  top_species = top_species,
                  top_family = top_family,
                  top_regions = top_regions,
                  top_reference = top_reference,
                  oldest_record_year = oldest_record_year,
                  oldest_reference = oldest_reference,
                  most_prevalent_species_records = most_prevalent_species_records,
                  most_prevalent_family_records = most_prevalent_family_records,
                  most_prevalent_region_records = most_prevalent_region_records,
                  most_prevalent_reference_records = most_prevalent_reference_records)

  class(result) <- "summary.WDnNL"
  return(result)
}


#' Print method for WDnNL summary
#'
#' @param x A summary.WDnNL object
#' @param ... Not Used
#'
#' @returns A printed summary of the WDnNL dataframe
#' @export
print.summary.WDnNL <- function(x, ...) {

  truncate <- function(x, max_chars = 65) {
    x <- as.character(x)
    ifelse(nchar(x) > max_chars, paste0(substr(x, 1, max_chars - 3), "..."), x)}


  records_table <- data.frame(
    Metric = c(
      "Total Records:",
      "Total References:",
      "Most Prevalent Reference:",
      "Most Prevalent Reference - Number of Records:",
      "Oldest Record Year:",
      "Oldest Reference:"),
    Value = c(
      x$total_records,
      x$total_references,
      truncate(x$top_reference),
      x$most_prevalent_reference_records,
      x$oldest_record_year,
      x$oldest_reference),
    row.names = NULL)

  species_table <- data.frame(
    Metric = c(
      "Total Species:",
      "Total Families:",
      "Most prevalent Species:",
      "Most prevalent Family:",
      "Most prevalent Species - Number of Records:",
      "Most prevalent Family - Number of Records:"),
    Value = c(
      x$total_species,
      x$total_families,
      x$top_species,
      x$top_family,
      x$most_prevalent_species_records,
      x$most_prevalent_family_records),
    row.names = NULL)

  regions_table <- data.frame(
    Metric = c(
      "Total regions:",
      "Total countries:",
      "Total continents:",
      "Total realms:",
      "Most invaded Region:",
      "Invasion Records - Most Invaded Region:"),
    Value = c(
      x$total_regions,
      x$total_countries,
      x$total_continents,
      x$total_realms,
      x$top_regions,
      x$most_prevalent_region_records),
    row.names = NULL)

  cat("\n=============================================================================================\n")
  cat("                                     WDnNL summary\n")
  cat("=============================================================================================\n")

  cat("\n---------------------------------------------------------------------------------------------\n")
  cat("Records overview\n")
  cat("---------------------------------------------------------------------------------------------\n")
  write.table(records_table, row.names = FALSE, col.names = FALSE, quote = FALSE)

  cat("\n---------------------------------------------------------------------------------------------\n")
  cat("Species overview\n")
  cat("---------------------------------------------------------------------------------------------\n")
  write.table(species_table, row.names = FALSE, col.names = FALSE, quote = FALSE)

  cat("\n---------------------------------------------------------------------------------------------\n")
  cat("Regions overview\n")
  cat("---------------------------------------------------------------------------------------------\n")
  write.table(regions_table, row.names = FALSE, col.names = FALSE, quote = FALSE)

  invisible(x)
}


#' Summary of the CondensedWDnNL as a summary.CondensedWDnNL object
#'
#' @param object A CondensedWDnNL dataframe
#' @param include_non_established TRUE or FALSE - define if keep only established species or all
#' @param include_absent_establishment_data TRUE or FALSE - define if keep records with NA's on establishement data
#' @param include_intentional TRUE or FALSE - define if keep records from intentional release
#' @param include_absent_intentional_data TRUE or FALSE - define if keep records with NA's on intentional release
#' @param include_cryptogenic TRUE or FALSE - define if keep records with cryptogenic origin
#' @param include_absent_cryptogenic_data TRUE or FALSE - define if keep records with NA's on cryptogenic origin
#' @param include_non_Introduced TRUE or FALSE - define if keep species that arrived through natural dispersal
#' @param include_absent_Introduced_data TRUE or FALSE - define if keep records with NA's on introduction origin
#' @param include_eradicated_data TRUE or FALSE - define if keep records with NA's on erradicated
#' @param include_eradication_records TRUE or FALSE - define if keep records with successful erradication
#' @param include_records_pre_eradication TRUE or FALSE - define if keep records of introductions after erradications
#' @param continent_list A list of Continents
#' @param realm_list A list of Biogeographic Realms
#' @returns A printed summary of the CondensedWDnNL
#' @export

summary.CondensedWDnNL <- function(
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
    continent_list = NULL,
    realm_list = NULL) {

  if (!is.null(continent_list)) {object <- object[object$Continent %in% continent_list, ]}
  if (!is.null(realm_list)) {object <- object[object$Realm %in% realm_list, ]}
  if (!include_non_established) {object <- object[object$Established != 0 | is.na(object$Established), ]}
  if (!include_intentional) {object <- object[object$IntentionalRelease != 1 | is.na(object$IntentionalRelease),  ]}
  if (!include_cryptogenic) {object <- object[object$Cryptogenic != 1 | is.na(object$Cryptogenic), ]}
  if (!include_non_Introduced) {object <- object[object$Introduced != 0 | is.na(object$Introduced), ]}
  if (!include_absent_establishment_data) {object <- object[!is.na(object$Established), ]}
  if (!include_absent_intentional_data) {object <- object[!is.na(object$IntentionalRelease), ]}
  if (!include_absent_cryptogenic_data) {object <- object[!is.na(object$Cryptogenic), ]}
  if (!include_absent_Introduced_data) {object <- object[!is.na(object$Introduced), ]}
  if (!include_eradicated_data) {object <- object[!is.na(object$Eradicated), ]}
  if (!include_eradication_records) {object <- object[object$Eradicated != 1 | is.na(object$Eradicated), ]}

  if(nrow(object) == 0) {stop("Data table is empty.\n")}

  total_records <- nrow(object)
  total_species <- length(unique(object$AcceptedSpecies))
  total_regions <- length(unique(object$AreaName))
  total_continents <- length(unique(object$Continent))
  total_realms <- length(unique(object$Realm))
  top_species <- names(head(sort(table(object$AcceptedSpecies), decreasing = TRUE), 1))
  top_regions   <- names(head(sort(table(object$AreaName), decreasing = TRUE), 1))
  oldest_record_year <- min(object$First_Observation, na.rm = TRUE)
  most_prevalent_species_records <- as.integer(head(sort(table(object$AcceptedSpecies), decreasing = TRUE), 1))
  most_prevalent_region_records <- as.integer(head(sort(table(object$AreaName), decreasing = TRUE), 1))

  result <- list (total_records = total_records,
                  total_species = total_species,
                  total_regions = total_regions,
                  total_continents = total_continents,
                  total_realms = total_realms,
                  top_species = top_species,
                  top_regions = top_regions,
                  oldest_record_year = oldest_record_year,
                  most_prevalent_species_records = most_prevalent_species_records,
                  most_prevalent_region_records = most_prevalent_region_records)


  class(result) <- "summary.CondensedWDnNL"
  return(result)
}


#' Print method for CondensedWDnNL summary
#'
#' @param x A summary.CondensedWDnNL object
#' @param ... Not Used
#'
#' @returns A printed summary of the dataframe
#' @export

print.summary.CondensedWDnNL <- function(x, ...) {

  truncate <- function(x, max_chars = 65) {
    x <- as.character(x)
    ifelse(nchar(x) > max_chars, paste0(substr(x, 1, max_chars - 3), "..."), x)}


  records_table <- data.frame(
    Metric = c(
      "Total Records:",
      "Oldest Record Year:"),
    Value = c(
      x$total_records,
      x$oldest_record_year),
    row.names = NULL)

  species_table <- data.frame(
    Metric = c(
      "Total Species:",
      "Most prevalent Species:",
      "Most prevalent Species - Number of Records:"),
    Value = c(
      x$total_species,
      x$top_species,
      x$most_prevalent_species_records),
    row.names = NULL)

  regions_table <- data.frame(
    Metric = c(
      "Total regions:",
      "Total continents:",
      "Total realms:",
      "Most invaded Region:",
      "Invasion Records - Most Invaded Region:"),
    Value = c(
      x$total_regions,
      x$total_continents,
      x$total_realms,
      x$top_regions,
      x$most_prevalent_region_records),
    row.names = NULL)

  cat("\n=============================================================================================\n")
  cat("                                     WDnNL summary\n")
  cat("=============================================================================================\n")

  cat("\n---------------------------------------------------------------------------------------------\n")
  cat("Records overview\n")
  cat("---------------------------------------------------------------------------------------------\n")
  write.table(records_table, row.names = FALSE, col.names = FALSE, quote = FALSE)

  cat("\n---------------------------------------------------------------------------------------------\n")
  cat("Species overview\n")
  cat("---------------------------------------------------------------------------------------------\n")
  write.table(species_table, row.names = FALSE, col.names = FALSE, quote = FALSE)

  cat("\n---------------------------------------------------------------------------------------------\n")
  cat("Regions overview\n")
  cat("---------------------------------------------------------------------------------------------\n")
  write.table(regions_table, row.names = FALSE, col.names = FALSE, quote = FALSE)

  invisible(x)
}
