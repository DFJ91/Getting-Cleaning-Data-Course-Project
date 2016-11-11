# Getting-Cleaning-Data-Course-Project

The code that appears in the file run_analysis allows to obtain a table where the average of each variable for each activity and each subject is collected. Just run the script and create a txt file with this table in the working directory.( Here is a code to read the txt file: 

data <- read.table(file_path, header = TRUE) 
    View(data)
)

The script is commented on with all the steps that have been followed. The following are all of them:

Install the downloader package to download and unzip the zip file

Download and decompress the file

Change working directory to join test data

Post the data in different tables and then join them

Join the three tables: 1) subject_test, 2) y_test, 3) X_test

I repeat the same steps for the data corresponding to train

I join the three tables: 1) subject_train, 2) y_train, 3) X_train

Now join the two tables Test_Result_Train and Test_result_Test together

##################### SECOND PART ############################

In the features.txt file I identify the columns that have the word mean ()
and std()

It also includes the average frequency; I have included it because it is also
a measure that has been taken

I create a vector with 79 positions to indicate in the columns
that I have to keep

I join in the same vector Mean_col and Std_col

Having added two columns you have to move the values 2 times

I now select the columns I need

################# THIRD PART ##############################

I will change descriptive numbers by name to
for column 2. I will use the same names as in 
the txt

################## FOURTH PART ############################


I condition the feature.txt tags

I use the features_v2 tags to name the variables

##################### FIFTH PART ######################
 I create 30 tables where I collect the information of each subject ##

To access each table and check that the loop
evolves correctly

Now I join all the tables in one

I finally write a txt file
