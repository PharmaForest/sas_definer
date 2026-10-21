/*** HELP START ***//*

### Macro `%definexml_quote_xml()` (internal)

Escapes XML special characters (`& " ' < >`) in all character variables of a WORK dataset.
Used internally by `%definexml()`; not intended to be called directly.

Original work: Copyright (c) 2016 Katja Glass (MIT License).

#### Parameter

- `data` : WORK dataset name to be modified in place

*//*** HELP END ***/

%MACRO definexml_quote_xml(data=);
    %LOCAL l_varlist l_i;

    PROC SQL NOPRINT;
        SELECT name INTO :l_varlist SEPARATED BY ' '
               FROM dictionary.columns WHERE libname="WORK" AND memname="%UPCASE(&data)" and type="char";
    QUIT;

    DATA &data;
        SET &data;
        %DO l_i = 1 %TO %SYSFUNC(COUNTW(%STR( )&l_varlist));
            %SCAN(&l_varlist,&l_i) = TRANWRD(%SCAN(&l_varlist,&l_i),"&",'&amp;');
            %SCAN(&l_varlist,&l_i) = TRANWRD(%SCAN(&l_varlist,&l_i),'"','&quot;');
            %SCAN(&l_varlist,&l_i) = TRANWRD(%SCAN(&l_varlist,&l_i),"'",'&apos;');
            %SCAN(&l_varlist,&l_i) = TRANWRD(%SCAN(&l_varlist,&l_i),"<",'&lt;');
            %SCAN(&l_varlist,&l_i) = TRANWRD(%SCAN(&l_varlist,&l_i),">",'&gt;');
        %END;
    RUN;

%MEND definexml_quote_xml;
