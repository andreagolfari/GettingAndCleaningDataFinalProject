# Final Project for Getting and Cleaning Data Course
# John Hopkins University - Coursera


# Dowloading data, setting up the environment
library(data.table)
invisible(library(dplyr))

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./Data")){
        dir.create("./Data")
        }
download.file(url, destfile = "./Data/Rawdata.zip", method = "curl")

# Unzipping the file, deleting the zipped file
unzip(zipfile = "./Data/Rawdata.zip",exdir="./Data")
invisible(file.remove("./Data/Rawdata.zip")) # Deleting .zip file

# 1. Merges the training and the test sets.

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

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# tidy_data is the tidy dataset
tidy_data <- cbind(subjectdata, y_data, x_data) %>% 
        select(subject, index, contains("mean"), contains("std"))

# Removing datasets used for the construction of the tidy set
rm(x_data, y_data, subjectdata, features)

# 3. Use descriptive activity names to name the activities in the data set
tidy_data["index"] <- activity_labels[tidy_data$index, 2]

# 4. Appropriately labels the data set with descriptive variable names.

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

# Remove unused dataset
rm(activity_labels)

# 5. Create tidy dataset with means for each activity and subject
tidy_means <- tidy_data %>% group_by(subject, activity) %>%
        summarise_all(list(mean))
tidy_means

# Saving the final dataset, if desired 
write.table(tidy_means, "tidy_means.txt", row.names = FALSE)



