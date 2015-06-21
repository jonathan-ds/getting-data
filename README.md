#README.md
#Assignment #1 for course: Getting and Cleaning Data
### Overview and Operation:
This assignment consists of a script "run_analysis.R". When the current working directory contains this script it may be run by typing the following:
>source("run_analysis.R")

To read the resulting datafile in please use a command like:
>read.table("assignment1.txt",header=T)
### Dependencies
In order for the script to work the current working directory must contain a folder called UCI HAR Dataset and that folder needs to contain the following:
* features.txt
* activity_labels.txt

A directory named "test"  containing:
* X_test.txt
* y_test.txt
* subject_test.txt

A directory named "train" containing:
* X_train.txt
* y_train.txt
* subject_train.txt

###How it works:
Once run the script does the following:
* Loads in the X_test.txt, y_test.txt and subject_test.txt files using read.table(). file.path() is used to avoid problems with platform dependent path deparators.
* Uses cbind() to create one large data.frame with all the test data.
* Loads in the X_train.txt, y_train.txt and subject_train.txt files using read.table(). file.path() is used to avoid problems with platform dependent path deparators.
* Uses cbind() to create one large data.frame with all the training data.
* rbind() is then used to join both the test and training data.  
* This accomplishes the first requirement for our R script: "Merges the training and the test sets to create one data set."
* Next the script loads the features.txt file using read.table()
* grepl() is used twice, once to produce a logical vector containing TRUE for every column with -mean() and again to produce a logcial vector containing TRUE for every column with -std().
* We OR these two vectors together and use them to select the columns "subject", "activity" and every column containing either -std() OR -mean().
* We store this extracted data.frame in a new data.frame.  This accomplishes the second requriement for our R script: "Extracts only the measurements on the mean and standard deviation for each measurement."
* We then read activity_labels.txt into a table using read.table()
* Using factor() we create a vector containing the data from the activity column of our master dataset but with labels like:
>* WALKING
>* WALKING_UPSTAIRS
>* WALKING_DOWNSTAIRS
>* SITTING
>* STANDING
>* LAYING
* Now we replace the column in our master dataset with the column we just created.  This meets requirement number three for our R script: "Uses descriptive activity names to name the activities in the data set"
* We now create a subset called tidy_table from our master dataset.  Using the data.table ability to use a list to create columns which contain the mean() of each measurement column.  While we are doing that we rename these columns to have meaningful names.  This satisfies requirement four for our script: "Appropriately labels the data set with descriptive variable names."
* Finally we set the by= property to group the columns by subject and activity.  This meets requirement five for our script: "creates a second, independent tidy data set with the average of each variable for each activity and each subject"
* The script then saves this tidy dataset as "assignment1.txt", using write.table() setting row.name=F.