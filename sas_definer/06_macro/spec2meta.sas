/*** HELP START ***//*

### Macro `%spec2meta()`

Reads a metadata specification Excel file (PHUSE Define-XML template style) and creates
the WORK datasets used as input of `%definexml()`:
`HEADER`, `DATASETS`, `VARIABLES`, `VALUELEVEL`, `METHODS`, `CODES`, `COMMENTS`, `DOCUMENTS`,
plus `WHERE_CLAUSES` and `ANALYSIS_RESULTS` (not in the PHUSE template).

#### Parameter

- `specfile` : full path of the specification Excel file (xlsx) (required)

#### Example

~~~sas
%spec2meta(specfile=C:\path\to\ADAM_METADATA.xlsx);
~~~

*//*** HELP END ***/

%macro spec2meta(specfile=);

%if %length(%superq(specfile)) = 0 %then %do;
  %put ERROR: [&sysmacroname.] Required parameter SPECFILE must not be empty.;
  %return;
%end;

%if %sysfunc(fileexist(%superq(specfile))) = 0 %then %do;
  %put ERROR: [&sysmacroname.] SPECFILE=%superq(specfile) does not exist.;
  %return;
%end;

/* Meta dataset */
libname spec xlsx "&specfile." ;

/* Header information */
data HEADER;
	set spec.DEFINE_HEADER_METADATA;
run;
data HEADER;
    set HEADER(rename=(STUDYOID=STUDYOID_CHAR));
    STUDYOID = strip(STUDYOID_CHAR);
    drop STUDYOID_CHAR;
run;

/* Dataset information */
data DATASETS;
	set spec.TOC_METADATA;
	rename
	NAME = DOMAIN
	DATASETORDER = ORDID
	LABEL = DESCRIPTION
	ARCHIVELOCATIONID = ARCHIVELOCATION
	COMMENTOID = COMMENT
	;
run;
data DATASETS;
    set DATASETS(rename=(ORDID=ORDID_CHAR));
    ORDID = input(strip(ORDID_CHAR), best32.);
    drop ORDID_CHAR;
run;

/* Variable information */
data VARIABLES;
	set spec.VARIABLE_METADATA;
	rename
	COMMENTOID = COMMENT
	;
run;
data VARIABLES;
    set VARIABLES(rename=(VARNUM=VARNUM_CHAR KEYSEQUENCE=KEYSEQUENCE_CHAR LENGTH=LENGTH_CHAR
	SIGNIFICANTDIGITS=SIGNIFICANTDIGITS_CHAR));
    VARNUM = input(strip(VARNUM_CHAR), best32.);
    KEYSEQUENCE = input(strip(KEYSEQUENCE_CHAR), best32.);
    LENGTH = input(strip(LENGTH_CHAR), best32.);
    SIGNIFICANTDIGITS = input(strip(SIGNIFICANTDIGITS_CHAR), best32.);
    drop VARNUM_CHAR KEYSEQUENCE_CHAR LENGTH_CHAR SIGNIFICANTDIGITS_CHAR;
run;

/* Value-level information */
data VALUELEVEL;
	set spec.VALUELEVEL_METADATA;
	rename
	VARNUM = VALUEORDER
	LABEL = DESCRIPTION
	COMMENTOID = COMMENT
	;
run;
data VALUELEVEL;
    set VALUELEVEL(rename=(VALUEORDER=VALUEORDER_CHAR
	LENGTH=LENGTH_CHAR CRFPAGE=CRFPAGE_CHAR
	SIGNIFICANTDIGITS=SIGNIFICANTDIGITS_CHAR));
    VALUEORDER = input(strip(VALUEORDER_CHAR), best32.);
    CRFPAGE = input(strip(CRFPAGE_CHAR), best32.);
    LENGTH = input(strip(LENGTH_CHAR), best32.);
    SIGNIFICANTDIGITS = input(strip(SIGNIFICANTDIGITS_CHAR), best32.);
    drop VALUEORDER_CHAR CRFPAGE_CHAR LENGTH_CHAR SIGNIFICANTDIGITS_CHAR;
run;

