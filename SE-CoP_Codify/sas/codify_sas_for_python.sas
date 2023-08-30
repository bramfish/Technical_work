/
/* 1. Method to connect to the PostGres database "DataScience" */
%macro connect_to_db;
    /* Set the libname for the PostGres database */
    libname pgsql odbc dsn='DataScience' user='username' password='password';
%mend;

/* 2. Method to read the table "Algorithm" and fetch the first 1000 rows and return Algorithm Name, Algorithm File Locator fields */
%macro fetch_algorithm_data;
    /* Connect to the PostGres database */
    %connect_to_db;

    /* Create a data set with the first 1000 rows of the Algorithm table */
    data algorithm_data;
        set pgsql.Algorithm(obs=1000);
    run;

    /* Select the Algorithm Name and Algorithm File Locator fields */
    proc sql;
        select Algorithm_Name, Algorithm_File_Locator
        from algorithm_data;
    quit;
%mend;

/* 3. Method to search for the string "Sequencetial Patterns" in Algorithm Name field and return the Algorithm File Locator filed data */
%macro search_algorithm_data;
    /* Fetch the Algorithm Name and Algorithm File Locator fields */
    %fetch_algorithm_data;

    /* Filter the data set to only include rows where the Algorithm Name contains "Sequential Patterns" */
    data sequential_patterns;
        set algorithm_data;
        where find(Algorithm_Name, "Sequential Patterns") > 0;
    run;

    /* Select the Algorithm File Locator field */
    proc sql;
        select Algorithm_File_Locator
        from sequential_patterns;
    quit;
%mend;


/* This SAS code creates a dataset named "race" and calculates the probability of a standard normal distribution with a z-score of -15/sqrt(325). The resulting probability is stored in a variable named "pr". Finally, the "pr" variable is printed using the PROC PRINT procedure. */
data race;
    pr = probnorm(-15/sqrt(325));
    run;
     
    proc print data=race;
    var pr;
    run;

/* 
This SAS code performs a factor analysis on the 'jobratings' dataset, dropping the variable 'Overall Rating'.
The 'priors' option specifies the method for computing the prior communality estimates, and the 'rotate' option specifies the rotation method.
The 'plots' option specifies that a path diagram should be produced.
The 'label' statement assigns new labels to the variables in the output.
*/

ods graphics on;

proc factor data=jobratings(drop='Overall Rating'n)
    priors=smc rotate=quartimin plots=pathdiagram;
label
    'Judgment under Pressure'n ='Judgment'
    'Communication Skills'n = 'Comm Skills'
    'Interpersonal Sensitivity'n = 'Sensitivity'
    'Willingness to Confront Problems'n = 'Confront Problems'
    'Desire for Self-Improvement'n = 'Self-Improve'
    'Observational Skills'n = 'Obs Skills'
    'Dependability'n = 'Dependable';
run;