## Data

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See *'Features Information'* section for more details. 

##### For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

##### The dataset includes the following files:

- `'features_info.txt'`: Shows information about the variables used on the feature vector.
- `'features.txt'`: List of all features.
- `'activity_labels.txt'`: Links the class labels with their activity name.
- `'train/X_train.txt'`: Training set.
- `'train/y_train.txt'`: Training labels.
- `'test/X_test.txt'`: Test set.
- `'test/y_test.txt'`: Test labels.
- `'train/subject_train.txt'` & `'train/subject_test.txt'`: Each row identifies the subject who performed the activity for each window sample.

##### Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

##### Features Information 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

___

## Script

The *run_analysis.R* script performs data preparation and then performs the steps as per project requirements. Below steps are performed by this script -

1. Downloads the dataset
    Downloads and extracts dataset to working directory

2. Reads the files
    Assigns each file to variables and gives appropriate column names
    * `activities` (6 obs. of  2 variables)
    * `features` (561 obs. of  2 variables)
    * `subject_test` (2947 obs. of  1 variables)
    * `x_test` (2947 obs. of  561 variables)
    * `y_test` (2947 obs. of  1 variables)
    * `subject_train` (7352 obs. of  1 variables)
    * `x_train` (7352 obs. of  561 variables)
    * `y_train` (7352 obs. of  1 variables)

3. Merges the training and the test sets to create one data set
    * `test_data` (2947 obs. of  563 variables) - merged `subject_test`, `y_test`, `x_test` using cbind()
    * `train_data` (7352 obs. of  563 variables) - merged `subject_train`, `y_train`, `x_train` using cbind()
    * `merged_data` (10299 obs. of  563 variables) - merged `train_data`, `test_data` using rbind()

4. Extracts only the measurements on the mean and standard deviation for each measurement
    * `merged_data` (10299 obs. of  88 variables) - sub-setted `merged_data` keeping only columns `subjectId`, `activityId`, and `columns that contain "mean" or "std"`

5. Uses descriptive activity names to name the `activities` in the data set
    * Replaces values of `activityId` in `merged_data` by `activityLabel` in `activities`
  
6. Appropriately labels the data set with descriptive variable names.
    * Renames columns of `merged_data` to have descriptive names using details available in *'Features Information'* section

7. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    * `tidy_data` (180 obs. of  88 variables) - sumarized `merged_data` taking the average of each variable for each activity and each subject using group_by() and summarise_all()
    * Writes `"Tidy_Data.txt"` from `tidy_data`