# Global Database on non-Native Lepidoptera R-Package

The **GNOLEP** R package provides easy access to the Global Database on Non-native Lepidoptera (GNOLEP), with functions to generate summary statistics and plots of the database.

# Database

The full database and the information regarding it is available at: https://github.com/hncouto/Global_Database_on_Non-native_Lepidoptera

## Data tables

### GNOLEP 

A processed dataset containing the distribution `Records` joined with taxonomy, regions, realms and references. This dataset is produced directly from the GNOLEP SQLite database.

*Database Data (1):*
 - GNOLEP:recordID;

*Introduction Data (7):*
 - GNOLEP:cryptogenic;
 - GNOLEP:intentionalRelease;
 - GNOLEP:introduced;
 - GNOLEP:dispersal;
 - GNOLEP:established;
 - GNOLEP:eradicated;
 - dwc:year - First Record Year;

*Taxonomic Data (4):*
 - dwc:scientificName - Species as in the Original Record;
 - GNOLEP:acceptedSpecies - Species as Accepted in GBIF;
 - dwc:genus;
 - dwc:family;

*Distribution Data (4):*
 - dwc.verbatimLocality - Region;
 - dwc.country;
 - dwc.continent;
 - GNOLEP:realm - Biogeographic Realm;

*Reference Data (2):*
 - dwc:associatedReferences - Reference Citation;
 - GNOLEP.referenceYear;


### CondensedGNOLEP

A Condensed version of the GNOLEP table where 

*Taxonomic Data (1):*
 - dwc:scientificName - Accepted Species according to GBIF;

*Distribution Data (3):*
 - dwc:verbatimLocality - Region;
 - dwc:continent;
 - GNOLEP:realm - Biogeographic Realm;

*Introduction Data (7):*
 - GNOLEP:cryptogenic;
 - GNOLEP:intentionalRelease;
 - GNOLEP:introduced;
 - GNOLEP:dispersal;
 - GNOLEP:established;
 - GNOLEP:eradicated;
 - dwc:year - First Record Year;

*Reference Data (2):*
 - Latest_Reference (in the Complete database);
 - Latest_Reference_Year


### Individualised Database Tables

All Individualised GNOLEP database tables are available through the R package as well.

#### TaxonomyGNOLEP: Taxonomy table

A data frame with the Taxonomy table from the GNOLEP.

*5 Fields:*
 - GNOLEP.speciesID - species unique identifier;
 - GNOLEP.acceptedSpeciesID - species unique identifier related to the current species name as it is accepted by GBIF;
 - dwc.family
 - dwc.genus
 - dwc.scientificName

#### RegionsGNOLEP: Regions table

A data frame with the Regions table from GNOLEP

*4 Fields:*
 - GNOLEP.areaID - region unique identifier;
 - dwc.verbatimLocality - region name;
 - dwc.country
 - dwc.continent

#### RealmsGNOLEP: Realms table

A data frame with the Realms table from GNOLEP

*2 Fields:*
 - GNOLEP.realm - Biogeographic Realm;
 - GNOLEP.realmID - Realm unique identifier

#### ReferencesGNOLEP: References table

A data frame with the References table from GNOLEP

*3 Fields:*
 - GNOLEP.referenceID - Bibliographic reference unique identifier
 - dwc.associatedReferences - Bibliographic reference
 - GNOLEP.referenceYear - Bibliographic reference year

#### RecordsGNOLEP: Records table

A data frame with the Records table from GNOLEP

*11 Fields:*
 - GNOLEP.speciesID - Species unique identifier
 - GNOLEP.areaID - Region unique identifier}
 - GNOLEP.realmID - Realm unique identifier}
 - GNOLEP.cryptogenic
 - GNOLEP.intentionalRelease
 - GNOLEP.introduced
 - GNOLEP.dispersal
 - GNOLEP.established
 - GNOLEP.eradicated
 - dwc.year - year of first record}
 - GNOLEP.referenceID - Bibliographic reference unique identifier


#### NativesGNOLEP: Native Distribution Table

Table with Native Distribution per Species

*4 Fields:*
 - GNOLEP.speciesID - Species unique identifier
 - dwc.continent
 - GNOLEP.realmID - Realm unique identifier
 - GNOLEP.referenceID - Bibliographic reference unique identifier


## Data access

Each individual table can be called using `data()` function from the utils package:

`data(GNOLEP)`
`data(CondensedGNOLEP)`
`data(TaxonomyGNOLEP)`
`data(RegionsGNOLEP)`
`data(RealmsGNOLEP)`
`data(ReferencesGNOLEP)`
`data(RecordsGNOLEP)`
`data(NativesGNOLEP)`

All data can be called using the function `full_GNOLEP()` from this package. `full_GNOLEP()` will return all tables from the most up to date version of the database.

To import a previous version of the database the table and version to be called must be specified using the `GNOLEP_extract()` function. 
The valid tables to import using `GNOLEP_extract()` are: `GNOLEP`; `CondensedGNOLEP`; `TaxonomyGNOLEP`; `RegionsGNOLEP`; `RealmsGNOLEP`; `ReferencesGNOLEP`; `RecordsGNOLEP`; and `NativesGNOLEP`.

# Summary and Plots

## Summary 

### GNOLEP

`summary(GNOLEP)`

