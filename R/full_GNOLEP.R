#' All Individual GNOLEP tables imports
#'
#'
#' @returns Import all individual database tables at once.
#' @export
#' @examples
#' # full_GNOLEP()
#'
individual_GNOLEP <- function() {
  data(NativesGNOLEP)
  data(RealmsGNOLEP)
  data(RecordsGNOLEP)
  data(ReferencesGNOLEP)
  data(RegionsGNOLEP)
  data(TaxonomyGNOLEP)}


library(gh)
library(jsonlite)

#' Import older versions of GNOLEP
#'
#'
#' @returns Import all database tables at once.
#' @export
#' @examples
#'
#' # GNOLEP_extract(NativesGNOLEP, version = 0)
#' # GNOLEP_extract(ReferencesGNOLEP, version = 0)
#' # GNOLEP_extract(GNOLEP, version = 0)
#' # GNOLEP_extract(CondensedGNOLEP, version = 0)
#'
#'
#'
GNOLEP_extract <- function(table, version = "", destination_file = NULL) {

  valid_tables <- c("NativesGNOLEP", "RealmsGNOLEP", "RecordsGNOLEP", "ReferencesGNOLEP",
    "RegionsGNOLEP", "TaxonomyGNOLEP", "GNOLEP", "CondensedGNOLEP")

  base_tables <- c("NativesGNOLEP", "RealmsGNOLEP", "RecordsGNOLEP",
    "ReferencesGNOLEP", "RegionsGNOLEP", "TaxonomyGNOLEP")
  csv_names <- c(
    NativesGNOLEP = "Obs_NativesDB.csv",
    RealmsGNOLEP = "Geography_Realms.csv",
    RecordsGNOLEP = "Obs_Records_DB.csv",
    ReferencesGNOLEP = "Base_References.csv",
    RegionsGNOLEP = "Geography_Regions.csv",
    TaxonomyGNOLEP = "Base_Taxonomy.csv")


  if (!table %in% valid_tables) {
    stop(sprintf("'%s' is not valid. Choose one of: %s.",
                 table, paste(valid_tables, collapse = ", ")), call. = FALSE)}

  if (is.null(version) || version == "" || is.na(version)) {
    message(sprintf("For the current version of the database please use data(%s) instead.", table))
    return(invisible(data(list = table)))}


  fetch_csv <- function(tbl) {

    tmp <- tempfile(fileext = ".csv")
    on.exit(unlink(tmp), add = TRUE)

    filename <- csv_names[[tbl]]

    raw_url <- paste0(
      "https://raw.githubusercontent.com/hncouto/Global_Database_on_Non-native_Lepidoptera/main/Previous%20Versions/V",version,
      "/", tbl, URLencode(filename))

    dl <- GET(raw_url, write_disk(tmp, overwrite = TRUE))

    ###### While database is private it will use this (will be delete when public):
    if (status_code(dl) != 200) {
      file_path <- URLencode(
        paste0("Previous Versions/V", version, "/", filename))

      api_url <- paste0(
        "https://api.github.com/repos/hncouto/Global_Database_on_Non-native_Lepidoptera/contents/",
        file_path)

      res <- GET(
        api_url,
        add_headers(Authorization = paste("Bearer", Sys.getenv("GITHUB_PAT"))))

      if (status_code(res) == 404) {
        stop(sprintf("Version '%s' is not available or table '%s' does not exist in that version.",version, tbl), call. = FALSE)}

      if (status_code(res) != 200) {stop(sprintf("GitHub API returned status %s.", httr::status_code(res)), call. = FALSE)}

      download_url <- content(res, as = "parsed")$download_url
      if (is.null(download_url)) {stop("Could not retrieve download URL from GitHub API.", call. = FALSE)}

      dl <- GET(
        download_url,
        add_headers(Authorization = paste("Bearer", Sys.getenv("GITHUB_PAT"))),
        write_disk(tmp, overwrite = TRUE))

      if (status_code(dl) != 200) {
        stop(sprintf("Failed to download '%s' (HTTP %s).", tbl, status_code(dl)),
             call. = FALSE)}}

    #########

    read.csv(tmp, check.names = FALSE, encoding = "UTF-8")}

  build_GNOLEP <- function(tables) {
    Taxonomy_keyd <- tables$TaxonomyGNOLEP %>%
      left_join(
        tables$TaxonomyGNOLEP %>%
          select(GNOLEP.speciesID, Species) %>%
          rename(GNOLEP.acceptedSpeciesID = GNOLEP.speciesID,
                 GNOLEP.acceptedSpecies = dwc.scientificName),
        by = "GNOLEP.acceptedSpeciesID")

    GNOLEP <- tables$RecordsGNOLEP %>%
      left_join(Taxonomy_keyd, by = "GNOLEP.speciesID") %>%
      left_join(tables$RegionsGNOLEP, by = "GNOLEP.areaID") %>%
      left_join(tables$RealmsGNOLEP, by = "GNOLEP.realmID") %>%
      left_join(tables$ReferencesGNOLEP, by = "GNOLEP.referenceID") %>%
      select(-GNOLEP.speciesID, -GNOLEP.areaID, -GNOLEP.realmID, -GNOLEP.referenceID, -GNOLEP.acceptedSpeciesID)
    class(GNOLEP) <- append("GNOLEP", class(GNOLEP))
    GNOLEP}

  build_CondensedGNOLEP <- function(tables) {
    pick_first_non_na <- function(value, rank) {
      idx <- which(!is.na(value))
      if (length(idx) == 0) return(NA)
      value[idx[which.min(rank[idx])]]}
    Taxonomy_keyd <- tables$TaxonomyGNOLEP %>%
      left_join(tables$TaxonomyGNOLEP %>%
                  select(GNOLEP.speciesID, dwc.scientificName) %>%
                  rename(GNOLEP.acceptedSpeciesID = GNOLEP.speciesID,
                         GNOLEP.acceptedSpecies = dwc.scientificName), by = "GNOLEP.acceptedSpeciesID") %>%
      select(GNOLEP.speciesID, GNOLEP.acceptedSpeciesID, GNOLEP.acceptedSpecies)
    Observations <- tables$RecordsGNOLEP %>%
      inner_join(Taxonomy_keyd, by = "GNOLEP.speciesID") %>%
      inner_join(tables$RegionsGNOLEP, by = "GNOLEP.areaID") %>%
      inner_join(tables$RealmsGNOLEP, by = "GNOLEP.realmID") %>%
      inner_join(tables$ReferencesGNOLEP, by = "GNOLEP.referenceID") %>%
      select(-GNOLEP.speciesID, -GNOLEP.areaID, -GNOLEP.realmID, -GNOLEP.referenceID, -GNOLEP.acceptedSpeciesID)

    RankedObservations <- Observations %>%
      rename(dwc.scientificName = GNOLEP.acceptedSpecies) %>%
      filter(GNOLEP.introduced == 1 | is.na(GNOLEP.introduced)) %>%
      group_by(dwc.scientificName, dwc.verbatimLocality, GNOLEP.realm) %>%
      mutate(RefRank = row_number(desc(GNOLEP.referenceYear))) %>%
      ungroup() %>%
      group_by(dwc.scientificName, dwc.verbatimLocality, GNOLEP.realm) %>%
      mutate(dwc.year = min(dwc.year, na.rm = TRUE)) %>%
      ungroup()

    ObservationsSummary <- RankedObservations %>%
      group_by(dwc.scientificName, dwc.verbatimLocality, dwc.continent, GNOLEP.realm, dwc.year) %>%
      summarise(GNOLEP.cryptogenic = pick_first_non_na(GNOLEP.cryptogenic, RefRank),
                GNOLEP.dispersal = pick_first_non_na(GNOLEP.dispersal, RefRank),
                GNOLEP.eradicated = pick_first_non_na(GNOLEP.eradicated, RefRank),
                GNOLEP.established = pick_first_non_na(GNOLEP.established, RefRank),
                GNOLEP.intentionalRelease = pick_first_non_na(GNOLEP.intentionalRelease, RefRank),
                GNOLEP.introduced = pick_first_non_na(GNOLEP.introduced, RefRank),
                Latest_Reference = dwc.associatedReferences[which.min(ifelse(RefRank == 1, 0, 1))][1],
                Latest_Reference_Year = GNOLEP.referenceYear[RefRank == 1][1],
          .groups = "drop")
    CondensedGNOLEP <- ObservationsSummary %>%
      mutate(dwc.year = dplyr::if_else(is.infinite(dwc.year),NA_real_,
            dwc.year))
    class(CondensedGNOLEP) <- c("CondensedGNOLEP", "data.frame")
    CondensedGNOLEP}

  if (table %in% base_tables) {
    data <- fetch_csv(table)}
  else {message("Assembling '", table, "', this may take a while.")
    tables <- stats::setNames(lapply(base_tables, fetch_csv), base_tables)
    data <- if (table == "GNOLEP") build_GNOLEP(tables) else build_CondensedGNOLEP(tables)}

  if (!is.null(destination_file)) {
    utils::write.csv(data, file = destination_file, row.names = FALSE)
    message(sprintf("File saved to '%s'.", destination_file))
    return(invisible(data))}

  assign(table, data, envir = .GlobalEnv)
  invisible(data)}