/* Generate OIDs for value-level (these columns are not in the specification)
   VALUELISTOID    : VL.<DOMAIN>.<VARIABLE>
   ITEMOID         : IT.<DOMAIN>.<VARIABLE>.<VALUENAME>
   WHERECLAUSEOID  : WC_<VARIABLE>.<DOMAIN>.<VALUEVAR>.<VALUENAME>
   (%definexml() parses WHERECLAUSEOID by ".", so avoid "." in the values)
   If the WHERECLAUSEOID column exists in the sheet and has at least one value,
   the sheet values are used as they are; otherwise it is auto-generated. */
%local _wc_user;
%let _wc_user = 0;
proc sql noprint;
    select count(*) into :_wc_user trimmed
    from dictionary.columns
    where libname = "WORK" and memname = "VALUELEVEL" and upcase(name) = "WHERECLAUSEOID";
quit;
%if &_wc_user. > 0 %then %do;
    data VALUELEVEL;
        set VALUELEVEL(rename=(WHERECLAUSEOID=_WC_IN));
        length WHERECLAUSEOID $200;
        WHERECLAUSEOID = strip(vvalue(_WC_IN));
        drop _WC_IN;
    run;
    proc sql noprint;
        select count(*) into :_wc_user trimmed from VALUELEVEL where not missing(WHERECLAUSEOID);
    quit;
    %if &_wc_user. = 0 %then %do;
        data VALUELEVEL;
            set VALUELEVEL(drop=WHERECLAUSEOID);
        run;
    %end;
%end;

data VALUELEVEL;
    set VALUELEVEL;
    length VALUELISTOID ITEMOID $200;
    %if &_wc_user. = 0 %then %do;
        length WHERECLAUSEOID $200;
    %end;
    VALUELISTOID = catx(".", "VL", strip(DOMAIN), strip(VARIABLE));
    ITEMOID = catx(".", "IT", strip(DOMAIN), strip(VARIABLE), strip(VALUENAME));
    %if &_wc_user. = 0 %then %do;
        WHERECLAUSEOID = catx(".", cats("WC_", strip(VARIABLE)), strip(DOMAIN), strip(VALUEVAR), strip(VALUENAME));
    %end;
run;

/* Link variables to their value-level lists */
proc sql;
    create table _VARIABLES_VL as
    select a.*, b.VALUELISTOID
    from VARIABLES a
    left join (select distinct DOMAIN, VARIABLE, VALUELISTOID from VALUELEVEL) b
    on a.DOMAIN = b.DOMAIN and a.VARIABLE = b.VARIABLE;
quit;

data VARIABLES;
    set _VARIABLES_VL;
run;

proc datasets lib=work nolist;
    delete _VARIABLES_VL;
quit;

/* Method information */
data METHODS;
	set spec.COMPUTATION_METHOD;
	rename
	LABEL = COMPUTATIONMETHODNAME
	TYPE = COMPUTATIONMETHODTYPE
	COMPUTATIONMETHOD = DESCRIPTION
	;
run;

/* Codelist information */
data CODES;
	set spec.CODELISTS;
	rename
	CODELISTITEMCODE = CODE
	;
run;
data CODES;
    set CODES(rename=(RANK=RANK_CHAR));
    RANK = input(strip(RANK_CHAR), best32.);
    drop RANK_CHAR;
run;

/* Comment information */
data COMMENTS;
	set spec.COMMENTS;
	rename
	COMMENT = DESCRIPTION
	;
run;

/* External link information */
data DOCUMENTS;
	set spec.EXTERNAL_LINKS;
	rename
	LeafID = PDFLEAF
	LeafRelPath = PDFLINK
	Title = PDFTITLE
	AnnotatedCRF = ANNOTATEDCRF
	;
run;
data DOCUMENTS; /* Convert char to num */
    set DOCUMENTS(rename=(ANNOTATEDCRF=ANNOTATEDCRF_CHAR));
    ANNOTATEDCRF = input(strip(ANNOTATEDCRF_CHAR), best32.);
    drop ANNOTATEDCRF_CHAR;
run;


/* WhereClause (Not in Phuse template) */
data WHERE_CLAUSES;
	set spec.WHERE_CLAUSES;
run;

/* Analysis result (Not in Phuse template) */
data ANALYSIS_RESULTS;
	set spec.ANALYSIS_RESULTS;
run;

libname spec clear;

%mend spec2meta;
