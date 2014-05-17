Cookbook - Explanation of process
==================================

Variables:
-------------
Initial working directory: "C:\\Users\\srobin\\Documents\\R\\data\\GettingCleaning"
downloadDate = date()
file = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
myZip = "UCI HAR Dataset.zip"

Since both test and train have the same data structure, a function was developed to process both datasets in a similar method.  A variable was created for each directory. 

	**processSets(dir,dataset)**
		*dir:  set the directory to the appropriate location
		*dataset:  'test' or 'train'
	
	1. processSets() reads X_data.txt, y_data.txt and subject_data.txt files from the appropriate directory. nrow() was used to create an index ID for all tables.  features.txt was used to name the X_data.txt columns, then all columns containing 'mean' and 'std' were extracted in a two part process that required rejoining mean and std data with an ID index.  Only mean and std observations were used in this analysis.

	2. X_data, y_data and subject_data were joined with the common ID.

	3. Column 1 of y_data was renamed 'activity' and subject_data was renamed 'subject'.  These data were joined to the X_data through the ID column. 

	4. test and train datasets were created from the processSets().

An ID column was added to test and train datasets, creating an index that would be used to join each table.  

ID columns were dropped after the merge.

activity_labels.txt was used in a series of conditional statements to translate activity numbers to descriptive information denoting the activity the subject was engaged in when the observations were recorded.  These included WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

Final dataset was melted using 'subject' and 'activity' as the grouping.  This dataset was then cast to apply the mean function to all observations.  The result was 180 rows grouped by subject and activity and all variables averaged.  All variable columns were renamed utilizing the original feature names and a prefix of 'avg-'. 

