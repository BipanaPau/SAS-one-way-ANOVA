/* create library */

libname rawdata 'X:datafile\';
proc import out= rawdata.file 
 	datafile= "X:filename.csv" 
            dbms=csv replace;
     getnames=yes;
     datarow=2;
run;

/* run ANOVA */
/* 
here we are using 'proc mixed' for ANOVA.
Using 'prco mixed' will allow us to check whether our data meets assumption of ANOVA or not.
no need to run seperate code to check ANOVA assumptions.
Remember to specify 'method=type3' to use ordinary least squares rather than a maximum likelihood method.
this will produce the conventioanl (ANOVA table) output
*/

proc mixed data=rawdata.file method=type3 plots=all;
class treatment;
model y=treatment;
store abc123;
run;

ods html style=stastical sge=on;
proc plm restore= abc123;
lsmeans treatment / adjust=tukey plot=meanplot cl lines;
run;

/* sumarize data  with mean and standard error of mean*/
/* abbreviateion used in SAS for descriptive statistics 
cv - coefficient of variance
max - maximum value
min - minimum value
mean -  average value
n -  no of observation with non-missing value
nmiss -  no of observation with missing value
range - range
std - standard deviation
stderr - standard error of the mean
sum - sum
var - variance
*/

proc summary data=rawdata.file;
class treatment;
var y;
output out=output1 mean=mean stderr=se;
run;
proc print data = output1;
run;
