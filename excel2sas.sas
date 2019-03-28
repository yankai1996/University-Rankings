
/******************************************
Import original ranking source files from .xlsx to .sas7bdat
*******************************************/

%let root=Y:\Desktop\University Rankings;
libname out "&root\sasdata";


/******************************************
file: 	 the import file path
sheet: 	 name of sheet to be imported
outname: output data name
*******************************************/
%macro insheet(file, sheet, outname);

proc import out=&outname
	file=&file 
	dbms=excel replace;
sheet=&sheet;
getnames=yes;
run;

%mend insheet;



/************** Get THE2019 ****************/
%insheet("&root\excel\rankings.xlsx", "THE2019", temp);

data THE2019; set temp;
r_temp = compress(rank, "=");
r = input(r_temp, 4.);
if r=. then r=input(r_temp, 3.);
if 200<r<400 then r=r+49;
if 400<r<600 then r=r+99;
if 600<r<1000 then r=r+199;
id=_N_;
run;

data out.THE2019; set THE2019; run;



/************** Get QS2019 ****************/
%insheet("&root\excel\rankings.xlsx", "QS2019", temp);

data QS2019; set temp;
r_temp = strip(_019);
r_temp = compress(r_temp, "=");
r = input(r_temp, 3.);
if 500<r<600 then r=r+9;
if 600<r<800 then r=r+49;
if r>800 then r=1000;
if r=. then r=1001;
if Institution_Name="" then delete;
if F4="" then delete;
drop r_temp;
run;

data QS2019; set QS2019;
id=_N_;
run;

data out.QS2019; set QS2019; run;



/************** Get QS2019 ****************/
%insheet("&root\excel\rankings.xlsx", "ARWU2018", temp);

data ARWU2018; set test;
r = input(World_Rank, 3.);
if 100<r<200 then r=r+49;
if r>200 then r=r+99;
id=_N_;
run;

data out.ARWU2018; set ARWU2018; run;


