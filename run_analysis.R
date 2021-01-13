library(dplyr)

# Load data folder into the working directory folder
if(!file.exists("UCI HAR Dataset")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  filename <- tempfile()
  download.file(fileURL, filename, method="curl")
  unzip(filename)
  file.remove(filename)
}


# import data as dplyr database for easier handling
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("number","functions")) %>% tbl_df()
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity")) %>% tbl_df()
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject") %>% tbl_df()
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions) %>% tbl_df()
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code") %>% tbl_df()
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject") %>% tbl_df()
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions) %>% tbl_df()
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code") %>% tbl_df()

############################################################################
#
# --------------------------- Task 1 -----------------------------------------
#
############################################################################

# Row bind the different databases
x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)

# Merge all data bases into one
database <- cbind(x, y, subject) %>% tbl_df()

############################################################################
#
# --------------------------- Task 2 -----------------------------------------
#
############################################################################

# new database which contains only the measurements on the mean and standard 
# deviation for each measurement.
ndb <- select(database, subject, code, contains("mean"), contains("std"))

############################################################################
#
# --------------------------- Task 3 -----------------------------------------
#
############################################################################

# Left join ndb with activities to obtain activities vector with descriptive names
ndb_named <- left_join(ndb, activities, "code", keep = FALSE) %>% 
              select(-code) %>%
              relocate(activity, .after = subject)


############################################################################
#
# --------------------------- Task 4 -----------------------------------------
#
############################################################################


names(ndb_named)<-gsub("Acc", "Accelerometer", names(ndb_named))
names(ndb_named)<-gsub("Gyro", "Gyroscope", names(ndb_named))
names(ndb_named)<-gsub("BodyBody", "Body", names(ndb_named))
names(ndb_named)<-gsub("Mag", "Magnitude", names(ndb_named))
names(ndb_named)<-gsub("^t", "Time", names(ndb_named))
names(ndb_named)<-gsub("^f", "Frequency", names(ndb_named))
names(ndb_named)<-gsub("tBody", "TimeBody", names(ndb_named))
names(ndb_named)<-gsub("-mean()", "Mean", names(ndb_named), ignore.case = TRUE)
names(ndb_named)<-gsub("-std()", "STD", names(ndb_named), ignore.case = TRUE)
names(ndb_named)<-gsub("-freq()", "Frequency", names(ndb_named), ignore.case = TRUE)
names(ndb_named)<-gsub("angle", "Angle", names(ndb_named))
names(ndb_named)<-gsub("gravity", "Gravity", names(ndb_named))

############################################################################
#
# --------------------------- Task 5 -----------------------------------------
#
############################################################################

tidy_db <- group_by(ndb_named, subject, activity) %>% 
            summarise_all(funs(mean))

