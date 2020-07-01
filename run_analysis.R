library(dplyr)

#-------------------------------------------------------------------------------

# download zip file - only if it is not downloaded already
zipfile <- "Dataset.zip"

if (!file.exists(zipfile)){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, zipfile)
}  

# unzip - only if not done already
if (!file.exists("UCI HAR Dataset")) { 
  unzip(zipfile) 
}

#-------------------------------------------------------------------------------

# read all files and assign appropriate column names

# read activity labels
activities    <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityId", "activityLabel"))

# read feature vector
features      <- read.table("UCI HAR Dataset/features.txt", col.names = c("featureId", "featureLabel"))

# read test data
subject_test  <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subjectId")
x_test        <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$featureLabel)
y_test        <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activityId")

# read training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subjectId")
x_train       <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$featureLabel)
y_train       <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activityId")

#-------------------------------------------------------------------------------

# Step 1 - Merges the training and the test sets to create one data set.

test_data   <- cbind(subject_test, y_test, x_test)
train_data  <- cbind(subject_train, y_train, x_train)
merged_data <- rbind(train_data, test_data)

#-------------------------------------------------------------------------------

# Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement.

merged_data <- merged_data %>% 
  select(subjectId, activityId, contains("mean"), contains("std"))

#-------------------------------------------------------------------------------

# Step 3 - Uses descriptive activity names to name the activities in the data set

merged_data$activityId <- activities[merged_data$activityId, 2]

#-------------------------------------------------------------------------------

# Step 4 - Appropriately labels the data set with descriptive variable names.

names(merged_data) [1] <- "Subject"
names(merged_data) [2] <- "Activity"
names(merged_data) <- gsub("[[:punct:]]", "", names(merged_data))
names(merged_data) <- gsub("mean", "Mean", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("std", "Std", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("tBody", "TimeBody", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("tgravity", "TimeGravity", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("fBody", "FreqBody", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("freq", "Frequency", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("Acc", "Accelerometer", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("Gyro", "Gyroscope", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("Mag", "Magnitude", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("angle", "Angle", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("gravity", "Gravity", names(merged_data), ignore.case = TRUE)
names(merged_data) <- gsub("BodyBody", "Body", names(merged_data), ignore.case = TRUE)

#-------------------------------------------------------------------------------

# Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_data <- merged_data %>%
  group_by(Subject, Activity) %>%
  summarise_all(list(mean = mean))

# write output file
write.table(tidy_data, "Tidy_Data.txt", row.names=FALSE)
