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
          select(SpeciesID, Species) %>%
          rename(AcceptedSpeciesID = SpeciesID,
                 AcceptedSpecies = Species),
        by = "AcceptedSpeciesID")

    GNOLEP <- tables$RecordsGNOLEP %>%
      left_join(Taxonomy_keyd, by = "SpeciesID") %>%
      left_join(tables$RegionsGNOLEP, by = "AreaID") %>%
      left_join(tables$RealmsGNOLEP, by = "RealmID") %>%
      left_join(tables$ReferencesGNOLEP, by = "ReferenceID") %>%
      select(-SpeciesID, -AreaID, -RealmID, -ReferenceID, -AcceptedSpeciesID)
    class(GNOLEP) <- append("GNOLEP", class(GNOLEP))
    GNOLEP}

  build_CondensedGNOLEP <- function(tables) {
    pick_first_non_na <- function(value, rank) {
      idx <- which(!is.na(value))
      if (length(idx) == 0) return(NA)
      value[idx[which.min(rank[idx])]]}
    Taxonomy_keyd <- tables$TaxonomyGNOLEP %>%
      left_join(tables$TaxonomyGNOLEP %>%
                  select(SpeciesID, Species) %>%
                  rename(AcceptedSpeciesID = SpeciesID,
                  AcceptedSpecies = Species), by = "AcceptedSpeciesID") %>%
      select(SpeciesID, AcceptedSpeciesID, AcceptedSpecies)
    Observations <- tables$RecordsGNOLEP %>%
      inner_join(Taxonomy_keyd, by = "SpeciesID") %>%
      inner_join(tables$RegionsGNOLEP, by = "AreaID") %>%
      inner_join(tables$RealmsGNOLEP, by = "RealmID") %>%
      inner_join(tables$ReferencesGNOLEP, by = "ReferenceID") %>%
      select(-SpeciesID, -AreaID, -RealmID, -ReferenceID, -AcceptedSpeciesID)

    RankedObservations <- Observations %>%
      filter(Introduced == 1 | is.na(Introduced)) %>%
      group_by(AcceptedSpecies, AreaName, Realm) %>%
      mutate(RefRank = row_number(desc(ReferenceYear))) %>%
      ungroup() %>%
      group_by(AcceptedSpecies, AreaName, Realm) %>%
      mutate(First_Record = min(Year, na.rm = TRUE)) %>%
      ungroup()

    ObservationsSummary <- RankedObservations %>%
      group_by(AcceptedSpecies, AreaName, Continent, Realm, First_Record) %>%
      summarise(Cryptogenic = pick_first_non_na(Cryptogenic, RefRank),
                Dispersal = pick_first_non_na(Dispersal, RefRank),
                Eradicated = pick_first_non_na(Eradicated, RefRank),
                Established = pick_first_non_na(Established, RefRank),
                IntentionalRelease = pick_first_non_na(IntentionalRelease, RefRank),
                Introduced = pick_first_non_na(Introduced, RefRank),
                Latest_Reference = BibliographicReference[which.min(ifelse(RefRank == 1, 0, 1))][1],
                Latest_Reference_Year = ReferenceYear[RefRank == 1][1],
          .groups = "drop")
    CondensedGNOLEP <- ObservationsSummary %>%
      mutate(First_Record = dplyr::if_else(is.infinite(First_Record),NA_real_,
            First_Record))
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

