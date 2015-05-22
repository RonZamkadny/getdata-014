if(!file.exists("data")){
  dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip")
unzip("./data/Dataset.zip", exdir = "./data")
UCI_HAR_Dataset <- list.dirs("./data", recursive = F)
setwd(UCI_HAR_Dataset)

features <- read.table('features.txt')
filteredFeatures <- features[grep("(mean|std)\\(", features[,2]),]

activity_labels <- read.table('activity_labels.txt')

X_test <- read.table('test/X_test.txt')
y_test <- read.table('test/y_test.txt')
subject_test <- read.table('test/subject_test.txt')
names(X_test) <- features$V2
bindedXY <- cbind(X_test, y_test)
joinedActivityLabesBindedXYTest <- join(bindedXY, activity_labels)

X_train <- read.table('train/X_train.txt')
y_train <- read.table('train/y_train.txt')
subject_train <- read.table('train/subject_train.txt')

names(X_train) <- features$V2
bindedXY <- cbind(X_train, y_train)
joinedActivityLabesBindedXYTrain <- join(bindedXY, activity_labels)

merged <- rbind(joinedActivityLabesBindedXYTest, joinedActivityLabesBindedXYTrain)
subject <- rbind(subject_test, subject_train)

activity_subject <- cbind(merged$V2, subject)

filtered <- cbind(merged[,filteredFeatures$V1], merged$V2)
result <- cbind(activity_subject, filtered)
averages <- aggregate(merged, by = list(Activity = result[,result$Activity], Subject = result[,result$Subject]), mean)
