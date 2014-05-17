# setup working directory 
setwd("C:\\Users\\srobin\\Documents\\R\\data\\GettingCleaning")

# Document date, file and zip file create
downloadDate <- date()
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
myZip <- "UCI HAR Dataset.zip"

#download Datasets zip file
download.file(file, destfile = myZip)

# load the utils library and unzip the downloaded file into getwd()
library(utils)
unzip(myZip)

# set directory and load the activity and features data
setwd("C:\\Users\\srobin\\Documents\\R\\data\\GettingCleaning\\UCI HAR Dataset")
act_desc <- read.table("activity_labels.txt")
features <- read.table("features.txt")

testdir <- "C:\\Users\\srobin\\Documents\\R\\data\\GettingCleaning\\UCI HAR Dataset\\test"
traindir <- "C:\\Users\\srobin\\Documents\\R\\data\\GettingCleaning\\UCI HAR Dataset\\train"

# dir and dataset parameters
processSets <- function(dir,dataset){

  # set working directory for the test dataset 
  # read the datasets into R (train or test)
  # process X_ data 
	# load X_data 
	# apply features names to the columns
	# Extract mean and std columns
	# add an ID column to each subset
	# merge the two subsets as dataX
  setwd(dir)
  dataX <- read.table(paste0("X_",dataset,".txt"))
  feaNames <- features[,2]
    names(dataX) <- feaNames
    testmean <- dataX[,grep("(?=.*mean*)",names(dataX),perl=T)]
    testmean$ID <- 1:nrow(testmean)
    teststd  <- dataX[,grep("(?=.*std*)",names(dataX),perl=T)]
    teststd$ID <- 1:nrow(teststd)
    dataX <- merge(testmean, teststd,by="ID")

  # load y_data and subject_data
  datay <- read.table(paste0("y_",dataset,".txt"))
  datasubject <- read.table(paste0("subject_",dataset,".txt"))
  
  # add keyID as a row index for each data file
  dataX$keyID <- 1:nrow(dataX)
  datay$keyID <- 1:nrow(datay)
  datasubject$keyID <- 1:nrow(datasubject)

  # change the names activity and subject
  names(datay) [1] <- "activity"
  names(datasubject) [1] <- "subject"
  
  # load library to use arrange
  library(plyr)
  # join train datasets by keyID
  data_y_subject <- arrange(join(datay,datasubject),keyID)
  output <- arrange(join(dataX,data_y_subject), keyID)
      
  return(output)
}

# get test and train datasets
test <- processSets(testdir,'test')
train <- processSets(traindir,'train')

# merge test and train data - more like, append train to test
# basically, stacking one on top of the other
mergeData = rbind(test,train)

# Use descriptive activity names
# quick and dirty :(
mergeData$activity[mergeData$activity == 1] <- "WALKING"
mergeData$activity[mergeData$activity == 2] <- "WALKING_UPSTAIRS"
mergeData$activity[mergeData$activity == 3] <- "WALKING_DOWNSTAIRS"
mergeData$activity[mergeData$activity == 4] <- "SITTING"
mergeData$activity[mergeData$activity == 5] <- "STANDING"
mergeData$activity[mergeData$activity == 6] <- "LAYING"


# remove ID columns
mergeData$ID <- NULL
mergeData$keyID <- NULL

# Create second, independent tidy dataset with the average 
# of each variable for each activity and each subject
# label dataset with descriptive activity names

# melt dataset using last two columns (subject, activity) as id.vars
meltdata <- melt(mergeData, id=80:81)
# cast the meltdata using subjec and activity to group on
# apply average (mean) to all variable.
tidy <- dcast(meltdata, subject + activity ~ variable, mean)
names(myCast)[3:81] <- paste0("avg-",names(myCast)[3:81])


