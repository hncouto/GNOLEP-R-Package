# R/data.R
# -----------------------

#' WDnNL - Worldwide Database of non-Native Lepidoptera
#'
#' A processed dataset containing the distribution `Records` joined with taxonomy, regions,
#' realms and references. This dataset is produced directly from the WDNnL SQLite database
#' (see `data-raw/data-preparation.R`).
#'
#' @format A data frame with 11916 records and 18 variables:
#'
#' Database Variables (1): RecordID;
#'
#' Introduction Variables (7): Cryptogenic, Intentional Release, Introduced, Dispersal, Established, Eradicated, First Record Year;
#'
#' Taxonomic variables (3): Species as in the Original Record, Species as Accepted in GBIF, Genus, Family;
#'
#' Distribution Variables (4): Region, Country, Continent, Biogeographic Realm;
#'
#' Reference Data (2): Reference Citation, Reference Year;
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
#'   \item{Species}{character; species name as in the original source}
#'   \item{AcceptedSpecies}{character; species name accepted by GBIF}
#'   \item{Genus}{character; species taxonomic genus}
#'   \item{Family}{character; species taxonomic family}
#'   \item{AreaName}{character; record region}
#'   \item{Country}{character; record country}
#'   \item{Continent}{character; record continent}
#'   \item{Realm}{character; record biogeographic realm}
#'   \item{BibliographicReference}{character; original record reference}
#'   \item{ReferenceYear}{integer; reference year}
#' }
#' @source WDNnL database (check package source reference)
"WDnNL"

#' Condensed WDnNL
#'
#' Condensed Database to one Species per Region.
#' @format A data frame with 3857 entries and a total of 13 variables.
#'
#' Taxonomic variables (1): Accepted Species according to GBIF;
#'
#' Distribution Variables (3): Region, Continent, Realm;
#'
#' Introduction Variables (7): Cryptogenic, Intentional Release, Introduced, Dispersal, Established, Eradicated, First Record Year;
#'
#' Reference Data (2): Latest Reference (in the Complete database), Latest Reference Year
#'
#'
#'\describe{
#'   \item{AcceptedSpecies}{character; species name accepted by GBIF}
#'   \item{AreaName}{character; record region}
#'   \item{Continent}{character; record continent}
#'   \item{Realm}{character; record biogeographic realm}
#'   \item{First_Observation}{integer; oldest first record}
#'   \item{Cryptogenic}{binary; Cryptogenic Origin}
#'   \item{Dispersal}{binary; Arrival by dispersal}
#'   \item{Eradicated}{binary; Species previously established but currently eradicated}
#'   \item{Established}{binary; record of established population}
#'   \item{IntentionalRelease}{binary; record of intentional introduction (biocontrol included)}
#'   \item{Introduced}{binary; record of arrival related to human activity}
#'   \item{Latest_Reference}{character; most recent reference on the database for the species-region pair}
#'   \item{Latest_Reference_Year}{integer; reference year}
#' }
#'
"CondensedWDnNL"


#' Taxonomy table
#' @format A data frame with the Taxonomy table from the WDnNL.
#'
#'\describe{
#'   \item{SpeciesID}{character; species unique identifier}
#'   \item{AcceptedSpeciesID}{character; species unique identifier related to the current species name as it is accepted by GBIF}
#'   \item{Family}{character; family name}
#'   \item{Genus}{character; genus name}
#'   \item{Species}{character; species name}
#'}
#'
"TaxonomyWDnNL"

#' Regions table
#' @format A data frame...
"RegionsWDnNL"

#' Realms table
#' @format A data frame...
"RealmsWDnNL"

#' References table
#' @format A data frame...
"ReferencesWDnNL"

#' Records table
#' @format A data frame...
"RecordsWDnNL"

#' Native Distribution Table
#'
#' Table with Native Distribution per Species
#' @format A data frame with
"NativesWDnNL"
