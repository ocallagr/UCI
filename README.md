## Class Project for "Getting and Cleaning Data"

The class project for [Getting and Cleaning Data](https://www.coursera.org/course/getdata) was to read in the ["Human Activity Recognition Using Smartphones" data set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), perform the instructed analysis on the UCI HAR data set, change the names of the activities in the data set to "descriptive activity names" and output a tidy data set.

**The following steps must be performed before running the R script:**

1. Download the zip file from [this URL](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
2. Unzip the file to the SAME DIRECTORY as the R script:
	* `features.txt`
	* `subject_train.txt`
	* `subject_test.txt`
	* `X_train.txt`
	* `X_test.txt`
	* `y_train.txt`
	* `y_test.txt`

**Once those steps are complete, you can run the R script ([run_analysis.R](run_analysis.R)).
** Note: the following libraries are loaded as part of the script: "dyplr","data.table" and "tidyr".
**The output of the R script is a tidy data set, [TidyData.txt](TidyData.txt).**

You can read more about the data and the analysis in the [code book](CodeBook.md).
