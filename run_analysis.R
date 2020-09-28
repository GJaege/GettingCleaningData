## Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## You should create one R script called run_analysis.R that does the following.
# 1- Merges the training and the test sets to create one data set.
# 2- Extracts only the measurements on the mean and standard deviation for each measurement.
# 3- Uses descriptive activity names to name the activities in the data set
# 4- Appropriately labels the data set with descriptive variable names.
# 5- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Loading libraries
library(dplyr); library(stringr)

## Downloading Data
if (!file.exists("./data")) {dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./data/CPdata.zip")
unzip("./data/CPdata.zip", exdir = "./data/CPdata")


## Reading data
features <- read.table("./data/CPdata/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./data/CPdata/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./data/CPdata/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./data/CPdata/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("./data/CPdata/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./data/CPdata/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./data/CPdata/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("./data/CPdata/UCI HAR Dataset/train/y_train.txt", col.names = "code")


## Cleaning data

### 1- Merges the training and the test sets to create one data set.
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged_data <- cbind(subject, y, x)

### 2- Extracts only the measurements on the mean and standard deviation for each measurement.
tidy_data <- merged_data %>% select(subject, code, contains("mean"), contains("std"))
head(tidy_data)

### 3- Uses descriptive activity names to name the activities in the data set
tidy_data$code <- activities[tidy_data$code, 2]

### 4 - Appropriately labels the data set with descriptive variable names.
names(tidy_data)
names(tidy_data)[2] <- "activity"
names(tidy_data) <- str_replace_all(names(tidy_data), "Acc", "Accelerometer")
names(tidy_data) <- str_replace_all(names(tidy_data), "Gyro", "Gyroscope")
names(tidy_data) <- str_replace_all(names(tidy_data), "Mag.", "Magnitude")
names(tidy_data) <- str_replace_all(names(tidy_data), "BodyBody", "Body")
names(tidy_data) <- str_replace_all(names(tidy_data), "^t", "Time")
names(tidy_data) <- str_replace_all(names(tidy_data), "^f", "Frequency")
names(tidy_data) <- str_replace_all(names(tidy_data), "tBody", "TimeBody")
names(tidy_data) <- str_replace_all(names(tidy_data), "-mean()", "Mean")
names(tidy_data) <- str_replace_all(names(tidy_data), "-std()", "STD")
names(tidy_data) <- str_replace_all(names(tidy_data), "-freq()", "Frequency")
names(tidy_data) <- str_replace_all(names(tidy_data), "angle", "Angle")
names(tidy_data) <- str_replace_all(names(tidy_data), "gravity", "Gravity")

### 5- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
final_data <- tidy_data %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))

write.table(final_data, "FinalData.txt", row.name=FALSE)