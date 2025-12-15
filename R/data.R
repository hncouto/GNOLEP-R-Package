# R/data.R

#' WDnNL - Worldwide Database of non-Native Lepidoptera
#'
#' A processed dataset containing the distribution `Records` joined with taxonomy, regions,
#' realms and references. This dataset is produced directly from the WDNnL SQLite database
#' (see `data-raw/data-preparation.R`).
#'
#' @format A data frame with 16067 records and 19 variables:
#'
#' Database Variables (1): RecordID
#'
#' Introduction Variables (7): Cryptogenic, Intentional Release, Introduced, Dispersal, Established, Eradicated, First Record Year
#'
#' Taxonomic variables (4): Species, GBIF Accepted Species, Genus, Family;
#'
#' Distribution Variables (5): Region, Country, Continent, Sub-Continent, Biogeographic Realm
#'
#' Reference Data (2): Reference Citation, Reference Year
#'
#' \describe{
#'   \item{RecordID}{integer; unique record id}
#'   \item{Cryptogenic}{binary; Cryptogenic Origin}
#'   \item{IntentionalRelease}{binary; record of intentional introduction (biocontrol included)}
#'   \item{Introduced}{binary; record of human mediated introduction }
#'   \item{Dispersal}{binary; record of species arriving by dispersal }
#'   \item{Established}{binary; record of established population}
#'   \item{Eradicated}{binary; record of eradication of previously established population}
#'   \item{Year}{integer; year of first record}
#'   \item{Species}{character; species name at record}
#'   \item{AcceptedSpecies}{character; species name accepted by GBIF}
#'   \item{Genus}{character; species taxonomic genus}
#'   \item{Family}{character; species taxonomic family}
#'   \item{AreaName}{character; record region}
#'   \item{Country}{character; record country}
#'   \item{Continent}{character; record continent}
#'   \item{SubContinent}{character; record sub-continent}
#'   \item{Realm}{character; record biogeographic realm}
#'   \item{BibliographicReference}{character; original record reference}
#'   \item{ReferenceYear}{integer; reference year}
#' }
#' @source WDNnL SQLite database (check package source reference)
"WDnNL"

#' Condensed Database.
#'
#' Condensed Database to one Species per Region.
#' @format A data frame with a total of 9 variables.
#'
#' Taxonomic variables (2): Species, Family;
#'
#' Distribution Variables (3): Region, Continent, Realm;
#'
#' Introduction Variables (2): First Observation, Intentional Release;
#'
#' Reference Data (2): Latest Reference (in the Complete database), Latest Reference Year
#'
#'
#'\describe{
#'   \item{Species}{character; species name accepted by GBIF}
#'   \item{Family}{character; species taxonomic family}
#'   \item{Region}{character; record region}
#'   \item{Continent}{character; record continent}
#'   \item{Realm}{character; record biogeographic realm}
#'   \item{First_Observation}{integer; oldest first record}
#'   \item{IntentionalRelease}{binary; record of intentional introduction (biocontrol included)}
#'   \item{Latest_Reference}{character; most recent reference on the database for the species-region pair}
#'   \item{Latest_Reference_Year}{integer; reference year}
#' }
#'
"CondensedDatabase"

#' NativeDatabase table
#' @format A data frame...
#'
#' Taxonomic Variables (2); Species, Accepted Species according to GBIF
#'
#' Distribution Variables (3): Continent, Realm, Cosmopolitan
#'
#' Reference Data (2): Reference Citation, Reference Year
#'
#'\describe{
#'   \item{Species}{character; species name on original record}
#'   \item{AcceptedSpecies}{character; species name according to GBIF}
#'   \item{Realm}{character; native biogeographic realm}
#'   \item{Continent}{character; native continent}
#'   \item{Cosmopolitan}{binary; identifier if the species is cosmopolitan}
#'   \item{BibliographicReference}{character; original record reference}
#'   \item{ReferenceYear}{integer; reference year}
#' }
#'
"NativeDatabase"

#' Taxonomy table
#' @format A data frame...
"Taxonomy"

#' Regions table
#' @format A data frame...
"Regions"

#' Realms table
#' @format A data frame...
"Realms"

#' References table
#' @format A data frame...
"References"

#' Records table
#' @format A data frame...
"Records"

#' Native Distribution Table
#'
#' Table with Native Distribution per Species
#' @format A data frame with
"Natives"
