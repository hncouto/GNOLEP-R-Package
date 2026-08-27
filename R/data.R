# R/data.R
# -----------------------

#' GNOLEP - Worldwide Database of non-Native Lepidoptera
#'
#' A processed dataset containing the distribution `Records` joined with taxonomy, regions,
#' realms and references. This dataset is produced directly from the GNOLEP SQLite database
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
#'   \item{GNOLEP.recordID}{integer; unique record id}
#'   \item{GNOLEP.cryptogenic}{binary; Cryptogenic Origin}
#'   \item{GNOLEP.intentionalRelease}{binary; record of intentional introduction (biocontrol included)}
#'   \item{GNOLEP.introduced}{binary; record of human mediated introduction }
#'   \item{GNOLEP.dispersal}{binary; record of species arriving by dispersal }
#'   \item{GNOLEP.established}{binary; record of established population}
#'   \item{GNOLEP.eradicated}{binary; record of eradication of previously established population}
#'   \item{dwc.year}{integer; year of first record}
#'   \item{dwc.scientificName}{character; species name as in the original source}
#'   \item{GNOLEP.acceptedSpecies}{character; species name accepted by GBIF}
#'   \item{dwc.genus}{character; species taxonomic genus}
#'   \item{dwc.family}{character; species taxonomic family}
#'   \item{dwc.verbatimLocality}{character; record region}
#'   \item{dwc.country}{character; record country}
#'   \item{dwc.continent}{character; record continent}
#'   \item{GNOLEP.realm}{character; record biogeographic realm}
#'   \item{dwc.associatedReferences}{character; original record reference}
#'   \item{GNOLEP.referenceYear}{integer; reference year}
#' }
#' @source GNOLEP database (check package source reference)
"GNOLEP"

#' Condensed GNOLEP
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
#'   \item{dwc.scientificName}{character; species name accepted by GBIF}
#'   \item{dwc.verbatimLocality}{character; record region}
#'   \item{dwc.continent}{character; record continent}
#'   \item{GNOLEP.realm}{character; record biogeographic realm}
#'   \item{dwc.year}{integer; oldest first record}
#'   \item{GNOLEP.cryptogenic}{binary; Cryptogenic Origin}
#'   \item{GNOLEP.dispersal}{binary; Arrival by dispersal}
#'   \item{GNOLEP.eradicated}{binary; Species previously established but currently eradicated}
#'   \item{GNOLEP.established}{binary; record of established population}
#'   \item{GNOLEP.intentionalRelease}{binary; record of intentional introduction (biocontrol included)}
#'   \item{GNOLEP.introduced}{binary; record of arrival related to human activity}
#'   \item{Latest_Reference}{character; most recent reference on the database for the species-region pair}
#'   \item{Latest_Reference_Year}{integer; reference year}
#' }
#'
"CondensedGNOLEP"


#' Taxonomy table
#' @format A data frame with the Taxonomy table from the GNOLEP.
#'
#'\describe{
#'   \item{GNOLEP.speciesID}{character; species unique identifier}
#'   \item{GNOLEP.acceptedSpeciesID}{character; species unique identifier related to the current species name as it is accepted by GBIF}
#'   \item{dwc.family}{character; family name}
#'   \item{dwc.genus}{character; genus name}
#'   \item{dwc.scientificName}{character; species name}
#'}
#'
"TaxonomyGNOLEP"

#' Regions table
#' @format A data frame...
"RegionsGNOLEP"

#' Realms table
#' @format A data frame...
"RealmsGNOLEP"

#' References table
#' @format A data frame...
"ReferencesGNOLEP"

#' Records table
#' @format A data frame...
"RecordsGNOLEP"

#' Native Distribution Table
#'
#' Table with Native Distribution per Species
#' @format A data frame with
"NativesGNOLEP"
