
/******************************************
Import rank1-rank2 linking files from .csv to .sas7bdat
*******************************************/

%let root=Y:\TEMP\University-Rankings;
%let excel=&root\excel;
libname out "&root\sasdata";


/******************************************
file: 	 the import file path
outname: output data name
name1, name2:	qs_name, the_name, arwu_name
id1, id2:		qd_id, the_id, qrwu_id
*******************************************/
%macro incsv(file, outname, name1, id1, name2, id2);

proc import datafile=&file
	out=&outname
	dbms=csv
	replace;
getnames=yes;
run;

data &outname; set &outname;
&name1 = name1;
&id1 = id1;
&name2 = name2;
&id2 = id2;
score = similarity;
keep &name1 &id1 &name2 &id2 score;
if score=0 then do;
	&id2=.;
	&name2="";
end;
proc sort; by &id1;
run;

%mend incsv;


%incsv("&excel\qs_the.csv", qs_the_link, qs_name, qs_id, the_name, the_id);

/*
data junk; set qs_the_link;
proc sort; by the_id descending score;
run;
data junk; set junk;
by the_id descending score;
if not first.the_id then wrong=1;
if wrong=1 then do;
	the_id=.;
end;
if qs_id<=500;
proc sort; by qs_id;
run;
*/

data qs_the_link; set qs_the_link;
proc sort; by the_id descending score;
run;
data qs_the_link; set qs_the_link;
by the_id descending score;
if (not first.the_id) then do;
	the_id=. ;
	the_name="";
end;
*if qs_id<=595;
drop score;
proc sort; by qs_id;
run;

data out.qs_the_link; set qs_the_link; run;



data qs_the; set out.qs_the_link;
id = the_id;
proc sort; by id;
run;

data qs_the; retain qs_id qs_name THE2019 University;
merge qs_the(in=a) the2019;
by id;
if a;
THE2019 = r;
University = Name;
keep qs_id qs_name THE2019 University country;
proc sort; by qs_id;
run;





proc import datafile="Y:\Desktop\University Rankings\qs_arwu_link.csv"
	out=test
	dbms=csv
	replace;
getnames=yes;
run;


data qs_arwu_link; set test;
qs_name = name1;
qs_id = id1;
arwu_name = name2;
arwu_id = id2;
score = similarity;
keep arwu_name arwu_id qs_name qs_id score;
if score=0 then do;
	arwu_id=.;
	arwu_name="";
end;
proc sort; by qs_id;
run;


data qs_arwu_link; set qs_arwu_link;
proc sort; by arwu_id descending score;
run;
data qs_arwu_link; set qs_arwu_link;
by arwu_id descending score;
if not first.arwu_id then wrong=1;
if wrong=1 then do;
	arwu_id=.;
	arwu_name="";
end;
drop score wrong;
proc sort; by qs_id;
run;

data out.qs_arwu_link; set qs_arwu_link; run;



data qs_arwu; set out.qs_arwu_link;
id=arwu_id;
proc sort; by id;
run;
data qs_arwu; retain qs_id qs_name ARWU2018;
merge qs_arwu(in=a) arwu2018;
by id;
if a;
ARWU2018=r;
keep qs_id qs_name ARWU2018 Institution;
proc sort; by qs_id;
run;



data qs_the_arwu; merge qs_the qs_arwu;
by qs_id;
id=qs_id;
proc sort; by id;
run;

data qs_the_arwu; 
retain QS2019 THE2019 ARWU2018;
merge qs_the_arwu qs2019;
by id;
QS2019=r;
keep QS2019 THE2019 ARWU2018 University Country Institution Institution_name F4;
run;

data final; set qs_the_arwu;
if University="" then University=Institution_name;
if country="" then country=F4;
keep QS2019 THE2019 ARWU2018 University Country;
run;

data out.rankings; set final; run;

