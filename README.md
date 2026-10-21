# sas_definer (latest version 0.1.0)
A SAS package to provide macros for creating a CDISC **Define-XML** file from an Excel metadata specification.
The Excel spec format is based on the one in *"Implementing CDISC Using SAS: An End-to-End Guide, Revised Second Edition"*.
The package converts an Excel spec into SAS metadata datasets and then writes Define-XML (version 2.0).
`%definexml()` and its helper macros are based on the definexml macros by Katja Glass (PHUSE, MIT License, 2016), with modifications.
Features for Define-XML 2.1 and Define-XML to Excel conversion are to be added.

Available macros are as below. Support macros called in main macro are not listed here.
- %spec2xml()                   : To create define.xml from an Excel spec in one step

---

## Why this package? (Define-XML creation tools)

Define-XML can be created with various tools. Some examples are listed below.

| Category | Tool | Note |
|----------|------|------|
| Commercial / GUI | Pinnacle 21 (Enterprise) | Spec management and Define-XML generation |
| Commercial / GUI | TSClinical | Define-XML generation |
| SAS | PHUSE definexml macros | Basis of this package (SAS metadata datasets to Define-XML 2.0) |
| SAS | SAS Clinical Standards Toolkit | Define-XML support, requires SAS licenses for the toolkit |
| R | defineR, metacore / metatools / xportr (pharmaverse) | Spec handling and Define-XML related functions |
| Python | odmlib and others | CDISC ODM / Define-XML handling libraries |

(The list is not exhaustive. Please check each tool for the supported Define-XML versions.)

Many of them require commercial licenses or non-SAS environments.
In many pharmaceutical companies and CROs, SAS is still the main environment for creating ADaM/SDTM datasets,
so a **SAS-native, open-source** implementation is useful.
The purpose of this package is to make the SAS implementation (the PHUSE definexml macros plus
an Excel spec reader and a wrapper macro) easy to install, load and reuse as a **SAS package**.

---

## %spec2xml

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
%spec2xml(
    specfile = C:\path\to\ADAM_METADATA_dummy.xlsx,
    outfile  = C:\path\to\define.xml
)
~~~

A dummy specification (`ADAM_METADATA_dummy.xlsx`) is included as additional content of the package.


## Version history
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

## License
MIT License. See `license.sas`. The definexml macros are Copyright (c) 2016 Katja Glass (MIT License).
