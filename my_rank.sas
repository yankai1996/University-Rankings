
libname out "Y:\TEMP\University-Rankings\sasdata";

data rankings; set ur.rankings; 
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
	OUTFILE='Y:\TEMP\University-Rankings\excel\avgRank.xlsx'
	REPLACE;
run;
