/* 1. Procedure to read a csv file "Algorithm" */
proc import datafile="/path/to/Algorithm.csv" out=Algorithm dbms=csv replace;
    getnames=yes;
run;

/* 2. Procedure to fetch the first column for the Algorithm file called Algorithm Name */
data Algorithm_Name;
    set Algorithm;
    Algorithm_Name = strip(input(scan(Algorithm_Name, 1, ','), $50.));
run;

/* 3. Procedure to search the string "Association rules" from the Algorithm Name field and return the Algorithm File Locator field */
data Association_Rules;
    set Algorithm;
    if find(Algorithm_Name, "Association rules") then output;
run;

/* Method to read Shopping_data.csv file from Data sub-folder and return the data as list */
data shopping_data;
    infile "Data/Shopping_data.csv" dlm=',' firstobs=2;
    length Customer_ID $ 10 Gender $ 1 Age 8. Item_Category $ 20;
    input Customer_ID Gender Age Item_Category;
    datalines;
run;

/* Convert the data to a list */
proc sql noprint;
    select * from shopping_data into :shopping_data_list separated by '|';
quit;

/* Second method to apply Association Rules Algorithm on first field of the list and print the results on console */
%macro apply_association_rules;
    /* Create a temporary dataset with the shopping data */
    data temp_data;
        length Customer_ID $ 10 Gender $ 1 Age 8. Item_Category $ 20;
        infile datalines dlm=',' firstobs=2;
        input Customer_ID Gender Age Item_Category;
        datalines;
        %let i = 1;
        %do %while (%scan(&shopping_data_list, &i, |) ne %str());
            %let item = %scan(&shopping_data_list, &i, |);
            "&item" %let i = %eval(&i + 1);
        %end;
    run;
    
    /* Apply the Association Rules Algorithm on the first field */
    proc arules data=temp_data;
        item Item_Category;
    run;
    
    /* Print the results on the console */
    proc print data=temp_data;
    run;
%mend apply_association_rules;

/* Call the second method */
%apply_association_rules;
