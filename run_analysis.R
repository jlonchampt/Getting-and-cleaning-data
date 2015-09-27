### Packages
library(data.table)
library(dplyr)
library(RCurl)
library(reshape2)

# Creation of the data folder and import of the zip file in the directory

if(!file.exists("./UCI HAR Dataset")){dir.create("./UCI HAR Dataset")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile='UCI HAR Dataset.zip',method="auto")


###Unzip x_meanstdSet
unzip('UCI HAR Dataset.zip')

# The content of each txt file is stored in a data frame 

features <- read.table('./UCI HAR Dataset/features.txt')
colnames(features) <- c("ind", "param")

act_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')
x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
subj_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subj_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')

# "1/ Merges the training and the test sets to create one data set"
#########################################################################

# The test and training x_meanstd sets are merged to get a single x_meanstd set for the 30 volunteers 
# the merging is performed by binding rows (rbind() function) 

x_all <- rbind(x_train,x_test)
y_all <- rbind(y_train,y_test)
subj_all <- rbind(subj_train,subj_test)

# 2/ Extracts only the measurements on the mean and standard deviation for each measurement.
#############################################################################################

# Use the grep function to select the lines containing either the "mean()" or "std()" characters
# the meanFreq() is excluded
# the measurements on the mean and standard deviation are provided in the data frame x_meanstd

mean_std <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x_meanstd <- x_all[, mean_std]


# 3/ Uses descriptive activity names to name the activities in the data set
###########################################################################

# the id and the associated activity names are given in the act_labels data frame
# the activity names are written in small letters
act_labels[, 2] <- tolower(as.character(act_labels[, 2]))

# the id of the activity is replaced by its name 
y_all[, 1] <- act_labels[y_all[, 1], 2]

#The variable name is called 'activity'
colnames(y_all) <- 'activity'


# 4/ Appropriately labels the data set with descriptive variable names.
#######################################################################

names(x_meanstd) <- features[mean_std, 2]

names(x_meanstd)<-gsub("-", "_", names(x_meanstd))
names(x_meanstd)<-gsub("\\(\\)", "", names(x_meanstd))
names(x_meanstd)<-gsub("^f", "f_", names(x_meanstd))
names(x_meanstd)<-gsub("^t", "t_", names(x_meanstd))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
################################################################################################################################################

# creation of a data frame by combining the x_all, y_all and subj_all data frames

colnames(subj_all) <- 'subject'
tidy_df <- cbind (y_all, subj_all, x_meanstd)

str(tidy_df)

# The variables acitvity and subject are set as identifier variables, the other ones are measured variables
tidy_id <- melt(tidy_df, id = c("activity" ,"subject"))

# sort the mean value of each measured variable for each subject and each activity 
tidy_mean <- dcast (tidy_id, subject + activity ~ variable, mean)

str(tidy_mean)

# output of the function : txt file 
write.table(tidy_mean, file = "./tidy_mean.txt",row.name=FALSE)


