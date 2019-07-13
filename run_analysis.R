## Download the Data Set 
if(!file.exists("./Project")){dir.create("./Project")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./Project/Dataset.zip", method = "curl")

## Get a list of, and examine the contents of the Zip file 

names <- unzip("./Project/Dataset.zip", list = TRUE)
View(names)

## Unzip the file and examine its contents 

unzip("./Project/Dataset.zip", exdir = "./Project")
list.files("./Project") 
list.files("./Project/UCI HAR Dataset") ## The unzipped files are in this folder

project_path <- file.path("./Project", "UCI HAR Dataset")
contents <- list.files(project_path, all.files = TRUE, full.names = TRUE, recursive = TRUE)
View(contents) ## These are the files that will be used for this Project

## Load the data and examine their features 

features <- read.table("./Project/UCI HAR Dataset/features.txt", header = FALSE)
train_data <- read.table("./Project/UCI HAR Dataset/train/X_train.txt")
test_data <- read.table("./Project/UCI HAR Dataset/test/X_test.txt")
train_subject <- read.table("./Project/UCI HAR Dataset/train/subject_train.txt")
test_subject <- read.table("./Project/UCI HAR Dataset/test/subject_test.txt")
train_labels <- read.table("./Project/UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("./Project/UCI HAR Dataset/test/y_test.txt")

str(features) ## list of features 
str(train_data) ## results from training data group
str(test_data)  ## results from test data group
str(train_subject) ## subject identifiers 
str(test_subject) ## subject identifiers 
str(test_labels) ## contains test labels 
str(train_labels) ## contains training labels 

## (1) Merge the training and test sets to create one data set 
## Each data set with 561 columns for the obtained variables (features); 
## therefore must bind by rows (rbind)

merged_data <- rbind(train_data, test_data)

## list of the calculated features (the variables in merged_data)  is found in features.txt 

View(features) ## Examine the content
names(features)
colnames(merged_data) <- features$V2

## The labels correspond to each observation of the train and test data sets, so 
## should row bind train_labels and test_labels

merged_labels <- rbind(train_labels, test_labels) 
colnames(merged_labels) <- "label"
head(merged_labels)

## Should also row bind the subject data sets to correspond to each observation
## in merged_data

merged_subjects <- rbind(train_subject, test_subject)
colnames(merged_subjects) <- "subject"
head(merged_subjects)

## Check dimensions if merged properly
dim(merged_data)
dim(merged_labels)
dim(merged_subjects)

## Merge the 3 merged sets to form 1 data set 
## All data sets have 10,299 observation. Each row of the 
## merged_labels and merged_subjects sets correspond to an 
## observation on merged_data. Thus, must bind merged_labels 
## and merged_subjects to merged_data by column 

TidyData1 <- cbind(merged_subjects, merged_labels, merged_data)


## (2) Extract the measurements of the mean and sd for each measurement
## First select all the variable names which contain either "mean" or "std"
## Then subset TidyData1 based on the extracted variable names 

var_names <- names(TidyData1)
meansd_subset <- TidyData1[,grep("[Mm]ean\\(\\)|[Ss]td\\(\\)", var_names)]
meansd_subset <- names(meansd_subset)
TidyData1_subset <- c("subject", "label", as.character(meansd_subset))
TidyData1 <- TidyData1[TidyData1_subset]

## (3) Use descriptive activity names to name the activities in the data set 
## Descriptive activity names are in activity_labels.txt 

act_colnames <- c("label", "activity")
activities <- read.table("./Project/UCI HAR Dataset/activity_labels.txt", col.names = act_colnames)

## Convert the activities column ("label") to the factor class
class(TidyData1$label)
TidyData1$label <- factor(TidyData1$label, levels = 1:6, labels = c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying"))

## (4) Label the data set with descriptive variable names 

## subject column is already descriptive 
## First convert the activities column 

names(TidyData1)[2] <- "activity" 

## only features columns left to be changed 

listnames <- names(TidyData1)
View(listnames) ## Check which parts of the names to change

names(TidyData1) <- gsub("^t", "Time", names(TidyData1))
names(TidyData1) <- gsub("-mean()", "Mean", names(TidyData1))
names(TidyData1) <- gsub("-std()", "StD", names(TidyData1))
names(TidyData1) <- gsub("Acc", "Accelerometer", names(TidyData1))
names(TidyData1) <- gsub("Gyro", "Gyroscope", names(TidyData1))
names(TidyData1) <- gsub("Mag", "Magnitude", names(TidyData1))
names(TidyData1) <- gsub("^f", "Frequency", names(TidyData1))

## (5) Create a second, independent tidy data set with the 
## average of each variable for each activity and each subject.

library(dplyr)

TidyData2 <- TidyData1 %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean = mean))

write.table(TidyData2, file = "tidydata2.txt", row.name = FALSE)

View(TidyData2) ## Check the resulting data frame 

## Create a codebook 

library(dataMaid)
library(labelled)

## Enter short descriptions for the Codebook, to provide more information
attr(TidyData1$activity, "shortDescription") <- "The activities performed by the subjects during data collection."
attr(TidyData1$subject, "shortDescription") <- "A group of 30 volunteers within the 19-48 years old age bracket."
attr(TidyData1[3:68], "shortDescription") <- "The features come from the accelerometer and gyroscope 3-axial raw signals TAccelerometer-XYZ and TGyroscope-XYZ."
attr(TidyData2, "shortDescription") <- "Contains the average of each feature for each activity, computed per subject."

codebook <- makeCodebook(TidyData2, reportTitle = "MyCodebook", file = "MyCodebook.Rmd")

