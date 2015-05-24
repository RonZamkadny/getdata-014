# function to read data from txt and join essential columns; requires library(plyr)
readAndJoin <- function(parentDirectory, features, activity_labels){
  X_test <- read.table(paste(parentDirectory,'/X_', parentDirectory, '.txt', sep = ""))
  y_test <- read.table(paste(parentDirectory,'/y_', parentDirectory, '.txt', sep = ""))
  subject <- read.table(paste(parentDirectory,'/subject_', parentDirectory, '.txt', sep = ""))
  names(X_test) <- features$V2
  bindedXY <- cbind(X_test, y_test)
  joined <- join(bindedXY, activity_labels)
  bindedDataset <<- rbind(joined, bindedDataset)
  bindedSubject <<- rbind(subject, bindedSubject)
}

library(plyr)
# create working directory, download data zip there, unzip data and set working directory
if(!file.exists("data")){
  dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")
unzip("./data/Dataset.zip", exdir = "./data")
UCI_HAR_Dataset <- list.dirs("./data", recursive = F)
setwd(UCI_HAR_Dataset)

# filter features-column according to the task (mean&std variables)
features <- read.table('features.txt')
filteredFeatures <- features[grep("(mean|std)\\(", features[,2]),]
activity_labels <- read.table('activity_labels.txt')
# this dataset will contains result
bindedDataset <- data.frame()
bindedSubject <- data.frame()
# perform joins with procedure (see above)
readAndJoin('test', features, activity_labels)
readAndJoin('train', features, activity_labels)
# bind subject/activity columns
activity_subject <- cbind(bindedDataset$V2, bindedSubject)
colnames(activity_subject) <- c("Activity", "Subject")
# result for task 1-4 
result <- cbind(activity_subject, bindedDataset)
# averages for task 5
averages <- aggregate(bindedDataset, by = list(Activity = activity_subject$Activity,Subject = activity_subject$Subject), mean)
write.table(averages, file = 'averages.txt', row.names = F)