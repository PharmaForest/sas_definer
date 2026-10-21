Type: Package
Package: sas_definer
Title: Create CDISC Define-XML
Version: 0.1.0
Author: Ryo Nakaya (nakaya.ryou@gmail.com)
Maintainer: PharmaForest
License: MIT
Encoding: UTF8

Required: "Base SAS Software"

DESCRIPTION START:

  # sas_definer

  The sas_definer package provides macros to create a **Define-XML** file
  from an Excel specification.

  ## Macros

  | Macro | Description |
  |-------|-------------|
  | `%spec2xml()` | Wrapper. Runs `%spec2meta()` and then `%definexml()` to create define.xml from an Excel spec. |
  | `%spec2meta()` | Reads the Excel spec and creates the SAS metadata datasets (HEADER, DATASETS, VARIABLES, VALUELEVEL, METHODS, CODES, COMMENTS, DOCUMENTS, ...). VALUELISTOID and ITEMOID are auto-generated. WHERECLAUSEOID is used as is when the sheet has any value, otherwise it is auto-generated. |
  | `%definexml()` | Generates the Define-XML (version 2.0) from the SAS metadata datasets. |
  | `%definexml_attributes_for()` | Provides ATTRIB statements for the input metadata datasets. |
  | `%definexml_quote_xml()` | Escapes XML special characters. |

  A dummy Excel spec is included as additional content (`ADAM_METADATA_dummy.xlsx`).

  `%definexml()` and its helper macros are based on the definexml macros by
  Katja Glass (MIT License, 2016), with modifications.

  ## Implemented

  1. Convert Excel spec of the format in *"Implementing CDISC Using SAS: An End-to-End Guide, Revised Second Edition"* to SAS metadata (`%spec2meta`).
  2. Convert SAS metadata datasets to XML in Define-XML version 2.0 (`%definexml`).
  3. Create define.xml from an Excel spec in one step (`%spec2xml`).
 
  ## Planned (tentative)

  1. Convert SAS metadata datasets to XML in Define-XML version 2.1.
  2. Convert define.xml to Excel spec.
  3. Consistency check macro (undefined or duplicated OIDs, broken references of codelists / methods / comments / leaves, unused definitions, duplicated VALUEORDER).
  4. Output of the WHERE_CLAUSES and ANALYSIS_RESULTS sheets (currently not used by `%definexml`).
  5. Support for SDTM (SDTM-IG) Define-XML.
  6. XSD schema validation of the generated Define-XML.
  7. Bundle the Define-XML stylesheet (define2-0-0.xsl).
  8. Better handling of external codelists (MedDRA, WHODrug, etc.).
  9. More tests and samples.

DESCRIPTION END:
