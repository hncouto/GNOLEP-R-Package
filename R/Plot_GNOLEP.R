#' Plot Data Summaries
#'
#' @param object A GNOLEP object dataframe
#' @param OverTime Time trends of First Records in the selected dataset. I selected alone it will return global trends
#' @param ContinentalPlot Continental Trends in the selected dataset. If selected alone it will return a bar graph with data on continents.
#' @param RealmPlot Realm Trends in the selected dataset. If selected alone it will return a bar graph with data on biogeographic realms.
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
#' @param continent_list A list of Continents
#' @param realm_list A list of Biogeographic Realms
#'
#'
#' @returns Summary plots for the subset of GNOLEP selected.
#' @export
#'
#' @examples
#' # plot(GNOLEP)
#'
#' # plot(GNOLEP,
#'        OverTime = FALSE,
#'        ContinentalPlot = TRUE,
#'        include_non_established = FALSE,
#'        include_absent_establishment_data = FALSE,
#'        include_cryptogenic = FALSE,
#'        include_non_Introduced = FALSE,
#'        family_list = c("Noctuidae", "Gelechiidae", "Tortricidae"))
#'

plot.GNOLEP <- function(
    object,
    OverTime = TRUE,
    ContinentalPlot = FALSE,
    RealmPlot = FALSE,
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
    family_list = NULL,
    realm_list = NULL) {

  if (!is.null(family_list)) {object <- object[object$dwc.family %in% family_list, ]}
  if (!is.null(continent_list)) {object <- object[object$dwc.continent %in% continent_list, ]}
  if (!is.null(realm_list)) {object <- object[object$GNOLEP.realm %in% realm_list, ]}
  if (!include_non_established) {object <- object[object$GNOLEP.established != 0 | is.na(object$GNOLEP.established), ]}
  if (!include_intentional) {object <- object[object$GNOLEP.intentionalRelease != 1 | is.na(object$GNOLEP.intentionalRelease),  ]}
  if (!include_cryptogenic) {object <- object[object$GNOLEP.cryptogenic != 1 | is.na(object$GNOLEP.cryptogenic), ]}
  if (!include_non_Introduced) {object <- object[object$GNOLEP.introduced != 0 | is.na(object$GNOLEP.introduced), ]}
  if (!include_absent_establishment_data) {object <- object[!is.na(object$GNOLEP.established), ]}
  if (!include_absent_intentional_data) {object <- object[!is.na(object$GNOLEP.intentionalRelease), ]}
  if (!include_absent_cryptogenic_data) {object <- object[!is.na(object$GNOLEP.cryptogenic), ]}
  if (!include_absent_Introduced_data) {object <- object[!is.na(object$GNOLEP.introduced), ]}
  if (!include_eradicated_data) {object <- object[!is.na(object$GNOLEP.eradicated), ]}
  if (!include_eradication_records) {object <- object[object$GNOLEP.eradicated != 1 | is.na(object$GNOLEP.eradicated), ]}

  if(nrow(object) == 0) {stop("Data table is empty.\n")}
  if (!"dwc.year" %in% names(object)) {
    if (!"First_Record" %in% names(object)) {
      stop("Data table must contain either a 'dwc.year' or 'First_Record' column.\n")}
    names(object)[names(object) == "First_Record"] <- "dwc.year"}

  if (OverTime == TRUE && ContinentalPlot == FALSE && RealmPlot == FALSE){
    cum_GNOLEP_total <- object %>%
      filter(!is.na(dwc.year)) %>%
      count(dwc.year) %>%
      arrange(dwc.year) %>%
      mutate(cumulative = cumsum(n))

    plot(cum_GNOLEP_total$dwc.year,
      cum_GNOLEP_total$cumulative,
      type = "l",      # both points and lines
      xlab = "Year",
      ylab = "Cumulative number of records",
      ylim = c(0, 1.1 * max(cum_GNOLEP_total$cumulative)))

    if (interactive()) {readline(prompt = "Press [Enter] for next plot.")}

    plot(cum_GNOLEP_total$dwc.year,
      cum_GNOLEP_total$n,
      type = "p",      # both points and lines
      xlab = "Year",
      ylab = "Yearly number of records",
      ylim = c(0, 1.1 * max(cum_GNOLEP_total$n)))}

  if (OverTime == TRUE && ContinentalPlot == TRUE && RealmPlot == FALSE){

    continents <- unique(object$dwc.continent)
    continents <- continents[!is.na(continents)]

    for (ct in continents) {

      cat("\n--- Continent:", ct, "---\n")
      sub_object <- object[object$dwc.continent == ct, ]
      cum_GNOLEP_continent <- sub_object %>%
        filter(!is.na(dwc.year)) %>%
        count(dwc.year) %>%
        arrange(dwc.year) %>%
        mutate(cumulative = cumsum(n))

      # Skip empty continents safely
      if (nrow(cum_GNOLEP_continent) == 0) next

      # ---- Plot 1: cumulative ----
      plot(cum_GNOLEP_continent$dwc.year,
        cum_GNOLEP_continent$cumulative,
        type = "l",
        col = "black",
        main = paste("Cumulative records -", ct),
        xlab = "Year",
        ylab = "Cumulative number of records",
        ylim = c(0, 1.1 * max(cum_GNOLEP_continent$cumulative, na.rm = TRUE)))

      if (interactive()) {readline(prompt = "Press [Enter] for next plot...")}

      # ---- Plot 2: yearly ----
      plot(cum_GNOLEP_continent$dwc.year,
        cum_GNOLEP_continent$n,
        type = "p",
        col = "black",
        main = paste("Yearly records -", ct),
        xlab = "Year",
        ylab = "Yearly number of records",
        ylim = c(0, 1.1 * max(cum_GNOLEP_continent$n, na.rm = TRUE)))

      if (interactive()) {readline(prompt = "Press [Enter] for next continent...")}}
    }

  if (OverTime == TRUE && ContinentalPlot == FALSE && RealmPlot == TRUE){

      realms <- unique(object$GNOLEP.realm)
      realms <- realms[!is.na(realms)]

      for (rl in realms) {

        cat("\n--- Realm:", rl, "---\n")

        sub_object <- object[object$GNOLEP.realm == rl, ]

        cum_GNOLEP_realm <- sub_object %>%
          filter(!is.na(dwc.year)) %>%
          count(dwc.year) %>%
          arrange(dwc.year) %>%
          mutate(cumulative = cumsum(n))

        if (nrow(cum_GNOLEP_realm) == 0) next

        plot(
          cum_GNOLEP_realm$dwc.year,
          cum_GNOLEP_realm$cumulative,
          type = "l",
          col = "black",
          main = paste("Cumulative records -", rl),
          xlab = "Year",
          ylab = "Cumulative number of records",
          ylim = c(0, 1.1 * max(cum_GNOLEP_realm$cumulative, na.rm = TRUE))
        )

        if (interactive()) {readline(prompt = "Press [Enter] for next plot...")}

        plot(
          cum_GNOLEP_realm$dwc.year,
          cum_GNOLEP_realm$n,
          type = "p",
          col = "black",
          main = paste("Yearly records -", rl),
          xlab = "Year",
          ylab = "Yearly number of records",
          ylim = c(0, 1.1 * max(cum_GNOLEP_realm$n, na.rm = TRUE)))

        if (interactive()) {
          readline(prompt = "Press [Enter] for next realm")}}}

  if (OverTime == FALSE && ContinentalPlot == FALSE && RealmPlot == FALSE) {
      message("Please select OverTime = TRUE and/or ContinentalPlot/RealmPlot = TRUE.")}

  if (ContinentalPlot == TRUE && RealmPlot == TRUE) {
    message("Please select only one of ContinentalPlot or RealmPlot = TRUE.")}

  if (OverTime == FALSE && ContinentalPlot == TRUE && RealmPlot == FALSE) {
    continent_counts <- object %>%
      filter(!is.na(dwc.continent)) %>%
      count(dwc.continent)

    max_label_width <- max(strwidth(continent_counts$dwc.continent, units = "inches"))
    bottom_margin <- max(5, ceiling(max_label_width / par("csi")) + 2)
    oldpar <- par(no.readonly = TRUE)
    par(mar = c(bottom_margin, 4, 4, 2) + 0.1)

    barplot(
      continent_counts$n,
      names.arg = continent_counts$dwc.continent,
      col = "black",
      ylab = "Number of records",
      ylim = c(0, 1.1*max(continent_counts$n, na.rm = TRUE)),
      main = "Records per Continent",
      las = 2
    )

    par(oldpar)}

  if (OverTime == FALSE && ContinentalPlot == FALSE && RealmPlot == TRUE) {

    realm_counts <- object %>%
      filter(!is.na(GNOLEP.realm)) %>%
      count(GNOLEP.realm)

    max_label_width <- max(strwidth(realm_counts$GNOLEP.realm, units = "inches"))
    bottom_margin <- max(5, ceiling(max_label_width / par("csi")) + 2)
    oldpar <- par(no.readonly = TRUE)
    par(mar = c(bottom_margin, 4, 4, 2) + 0.1)

    barplot(
      realm_counts$n,
      names.arg = realm_counts$GNOLEP.realm,
      col = "black",
      ylab = "Number of records",
      main = "Records per Realm",
      ylim = c(0, 1.1*max(realm_counts$n, na.rm = TRUE)),
      las = 2
    )

    par(oldpar)}

}
