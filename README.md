Getting and Cleaning Data Course Project

Included Files: 
1. MyCodebook.Rmd, which describes the variables, the data, and the transformations which were performed on the data. 
2. run_analysis.R, which performs the 5 required items for the Project. 
3. TidyData2.txt, which is the data set obtained in Item 5 of the Project instructions. 

A. Set-up for the Project
1. The data set was downloaded from the provided website. 
2. The unzipped files were extracted to the UCI HAR Dataset folder. 
3. The unzipped files were loaded to R and their contents and structure were examined.

B. Merge the training and test sets to create one data set
1.Both X_train.txt and X_test.txt contain 561 columns. Each column corresponds to one measured feature (variable). These data sets must thus be merged by their rows, resulting in merged_data.
2. The variable names for these columms are in features.txt. Use these names as the column names for the merged data sets. 
3. y_train.txt and y_test.txt correspond to each observation of X_train.txt and X_test.txt, respectively. These 2 should also be merged by their rows, resulting in merged_labels.
4. subject_train.txt and subject_test.txt also correspond to each observation of X_train.txt and X_test.txt. These 2 should also be merged by their rows resulting in merged_subjects. 
5. Each row of merged_labels and merged_subjects correspond to an observation in merged_data. Thus, must bind merged_labels and merged_subjects to merged_data by column, resulting in TidyData1. 

C. Extract the measurements of the mean and sd for each measurement
1. Select all the variable names which contain either "mean" or "std".
2. Subset TidyData1 based on the extracted variable names

D. Use descriptive activity names to name the activities in the data set 
1. Descriptive activity names are in activity_labels.txt.
2. Convert the activities column ("label") to the factor class, using the activity names in activity_labels.txt as the factors. 

E. Label the data set with descriptive variable names
1. Subject column is already descriptive 
2. Change "label" column to "activities"
3. Change the remaining variable names as follows: 
  t -- Time
  f -- Frequency
  mean -- Mean
  std -- StD
  Acc -- Accelerometer
  Gyro -- Gyroscope
  Mag -- Magnitude

F. Create a second, independent tidy data set with the 
average of each variable for each activity and each subject
1. Split TidyData1 by subject and activity
2. Obtain the mean on the split data set 