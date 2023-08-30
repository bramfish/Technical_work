/* 
This SAS code imports data from a CSV file named "Algorithm.csv" and creates a SAS dataset named "Algorithm". 
The "replace" option is used to replace the dataset if it already exists.
*/

proc import datafile="/path/to/Algorithm.csv"
       out=Algorithm
       dbms=csv
       replace;
run;

/* 2. Procedure to fetch the first column for the Algorithm file called Algorithm Name */
data Algorithm_Name;
   set Algorithm;
   Algorithm_Name = strip(input(scan(Algorithm_Name,1), $50.));
run;

/* 3. Procedure to search the string "Association rules" from the Algorithm Name field and return the Algorithm File Locator field */
data Association_Rules;
   set Algorithm;
   if find(Algorithm_Name, "Association rules") then output;
run;


/* 1. Create synthetic shopping transaction data */
data Shopping_data;
   length Item_Name $50.;
   do i = 1 to 20000;
      Item_Name = cats("Item ", put(i, 5.));
      Price = ceil(ranuni(0) * 100);
      output;
   end;
   drop i;
run;

/* 2. Export shopping transaction data to CSV file */
filename Shopping_data "/Users/fahadanwar/Desktop/Technical_work/SE-CoP_Codify/Data/Shopping_data.csv";
proc export data=Shopping_data
            outfile=Shopping_data
            dbms=csv
            replace;
run;


