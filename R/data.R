# R/data.R
# -----------------------

#' GNOLEP - Worldwide Database of non-Native Lepidoptera
#'
#' A processed dataset containing the distribution `Records` joined with taxonomy, regions,
#' realms and references. This dataset is produced directly from the GNOLEP SQLite database
#' (see `data-raw/data-preparation.R`).
#'
#' @format A data frame with 10001 records and 18 variables:
#'
#' Database Variables (1): GNOLEP:recordID;
#'
#' Introduction Variables (7): GNOLEP:cryptogenic; GNOLEP:intentionalRelease; GNOLEP:introduced; GNOLEP:dispersal; GNOLEP:established; GNOLEP:eradicated; dwc:year - First Record Year;
#'
#' Taxonomic variables (3): dwc:scientificName - Species as in the Original Record; GNOLEP:acceptedSpecies - Species as Accepted in GBIF; dwc:genus; dwc:family;
#'
#' Distribution Variables (4): dwc.verbatimLocality - Region; dwc.country; dwc.continent; GNOLEP:realm - Biogeographic Realm;
#'
#' Reference Data (2): dwc:associatedReferences - Reference Citation: GNOLEP.referenceYear;
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
#' @format A data frame with 3986 entries and a total of 13 variables.
#'
#' Taxonomic variables (1): dwc:scientificName - Accepted Species according to GBIF;
#'
#' Distribution Variables (3): dwc:verbatimLocality - Region; dwc:continent; GNOLEP:realm - Biogeographic Realm;
#'
#' Introduction Variables (7): GNOLEP:cryptogenic; GNOLEP:intentionalRelease; GNOLEP:introduced; GNOLEP:dispersal; GNOLEP:established; GNOLEP:eradicated; dwc:year - First Record Year;
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
#' @format A data frame with the Regions table from GNOLEP
#'\describe{
#'   \item{GNOLEP.areaID}{character; region unique identifier}
#'   \item{dwc.verbatimLocality}{character; Region name}
#'   \item{dwc.country}{character; Country name}
#'   \item{dwc.continent}{character; Continent name}
#'}
#'
"RegionsGNOLEP"

#' Realms table
#' @format A data frame with the Realms table from GNOLEP
#'\describe{
#'   \item{GNOLEP.realm}{character; Biogeographic Realm}
#'   \item{GNOLEP.realmID}{character; Realm unique identifier}
#'}
#'
"RealmsGNOLEP"

#' References table
#' @format A data frame with the References table from GNOLEP
#'\describe{
#'   \item{GNOLEP.referenceID}{character; Bibliographic reference unique identifier}
#'   \item{dwc.associatedReferences}{character; Bibliographic reference}
#'   \item{GNOLEP.referenceYear}{integer; Bibliographic reference year}
#'}
#'
"ReferencesGNOLEP"

#' Records table
#' @format A data frame with the Records table from GNOLEP
#'\describe{
#'   \item{GNOLEP.speciesID}{character; species unique identifier}
#'   \item{GNOLEP.areaID}{character; region unique identifier}
#'   \item{GNOLEP.realmID}{character; Realm unique identifier}
#'   \item{GNOLEP.cryptogenic}{binary; Cryptogenic Origin}
#'   \item{GNOLEP.intentionalRelease}{binary; record of intentional introduction (biocontrol included)}
#'   \item{GNOLEP.introduced}{binary; record of arrival related to human activity}
#'   \item{GNOLEP.dispersal}{binary; Arrival by dispersal}
#'   \item{GNOLEP.established}{binary; record of established population}
#'   \item{GNOLEP.eradicated}{binary; Species previously established but currently eradicated}
#'   \item{dwc.year}{integer; year of first record}
#'   \item{GNOLEP.referenceID}{character; Bibliographic reference unique identifier}
#'}
#'
"RecordsGNOLEP"

#' Native Distribution Table
#'
#' Table with Native Distribution per Species
#' @format A data frame with the Native Conbtinent of established species in GNOLEP
#'\describe{
#'   \item{GNOLEP.speciesID}{character; species unique identifier}
#'   \item{dwc.continent}{character; continent}
#'   \item{GNOLEP.realmID}{character; Realm unique identifier}
#'   \item{GNOLEP.referenceID}{character; Bibliographic reference unique identifier}
#'}
#'
"NativesGNOLEP"
