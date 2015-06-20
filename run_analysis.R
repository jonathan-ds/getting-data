#run_analys.R
#
#Purpose:  This program creates a tidy dataset from the UCI HAR Dataset
# The resulting dataset contains averages for for average and standard
# deviation values in the original UCI HAR Dataset.  This information
# is pulled from both the test and training datasets.
# This dataset is then writen out to a file called "assignment1.txt"
# in the current working directory.
#
#Assumptions: This script assumes that the "UCI HAR Dataset" folder is in
# the working directory of this script.
#

# First we load in the test data.  We use file.path so that we don't
# have to worry about platform differences in path separators.
test_x<-read.table(file.path("UCI HAR Dataset","test","X_test.txt"))
test_y<-read.table(file.path("UCI HAR Dataset","test","y_test.txt"))
test_subject<-read.table(file.path("UCI HAR Dataset","test","subject_test.txt"))

# ...and create one large data.frame
all_test_data <- cbind(test_subject,test_y,test_x)

# Then we load all the training data
train_x<-read.table(file.path("UCI HAR Dataset","train","X_train.txt"))
train_y<-read.table(file.path("UCI HAR Dataset","train","y_train.txt"))
train_subject<-read.table(file.path("UCI HAR Dataset","train","subject_train.txt"))

# ...and create a large data.frame from it
all_train_data <- cbind(train_subject,train_y,train_x)

# Then we combine both into a single data.frame
combined_data <-rbind(all_test_data,all_train_data)

# Now we load the feature data from the UCI HAR dataset
features<-read.table(file.path("UCI HAR Dataset","features.txt"))

# Create logical vectors for any column named -mean() or -std()
means <- grepl('-mean\\(',features[,2])
stds <- grepl('-std\\(',features[,2])

# Create a single data set containing only the subject,activity and the
# selected std()/mean() columns. Since the subject and activity columns
# are at the start of the data.frame we can use the vector c(T,T,means|stds)
# to include those two columns.
extracted <- combined_data[,c(T,T,means|stds)]

# Now we read in the activity lables and create a factor with the
# activity labels instead of numbers.
activity_labels<-read.table(file.path("UCI HAR Dataset","activity_labels.txt"))
labeled_activities<-factor(extracted[,2], labels=activity_labels[,2])

#Then we replace the activity column in the original data.frame
#with this column of labeled activities.
extracted[2] <- labeled_activities

#Column names with a "-" and "()" in them are difficult to work with so
#we replace the "-" with the underscore "_" and remove the brackets "()"
#altogether,
names(extracted) <- c("subject","activity",as.character(features[mns|stds,2]))
names(extracted) <- gsub("-","_",names(extracted))
names(extracted) <- gsub("\\(\\)","",names(extracted))

#Now we turn this into a data.table
library(data.table)
master_data_table <-data.table(extracted)

#Then use the "by" function of the data.table we create a new table
#which contains averages of each variable for every subject and activity

