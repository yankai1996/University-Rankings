
/*****************************
My ranking methods
*****************************/

%let root=Y:\TEMP\University-Rankings;
%let root=Y:\Local\GitHub\University-Rankings;
%let excel=&root\excel;
libname out "&root\sasdata";

data rankings; set out.rankings; 
if QS2019<=500;
avg = (QS2019+THE2019+ARWU2018)/3;
if avg~=.;
run;

proc rank data=rankings ties=low out=rank;
var avg;
proc sort; by avg;
run;
data rank; set rank;
if 200<avg<=250 then avg=250;
if 250<avg<=300 then avg=300;
if 300<avg<=400 then avg=400;
run;

PROC EXPORT 
	DATA=rank
	DBMS=excel 
	OUTFILE="&excel\avgRank.xlsx"
	REPLACE;
run;
