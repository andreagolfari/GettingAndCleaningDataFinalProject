---
title: "ReadMe.md"
author: "Andrea Golfari"
output: html_document
---

## Getting and Cleaning Data Course Final Project

This repository is my submission for the final project of the Getting and Cleaning Data course.

It uses data collected from the accellerometers and gyroscopes in smartphones that was collected from 30 volunteers while engaged in different activities.
More specific information on the experiment is available from this webpage:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

* ```CodeBook.md``` provides a description of the variables and parameters of the source datasets, as well as information about the transformations that the code in ```run_analysis.R``` performs on the data.

* ```run_analysis.R``` contains all the code to download, prepare, clean the data.

1. The data downloaded in several different .txt files in assembled in one dataset
2. The data related to mean and standard deviation of the measurements is isolated
3. Human readable names are given to the activities recorded
4. Human readable labels are given to the variable names
5. A new, indipendent tidy dataset with the mean value for each subject and activity is created

If desired, the new tidy dataset can be exported to a .txt file.

### Detailed description of ```run_analysis.R```

The script performs a check to verify if a folder "./Data" exists and creates it if not. Then downloads the compressed file from its url location, unzips it inside the Data folder and deletes the zipped file.

``` 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./Data")){
        dir.create("./Data")
        }
download.file(url, destfile = "./Data/Rawdata.zip", method = "curl")

# Unzipping the file, deleting the zipped file

unzip(zipfile = "./Data/Rawdata.zip",exdir="./Data")
invisible(file.remove("./Data/Rawdata.zip")) # Deleting .zip file
```

#### 1. Merges the training and the test sets.

```features``` will contain the list of all the variables that have been recorded by the triaxial accelerometers and gyroscopes 

```activity_labels``` will contain the key explaining what the 6 activities performed are in a human redable form

```subjectdata``` is created binding the data on the subjects that participated in the experiment

```x_data``` is created binding the data on features test and train

```y_data``` is created binding the data on activities test and train

```
features <- read.table("Data/UCI HAR Dataset/features.txt", col.names = c("index","feat"))
activity_labels <- read.table("Data/UCI HAR Dataset/activity_labels.txt", col.names = c("index", "activity"))

subjectdata <- rbind(read.table("Data/UCI HAR Dataset/train/subject_train.txt", 
                                header = FALSE, col.names = "subject"),
                     read.table("Data/UCI HAR Dataset/test/subject_test.txt", 
                                header = FALSE, col.names = "subject"))

x_data <- rbind(read.table("Data/UCI HAR Dataset/train/x_train.txt", 
                           header = FALSE, col.names = features[, 2]),
                read.table("Data/UCI HAR Dataset/test/x_test.txt", 
                           header = FALSE, col.names = features[, 2]))

y_data <- rbind(read.table("Data/UCI HAR Dataset/train/y_train.txt", 
                           header = FALSE, col.names = "index"),
                read.table("Data/UCI HAR Dataset/test/y_test.txt", 
                           header = FALSE, col.names = "index"))
```
In the next step a merged, tidy dataset ```tidy_data``` is created binding the three datasets, while also selecting only the measurement data on means and standard deviation.

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

```
tidy_data <- cbind(subjectdata, y_data, x_data) %>% 
        select(subject, index, contains("mean"), contains("std"))
```
The datasets used to construct tidy_data are now supefluous and are removed to free some memory.
```
rm(x_data, y_data, subjectdata, features)
```
#### 3. Use descriptive activity names to name the activities in the data set
Descriptive labels are taken from the ```activity_labels``` dataset

```
tidy_data["index"] <- activity_labels[tidy_data$index, 2]
```

#### 4. Appropriately labels the data set with descriptive variable names.

Using the function ```gsub``` to make the names human readable

```
names(tidy_data)[2] = "activity"
names(tidy_data) <- gsub("-mean()", "Mean"      , names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("mean", "Mean"         , names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-std()", "StDev"      , names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("std", "StDev"         , names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("-freq()", "Frequency" , names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub("Acc" , "Accelerometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope"    , names(tidy_data))
names(tidy_data) <- gsub("BodyBody", "Body"     , names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude"     , names(tidy_data))
names(tidy_data) <- gsub("^t", "Time"           , names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency"      , names(tidy_data))
names(tidy_data) <- gsub("tBody", "TimeBody"    , names(tidy_data))
names(tidy_data) <- gsub("angle", "Angle"       , names(tidy_data))
names(tidy_data) <- gsub("gravity", "Gravity"   , names(tidy_data))
```

The dataset ```activity_labels``` is now superfluous and is removed from memory.

```rm(activity_labels)```

#### 5. Create tidy dataset with means for each activity and subject

```tidy_means``` is created grouping by subject and activity and computing the means

```
tidy_means <- tidy_data %>% group_by(subject, activity) %>%
        summarise_all(list(mean))
tidy_means
```

Saving the final dataset to text file, if desired 

``` # write.table(tidy_means, "tidy_means.txt", row.names = FALSE)```