tidy_table <- master_data_table[,list(Average_tBodyAcc_mean_X=mean(tBodyAcc_mean_X),
         Average_tBodyAcc_mean_Y=mean(tBodyAcc_mean_Y),
         Average_tBodyAcc_mean_Z=mean(tBodyAcc_mean_Z),
         Average_tBodyAcc_std_X=mean(tBodyAcc_std_X),
         Average_tBodyAcc_std_Y=mean(tBodyAcc_std_Y),
         Average_tBodyAcc_std_Z=mean(tBodyAcc_std_Z),
         Average_tGravityAcc_mean_X=mean(tGravityAcc_mean_X),
         Average_tGravityAcc_mean_Y=mean(tGravityAcc_mean_Y),
         Average_tGravityAcc_mean_Z=mean(tGravityAcc_mean_Z),
         Average_tGravityAcc_std_X=mean(tGravityAcc_std_X),
         Average_tGravityAcc_std_Y=mean(tGravityAcc_std_Y),
         Average_tGravityAcc_std_Z=mean(tGravityAcc_std_Z),
         Average_tBodyAccJerk_mean_X=mean(tBodyAccJerk_mean_X),
         Average_tBodyAccJerk_mean_Y=mean(tBodyAccJerk_mean_Y),
         Average_tBodyAccJerk_mean_Z=mean(tBodyAccJerk_mean_Z),
         Average_tBodyAccJerk_std_X=mean(tBodyAccJerk_std_X),
         Average_tBodyAccJerk_std_Y=mean(tBodyAccJerk_std_Y),
         Average_tBodyAccJerk_std_Z=mean(tBodyAccJerk_std_Z),
         Average_tBodyGyro_mean_X=mean(tBodyGyro_mean_X),
         Average_tBodyGyro_mean_Y=mean(tBodyGyro_mean_Y),
         Average_tBodyGyro_mean_Z=mean(tBodyGyro_mean_Z),
         Average_tBodyGyro_std_X=mean(tBodyGyro_std_X),
         Average_tBodyGyro_std_Y=mean(tBodyGyro_std_Y),
         Average_tBodyGyro_std_Z=mean(tBodyGyro_std_Z),
         Average_tBodyGyroJerk_mean_X=mean(tBodyGyroJerk_mean_X),
         Average_tBodyGyroJerk_mean_Y=mean(tBodyGyroJerk_mean_Y),
         Average_tBodyGyroJerk_mean_Z=mean(tBodyGyroJerk_mean_Z),
         Average_tBodyGyroJerk_std_X=mean(tBodyGyroJerk_std_X),
         Average_tBodyGyroJerk_std_Y=mean(tBodyGyroJerk_std_Y),
         Average_tBodyGyroJerk_std_Z=mean(tBodyGyroJerk_std_Z),
         Average_tBodyAccMag_mean=mean(tBodyAccMag_mean),
         Average_tBodyAccMag_std=mean(tBodyAccMag_std),
         Average_tGravityAccMag_mean=mean(tGravityAccMag_mean),
         Average_tGravityAccMag_std=mean(tGravityAccMag_std),
         Average_tBodyAccJerkMag_mean=mean(tBodyAccJerkMag_mean),
         Average_tBodyAccJerkMag_std=mean(tBodyAccJerkMag_std),
         Average_tBodyGyroMag_mean=mean(tBodyGyroMag_mean),
         Average_tBodyGyroMag_std=mean(tBodyGyroMag_std),
         Average_tBodyGyroJerkMag_mean=mean(tBodyGyroJerkMag_mean),
         Average_tBodyGyroJerkMag_std=mean(tBodyGyroJerkMag_std),
         Average_fBodyAcc_mean_X=mean(fBodyAcc_mean_X),
         Average_fBodyAcc_mean_Y=mean(fBodyAcc_mean_Y),
         Average_fBodyAcc_mean_Z=mean(fBodyAcc_mean_Z),
         Average_fBodyAcc_std_X=mean(fBodyAcc_std_X),
         Average_fBodyAcc_std_Y=mean(fBodyAcc_std_Y),
         Average_fBodyAcc_std_Z=mean(fBodyAcc_std_Z),
         Average_fBodyAccJerk_mean_X=mean(fBodyAccJerk_mean_X),
         Average_fBodyAccJerk_mean_Y=mean(fBodyAccJerk_mean_Y),
         Average_fBodyAccJerk_mean_Z=mean(fBodyAccJerk_mean_Z),
         Average_fBodyAccJerk_std_X=mean(fBodyAccJerk_std_X),
         Average_fBodyAccJerk_std_Y=mean(fBodyAccJerk_std_Y),
         Average_fBodyAccJerk_std_Z=mean(fBodyAccJerk_std_Z),
         Average_fBodyGyro_mean_X=mean(fBodyGyro_mean_X),
         Average_fBodyGyro_mean_Y=mean(fBodyGyro_mean_Y),
         Average_fBodyGyro_mean_Z=mean(fBodyGyro_mean_Z),
         Average_fBodyGyro_std_X=mean(fBodyGyro_std_X),
         Average_fBodyGyro_std_Y=mean(fBodyGyro_std_Y),
         Average_fBodyGyro_std_Z=mean(fBodyGyro_std_Z),
         Average_fBodyAccMag_mean=mean(fBodyAccMag_mean),
         Average_fBodyAccMag_std=mean(fBodyAccMag_std),
         Average_fBodyBodyAccJerkMag_mean=mean(fBodyBodyAccJerkMag_mean),
         Average_fBodyBodyGyroMag_mean=mean(fBodyBodyGyroMag_mean),
         Average_fBodyBodyGyroMag_std=mean(fBodyBodyGyroMag_std),
         Average_fBodyBodyGyroJerkMag_mean=mean(fBodyBodyGyroJerkMag_mean),
         Average_fBodyBodyGyroJerkMag_std=mean(fBodyBodyGyroJerkMag_std)
         ),by=list(subject,activity)]

#Set the table to order by subject for convenience
setorder(tidy_table,subject)

#Now write the table out to a file.
write.table(tidy_table,"assignment1.txt",row.name=F)