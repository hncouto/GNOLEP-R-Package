#' Title
#'
#' @param x A summary.WDnNL object
#' @param ...
#'
#' @returns Summary plots
#' @export

plot.WDnNL <- function(
    object,
    OverTime = TRUE,
    ContinetalPlot = FALSE,
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

  if (OverTime == TRUE && ContinetalPlot == FALSE && RealmPlot == FALSE){
    cum_WDnNL_total <- object %>%
      filter(!is.na(Year)) %>%
      count(Year) %>%
      arrange(Year) %>%
      mutate(cumulative = cumsum(n))

    plot(cum_WDnNL_total$Year,
      cum_WDnNL_total$cumulative,
      type = "l",      # both points and lines
      xlab = "Year",
      ylab = "Cumulative number of records",
      ylim = c(0, 1.1 * max(cum_WDnNL_total$cumulative)))

    if (interactive()) {readline(prompt = "Press [Enter] for next plot.")}

    plot(cum_WDnNL_total$Year,
      cum_WDnNL_total$n,
      type = "p",      # both points and lines
      xlab = "Year",
      ylab = "Yearly number of records",
      ylim = c(0, 1.1 * max(cum_WDnNL_total$n)))}

  if (OverTime == TRUE && ContinetalPlot == TRUE && RealmPlot == FALSE){

    continents <- unique(object$Continent)
    continents <- continents[!is.na(continents)]

    for (ct in continents) {

      cat("\n--- Continent:", ct, "---\n")
      sub_object <- object[object$Continent == ct, ]
      cum_WDnNL_continent <- sub_object %>%
        filter(!is.na(Year)) %>%
        count(Year) %>%
        arrange(Year) %>%
        mutate(cumulative = cumsum(n))

      # Skip empty continents safely
      if (nrow(cum_WDnNL_continent) == 0) next

      # ---- Plot 1: cumulative ----
      plot(cum_WDnNL_continent$Year,
        cum_WDnNL_continent$cumulative,
        type = "l",
        col = "black",
        main = paste("Cumulative records -", ct),
        xlab = "Year",
        ylab = "Cumulative number of records",
        ylim = c(0, 1.1 * max(cum_WDnNL_continent$cumulative, na.rm = TRUE)))

      if (interactive()) {readline(prompt = "Press [Enter] for next plot...")}

      # ---- Plot 2: yearly ----
      plot(cum_WDnNL_continent$Year,
        cum_WDnNL_continent$n,
        type = "p",
        col = "black",
        main = paste("Yearly records -", ct),
        xlab = "Year",
        ylab = "Yearly number of records",
        ylim = c(0, 1.1 * max(cum_WDnNL_continent$n, na.rm = TRUE)))

      if (interactive()) {readline(prompt = "Press [Enter] for next continent...")}}
    }

  if (OverTime == TRUE && ContinetalPlot == FALSE && RealmPlot == TRUE){

      realms <- unique(object$Realm)
      realms <- realms[!is.na(realms)]

      for (rl in realms) {

        cat("\n--- Realm:", rl, "---\n")

        sub_object <- object[object$Realm == rl, ]

        cum_WDnNL_realm <- sub_object %>%
          filter(!is.na(Year)) %>%
          count(Year) %>%
          arrange(Year) %>%
          mutate(cumulative = cumsum(n))

        if (nrow(cum_WDnNL_realm) == 0) next

        plot(
          cum_WDnNL_realm$Year,
          cum_WDnNL_realm$cumulative,
          type = "l",
          col = "black",
          main = paste("Cumulative records -", rl),
          xlab = "Year",
          ylab = "Cumulative number of records",
          ylim = c(0, 1.1 * max(cum_WDnNL_realm$cumulative, na.rm = TRUE))
        )

        if (interactive()) {readline(prompt = "Press [Enter] for next plot...")}

        plot(
          cum_WDnNL_realm$Year,
          cum_WDnNL_realm$n,
          type = "p",
          col = "black",
          main = paste("Yearly records -", rl),
          xlab = "Year",
          ylab = "Yearly number of records",
          ylim = c(0, 1.1 * max(cum_WDnNL_realm$n, na.rm = TRUE)))

        if (interactive()) {
          readline(prompt = "Press [Enter] for next realm")}}}

  if (OverTime == FALSE && ContinetalPlot == FALSE && RealmPlot == FALSE) {
      message("Please select OverTime = TRUE and/or ContinetalPlot/RealmPlot = TRUE.")}

  if (ContinetalPlot == TRUE && RealmPlot == TRUE) {
    message("Please select only one of ContinetalPlot or RealmPlot = TRUE.")}

  if (OverTime == FALSE && ContinetalPlot == TRUE && RealmPlot == FALSE) {

    continent_counts <- object %>%
      filter(!is.na(Continent)) %>%
      count(Continent)

    barplot(
      continent_counts$n,
      names.arg = continent_counts$Continent,
      col = "black",
      xlab = "Continent",
      ylab = "Number of records",
      main = "Records per Continent",
      las = 2
    )}

  if (OverTime == FALSE && ContinetalPlot == FALSE && RealmPlot == TRUE) {

    realm_counts <- object %>%
      filter(!is.na(Realm)) %>%
      count(Realm)

    barplot(
      realm_counts$n,
      names.arg = realm_counts$Realm,
      col = "black",
      xlab = "Realm",
      ylab = "Number of records",
      main = "Records per Realm",
      las = 2
    )}

}
