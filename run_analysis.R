##Merges the training and the test sets to create one data set.
#download data from cloudfront
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#unzip downloaded file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#load packages dplyr, data.table and tidyr
library(dplyr)
library(data.table)
library(tidyr)

#read in the necessary files 1. test/subject_test.txt, 2. train/subject_train.txt, 3. test/X_test.txt, 4. train/X_train.txt, 5. test/y_test.txt 6. train/y_train.txt 7. features.txt 8. activity_lables.txt and create tables
filePath <- "./data/UCI HAR Dataset"
SubjectTrain <- tbl_df(read.table(file.path(filePath, "train", "subject_train.txt")))
SubjectTest  <- tbl_df(read.table(file.path(filePath, "test" , "subject_test.txt" )))
ActivityTrain <- tbl_df(read.table(file.path(filePath, "train", "Y_train.txt")))
ActivityTest  <- tbl_df(read.table(file.path(filePath, "test" , "Y_test.txt" )))
dataTrain <- tbl_df(read.table(file.path(filePath, "train", "X_train.txt" )))
dataTest  <- tbl_df(read.table(file.path(filePath, "test" , "X_test.txt" )))
dataFeatures <- tbl_df(read.table(file.path(filePath, "features.txt")))
activityLabels<- tbl_df(read.table(file.path(filePath, "activity_labels.txt")))

#merge the Training datasets and Test datasets using rbind
dataSub <- rbind(SubjectTrain, SubjectTest)
setnames(dataSub, "V1", "subject")
dataAct <- rbind(ActivityTrain, ActivityTest)
setnames(dataAct, "V1", "activityNum")

#combine the Data training and test files
dataTbl <- rbind(dataTrain, dataTest)

# name variables according to feature e.g.(V1 = "tBodyAcc-mean()-X")
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTbl) <- dataFeatures$featureName

#column names for activity labels
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

# Merge columns
dataSubAct <- cbind(dataSub, dataAct)
dataTbl <- cbind(dataSubAct, dataTbl)

#read "features.txt" and extract mean and standard deviation
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE)


##2. Extracts only the measurements on the mean and standard deviation for each measurement.
#take measurements for the mean and standard deviation and add "subject","activityNum"
dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
dataTbl <- subset(dataTbl, select = dataFeaturesMeanStd)


##3. Uses descriptive activity names to name the activities in the data set
#add name of activity into dataTbl
dataTbl <- merge(activityLabels, dataTbl , by="activityNum", all.x=TRUE)
dataTbl$activityName <- as.character(dataTbl$activityName)

#create dataTbl with variable means sorted by subject and Activity
dataTbl$activityName <- as.character(dataTbl$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTbl, mean) 
dataTbl<- tbl_df(arrange(dataAggr,subject,activityName))


##4. Appropriately labels the data set with descriptive variable names.
#give data meaningful variable names
names(dataTbl)<-gsub("std()", "SD", names(dataTbl))
names(dataTbl)<-gsub("mean()", "MEAN", names(dataTbl))
names(dataTbl)<-gsub("^t", "time", names(dataTbl))
names(dataTbl)<-gsub("^f", "frequency", names(dataTbl))
names(dataTbl)<-gsub("Acc", "Accelerometer", names(dataTbl))
names(dataTbl)<-gsub("Gyro", "Gyroscope", names(dataTbl))
names(dataTbl)<-gsub("Mag", "Magnitude", names(dataTbl))
names(dataTbl)<-gsub("BodyBody", "Body", names(dataTbl))


##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#tidy data table
write.table(dataTbl, "TidyData.txt", row.name=FALSE)