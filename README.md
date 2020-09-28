# GettingCleaningData

This is the course project for the Getting and Cleaning Data Coursera course.
The included R script, run_analysis.R, conducts the following:

1. Download the dataset from web if it does not already exist in the working directory.
2. Read both the train and test datasets and merge them.
3. Load the datafeature, activity info and extract columns that include "mean" & "std" in their name.
4. Modify all remaining column name to be more descriptive.
5. Generate 'Tidy Dataset' that consists of the average (mean) of each variable for each subject and each activity.
