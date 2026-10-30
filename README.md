# SAS_definer (latest version 0.1.1)
A SAS package to provide macros for creating a CDISC **Define-XML** file from an Excel metadata specification.
The Excel spec format is based on the one in *"Implementing CDISC Using SAS: An End-to-End Guide, Revised Second Edition"*.
The package converts an Excel spec into SAS metadata datasets and then writes Define-XML (version 2.0).
`%definexml()` and its helper macros are based on the definexml macros by Katja Glass (PHUSE, MIT License, 2016), with modifications.
Support for Define-XML 2.1, reverse conversion to Excel, and Analysis Results Metadata (ARM) is planned.

<img src="https://github.com/PharmaForest/sas_definer/blob/main/sas_definer_logo.png?raw=true" alt="SAS_definer" width="300"/>

Available macros are as below. Support macros called in main macro are not listed here.
- %createDefine()                   : To create define.xml from an Excel spec in one step

---

## Why this package? (Define-XML creation tools)

Several tools are available to generate or manage CDISC Define-XML, with different input formats, supported versions, and execution environments.

| Tool | Environment | Main capabilities | Define-XML version | License / access |
|------|-------------|-------------------|--------------------|------------------|
| [Pinnacle 21](https://help.pinnacle21.certara.net/en/articles/9736610-download-pinnacle-21-community) | GUI / application | Define-XML generation and validation; Community and Enterprise editions | 1.0, 2.0, 2.1 | P21 OSS License (Community); commercial (Enterprise) |
| [tsClinical](https://github.com/tsClinical-OSS-Community/tsc-desktop) | GUI / application | Excel ↔ Define-XML conversion, XML-to-HTML output, and schema validation | 2.0, 2.1 | Apache-2.0 (Desktop Tools) |
| [SAS Clinical Standards Toolkit / openCST](https://github.com/sassoftware/clinical-standards-toolkit) | SAS | Clinical standards metadata framework, including Define-XML generation | 2.0, 2.1 | Apache-2.0 (openCST; archived) |
| [defineR](https://github.com/dbosak01/defineR) | R | Generate Define-XML from spreadsheet-based metadata | 2.0 | CC0-1.0 |
| [odmlib](https://github.com/swhume/odmlib) | Python | Create and process CDISC ODM and Define-XML | 1.0, 2.0, 2.1 | MIT |
| [PHUSE %defineXML](https://github.com/phuse-org/phuse-scripts/tree/master/lang/SAS/datahandle/defineXML) | SAS | Generate Define-XML from SAS metadata datasets | 2.0 | MIT |
| [%make_define](https://github.com/wyp1125/SAS-Clinical-Trials-Toolkit/blob/master/make_define.sas) | SAS | Generate Define-XML components from Excel metadata | 1.0 | GPL-3.0 |

*This is a non-exhaustive overview based on the project introduction slides. Versions and licensing may change; consult each project's documentation for current details. The license shown for openCST refers to the linked open-source repository, not every distribution of SAS CST.*

Although these tools offer useful capabilities, they may require a commercial application, an R/Python environment, or a different metadata specification format.

### What SAS_definer adds

The original PHUSE `%defineXML` macros already provide the step from **SAS metadata datasets to Define-XML 2.0**. SAS_definer builds on this foundation by adding an Excel specification reader and an end-to-end wrapper:

```text
Excel metadata specification
  (format based on "Implementing CDISC Using SAS")
              |
              v
         %spec2meta()
              |
              v
      SAS metadata datasets
              |
              v
          %definexml()
              |
              v
        Define-XML 2.0
```

`%createDefine()` runs the conversion in one step, from the Excel specification to the final Define-XML file. The Excel specification format is based on *Implementing CDISC Using SAS: An End-to-End Guide*, which is also the basis for metadata inputs used by defineR and `%make_define`.

Packaging this workflow with the **SAS Packages Framework (SPF)** makes it easier to install, load, reuse, and extend the macros in an existing SAS environment.

### Planned extensions

- **Define-XML 2.1 support:** Extend the current Define-XML 2.0 generation workflow to version 2.1.
- **Define-XML to Excel conversion:** Add a reverse workflow to generate a metadata specification workbook from an existing Define-XML file.
- **Analysis Results Metadata (ARM):** Extend metadata support to include analysis results metadata.

Contributions to development, testing, and discussions are welcome via the [PharmaForest sas_definer repository](https://github.com/PharmaForest/sas_definer).

---

## %createDefine

### Purpose:
    Creates a Define-XML file directly from a metadata specification Excel file.
    It runs %spec2meta() and then %definexml().

### Parameters:
~~~sas
- `specfile` (required) Full path of the specification Excel file (xlsx).
- `outfile`  (required) Output Define-XML file name.
~~~

### Example usage:
~~~sas
%createDefine(
    specfile = C:\path\to\ADAM_METADATA_dummy.xlsx,
    outfile  = C:\path\to\define.xml
)
~~~

A dummy specification (`ADAM_METADATA_dummy.xlsx`) is included as additional content of the package.


## Version history
0.1.1 : Changed macro name from %spec2xml to %createDefine  
0.1.0 : Initial version

---

## What is SAS Packages?

The package is built on top of **SAS Packages Framework(SPF)** developed by Bartosz Jablonski.

For more information about the framework, see [SAS Packages Framework](https://github.com/yabwon/SAS_PACKAGES).

You can also find more SAS Packages (SASPacs) in the [SAS Packages Archive(SASPAC)](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)

### 1. Set-up SAS Packages Framework

First, create a directory for your packages and assign a `packages` fileref to it.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
filename packages "\path\to\your\packages";
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secondly, enable the SAS Packages Framework.
(If you don't have SAS Packages Framework installed, follow the instruction in 
[SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) 
to install SAS Packages Framework.)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%include packages(SPFinit.sas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### 2. Install SAS package

Install SAS package you want to use with the SPF's `%installPackage()` macro.

- For packages located in **SAS Packages Archive(SASPAC)** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located in **PharmaForest** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, mirror=PharmaForest)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located at some network location run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, sourcePath=https://some/internet/location/for/packages)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (e.g. `%installPackage(ABC, sourcePath=https://github.com/SomeRepo/ABC/raw/main/)`)


### 3. Load SAS package

Load SAS package you want to use with the SPF's `%loadPackage()` macro.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%loadPackage(sas_definer)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### Enjoy!

---
