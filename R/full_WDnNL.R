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

  base_tables <- c("NativesWDnNL", "RealmsWDnNL", "RecordsWDnNL",
    "ReferencesWDnNL", "RegionsWDnNL", "TaxonomyWDnNL")
  csv_names <- c(
    NativesWDnNL = "Obs_NativesDB.csv",
    RealmsWDnNL = "Geography_Realms.csv",
    RecordsWDnNL = "Obs_Records_DB.csv",
    ReferencesWDnNL = "Base_References.csv",
    RegionsWDnNL = "Geography_Regions.csv",
    TaxonomyWDnNL = "Base_Taxonomy.csv")


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
      "https://raw.githubusercontent.com/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/main/Previous%20Versions/V",version,
      "/", tbl, URLencode(filename))

    dl <- GET(raw_url, write_disk(tmp, overwrite = TRUE))

    ###### While database is private it will use this (will be delete when public):
    if (status_code(dl) != 200) {
      file_path <- URLencode(
        paste0("Previous Versions/V", version, "/", filename))

      api_url <- paste0(
        "https://api.github.com/repos/hncouto/Worldwide_Database_on_Non-native_Lepidoptera/contents/",
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

  build_WDnNL <- function(tables) {
    Taxonomy_keyd <- tables$TaxonomyWDnNL %>%
      left_join(
        tables$TaxonomyWDnNL %>%
          select(SpeciesID, Species) %>%
          rename(AcceptedSpeciesID = SpeciesID,
                 AcceptedSpecies = Species),
        by = "AcceptedSpeciesID")

    WDnNL <- tables$RecordsWDnNL %>%
      left_join(Taxonomy_keyd, by = "SpeciesID") %>%
      left_join(tables$RegionsWDnNL, by = "AreaID") %>%
      left_join(tables$RealmsWDnNL, by = "RealmID") %>%
      left_join(tables$ReferencesWDnNL, by = "ReferenceID") %>%
      select(-SpeciesID, -AreaID, -RealmID, -ReferenceID, -AcceptedSpeciesID)
    class(WDnNL) <- append("WDnNL", class(WDnNL))
    WDnNL}

  build_CondensedWDnNL <- function(tables) {
    pick_first_non_na <- function(value, rank) {
      idx <- which(!is.na(value))
      if (length(idx) == 0) return(NA)
      value[idx[which.min(rank[idx])]]}
    Taxonomy_keyd <- tables$TaxonomyWDnNL %>%
      left_join(tables$TaxonomyWDnNL %>%
                  select(SpeciesID, Species) %>%
                  rename(AcceptedSpeciesID = SpeciesID,
                  AcceptedSpecies = Species), by = "AcceptedSpeciesID") %>%
      select(SpeciesID, AcceptedSpeciesID, AcceptedSpecies)
    Observations <- tables$RecordsWDnNL %>%
      inner_join(Taxonomy_keyd, by = "SpeciesID") %>%
      inner_join(tables$RegionsWDnNL, by = "AreaID") %>%
      inner_join(tables$RealmsWDnNL, by = "RealmID") %>%
      inner_join(tables$ReferencesWDnNL, by = "ReferenceID") %>%
      select(-SpeciesID, -AreaID, -RealmID, -ReferenceID, -AcceptedSpeciesID)

    RankedObservations <- Observations %>%
      filter(Introduced == 1 | is.na(Introduced)) %>%
      group_by(AcceptedSpecies, AreaName, Realm) %>%
      mutate(RefRank = row_number(desc(ReferenceYear))) %>%
      ungroup() %>%
      group_by(AcceptedSpecies, AreaName, Realm) %>%
      mutate(First_Observation = min(Year, na.rm = TRUE)) %>%
      ungroup()

    ObservationsSummary <- RankedObservations %>%
      group_by(AcceptedSpecies, AreaName, Continent, Realm, First_Observation) %>%
      summarise(Cryptogenic = pick_first_non_na(Cryptogenic, RefRank),
                Dispersal = pick_first_non_na(Dispersal, RefRank),
                Eradicated = pick_first_non_na(Eradicated, RefRank),
                Established = pick_first_non_na(Established, RefRank),
                IntentionalRelease = pick_first_non_na(IntentionalRelease, RefRank),
                Introduced = pick_first_non_na(Introduced, RefRank),
                Latest_Reference = BibliographicReference[which.min(ifelse(RefRank == 1, 0, 1))][1],
                Latest_Reference_Year = ReferenceYear[RefRank == 1][1],
          .groups = "drop")
    CondensedWDnNL <- ObservationsSummary %>%
      mutate(First_Observation = dplyr::if_else(is.infinite(First_Observation),NA_real_,
            First_Observation))
    class(CondensedWDnNL) <- c("CondensedWDnNL", "data.frame")
    CondensedWDnNL}

  if (table %in% base_tables) {
    data <- fetch_csv(table)}
  else {message("Assembling '", table, "', this may take a while.")
    tables <- stats::setNames(lapply(base_tables, fetch_csv), base_tables)
    data <- if (table == "WDnNL") build_WDnNL(tables) else build_CondensedWDnNL(tables)}

  if (!is.null(destination_file)) {
    utils::write.csv(data, file = destination_file, row.names = FALSE)
    message(sprintf("File saved to '%s'.", destination_file))
    return(invisible(data))}

  assign(table, data, envir = .GlobalEnv)
  invisible(data)}

