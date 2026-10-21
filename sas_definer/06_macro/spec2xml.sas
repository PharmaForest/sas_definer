/*** HELP START ***//*

### Macro `%spec2xml()`

Creates a Define-XML file directly from a metadata specification Excel file.
It runs `%spec2meta()` to create the metadata datasets in WORK,
and then `%definexml()` to write the Define-XML file.

#### Parameters

- `specfile` : full path of the specification Excel file (xlsx) (required)
- `outfile` : output Define-XML file name (required)

#### Example

~~~sas
%spec2xml(
  specfile=C:\path\to\ADAM_METADATA.xlsx,
  outfile=C:\path\to\define.xml
);
~~~

*//*** HELP END ***/

%macro spec2xml(specfile=, outfile=);

%if %length(%superq(specfile)) = 0 %then %do;
  %put ERROR: [&sysmacroname.] Required parameter SPECFILE must not be empty.;
  %return;
%end;

%if %length(%superq(outfile)) = 0 %then %do;
  %put ERROR: [&sysmacroname.] Required parameter OUTFILE must not be empty.;
  %return;
%end;

/* Create metadata datasets from the specification */
%spec2meta(specfile=&specfile.);

/* Create Define-XML from the metadata datasets */
%definexml(outfile=&outfile.);

%mend spec2xml;