Returns a summary of a GNOLEP data frame that can be filtered with:

 - include_non_established (TRUE or FALSE): define if keep only established species or all
 - include_absent_establishment_data (TRUE or FALSE): define if keep records with NA's on establishement data
 - include_intentional (TRUE or FALSE): define if keep records from intentional release
 - include_absent_intentional_data (TRUE or FALSE): define if keep records with NA's on intentional release
 - include_cryptogenic (TRUE or FALSE): define if keep records with cryptogenic origin
 - include_absent_cryptogenic_data (TRUE or FALSE): define if keep records with NA's on cryptogenic origin
 - include_non_Introduced (TRUE or FALSE): define if keep species that arrived through natural dispersal
 - include_absent_Introduced_data (TRUE or FALSE): define if keep records with NA's on introduction origin
 - family_list: A list with Lepidoptera families
 - include_eradicated_data (TRUE or FALSE): define if keep records with NA's on erradicated
 - include_eradication_records (TRUE or FALSE): define if keep records with successful erradication
 - include_records_pre_eradication (TRUE or FALSE): define if keep records of introductions after erradications
 - country_list: A list of Countries
 - continent_list: A list of Continents
 - realm_list: A list of Biogeographic Realms

The summary returns: 
 - Total Records;
 - Total References;
 - Most Prevalent Reference;
 - Most Prevalent Reference - Number of Records;
 - Oldest Record Year;
 - Oldest Reference;
 - Total Species;
 - Total Families;
 - Most prevalent Species;
 - Most prevalent Family;
 - Most prevalent Species - Number of Records;
 - Most prevalent Family - Number of Records;
 - Total regions;
 - Total countries;
 - Total continents;
 - Total realms;
 - Most invaded Region;
 - Invasion Records - Most Invaded Region.


### CondensedGNOLEP

Given the more simple nature of CondensedGNOLEP the summary also reflects this, with lesser options to filter with and with less data on the summary as well.

`summary(CondensedGNOLEP)`

Returns a summary of a CondensedGNOLEP data frame that can be filtered with:
 - include_non_established (TRUE or FALSE): define if keep only established species or all
 - include_absent_establishment_data (TRUE or FALSE): define if keep records with NA's on establishement data
 - include_intentional (TRUE or FALSE): define if keep records from intentional release
 - include_absent_intentional_data (TRUE or FALSE): define if keep records with NA's on intentional release
 - include_cryptogenic (TRUE or FALSE): define if keep records with cryptogenic origin
 - include_absent_cryptogenic_data (TRUE or FALSE): define if keep records with NA's on cryptogenic origin
 - include_non_Introduced (TRUE or FALSE): define if keep species that arrived through natural dispersal
 - include_absent_Introduced_data (TRUE or FALSE): define if keep records with NA's on introduction origin
 - include_eradicated_data (TRUE or FALSE): define if keep records with NA's on erradicated
 - include_eradication_records (TRUE or FALSE): define if keep records with successful erradication
 - include_records_pre_eradication (TRUE or FALSE): define if keep records of introductions after erradications
 - continent_list: A list of Continents
 - realm_list: A list of Biogeographic Realms

The summary returns: 
 - Total Species;
 - Most prevalent Species;
 - Most prevalent Species - Number of Records;
 - Total regions;
 - Total continents;
 - Total realms;
 - Most invaded Region;
 - Invasion Records - Most Invaded Region.


## Plots

To plot simple summaries of GNOLEP objects use: `plot(GNOLEP)`

The customisation parameters are:
 - OverTime (TRUE or FALSE) (TRUE by predefinition):  Time trends of First Records in the selected dataset. If selected alone it will return global trends. If selected with ContinentalPlot or RealmPlot it will return the Time trend by Continent or Biogeographic Realm.
 - ContinentalPlot (TRUE or FALSE) (FALSE by predefinition): Continental Trends in the selected dataset. If selected alone it will return a bar graph with data on continents. 
 - RealmPlot (TRUE or FALSE) (FALSE by predefinition): Realm Trends in the selected dataset. If selected alone it will return a bar graph with data on biogeographic realms.

*ContinentalPlot and RealmPlot are mutually exclusive, only one can be selected*


The filter parameters available are: 
 - include_non_established (TRUE or FALSE): define if keep only established species or all;
 - include_absent_establishment_data (TRUE or FALSE): define if keep records with NA's on establishment data;
 - include_intentional (TRUE or FALSE): define if keep records from intentional release;
 - include_absent_intentional_data (TRUE or FALSE): define if keep records with NA's on intentional release;
 - include_cryptogenic (TRUE or FALSE): define if keep records with cryptogenic origin;
 - include_absent_cryptogenic_data (TRUE or FALSE): define if keep records with NA's on cryptogenic origin;
 - include_non_Introduced (TRUE or FALSE): define if keep species that arrived through natural dispersal;
 - include_absent_Introduced_data (TRUE or FALSE): define if keep records with NA's on introduction origin;
 - family_list: A list with Lepidoptera families;
 - include_eradicated_data (TRUE or FALSE): define if keep records with NA's on eradicated;
 - include_eradication_records (TRUE or FALSE): define if keep records with successful eradication;
 - include_records_pre_eradication (TRUE or FALSE): define if keep records of introductions after eradication;
 - continent_list: A list of Continents;
 - realm_list: A list of Biogeographic Realms.


### Extract plots to png

To extract sequential plots it is recommended to use:

`png("GNOLEP_%d.png")`
`plot(GNOLEP)`
`dev.off()`
