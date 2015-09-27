
Getting and Cleaning Data Course Project


Introduction

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  


Raw data


The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


Objective


You should create one R script called run_analysis.R that does the following. 

1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names. 
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


run_analysis.R Script

The script performs the following :

⦁	It downloads the UCI HAR Dataset data set zip file and unzip it in my local UCI HAR Dataset folder.
⦁	It loads the test and training .txt files into data frames. The .txt files and associated data frames are the following: 
		- 'activity_labels.txt' / 'act_labels'
		- 'train/X_train.txt' / 'x_train'
		- 'train/y_train.txt' / 'y_train'
		- 'test/X_test.txt' / 'x_test'
		- 'test/y_test.txt' / 'y_test'
⦁	The train and test data frames are merged into a single data frame. This is done using the rbind() function. The resulting data frames are the following :
		- 'x_all'
		- 'y_all'
		- 'subj_all'
⦁	It selects the mean and standard deviation variables from the  'x_all' data set. This is done using the select function of the dplyr package. The resulting data frame is named 'x_meanstd'
⦁	The activity names of the 'y_all' data frame are named, based on the id/name association provided in the 'act_labels' data frame. The name 'activity' is given to the activity column. 
⦁	The variable names of the 'x_all' data frame are cleaned : short names replaced by explicit full names, small letters, '()'  deleted. It is done by using the gsub() function.
⦁	The name 'subject' is given to the subject column of the 'subj_all' data frame. 
⦁	The 'x_all', 'y_all' and 'subj_all' data frames are merged in a single tidy data frame that is named 'tidy_df'.
⦁	The melt() function is used to set the activity and subject columns of the 'tidy_df' as identifiers. The other columns are defined as measured variables.  
⦁	The dcast() function is used to determine  the mean of each variable for each activity and each subject. The results are provided in the 'tidy_mean' data frame. They are also exported into the 'tidy_mean.txt' file.  

    
The R code contains str() functions for easier preview of the 'tidy_df' and 'tidy_mean' data frames.

Tidy data

The tidy data is available in the tidy_mean.txt file. The structure of this file is detailed in the Codebook file. 


