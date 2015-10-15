library(dplyr)
# read the features and activity labels
setwd("/Users/rpazhyan/machine learning /ML Course/Getting-and-Cleaning-Data/Project/")
featureTable = read.table("./UCI HAR Dataset/features.txt")
activityLabelTable = read.table("./UCI HAR Dataset/activity_labels.txt")

# read test data
# 1 read the sensor variables

dfTest = read.table("./UCI HAR Dataset/test/X_test.txt")

# 2 read the subject data 

s1 = read.table("./UCI HAR Dataset/test/subject_test.txt")


#3 read the activity data

a1 = read.table("./UCI HAR Dataset/test/y_test.txt")
activityList = sapply(a1[,1],function(x) activityLabelTable[x,2])

# add activity and subject to the table
dfTest['subjectId']=s1[,1]
dfTest['activity']=sapply(a1[,1],function(x) activityLabelTable[x,2])

# Now do the same for training set

dfTraining = read.table("./UCI HAR Dataset/train/X_train.txt")

# 2 read the subject data 

s2 = read.table("./UCI HAR Dataset/train/subject_train.txt")
subjectList = s2[,1]

#3 read the activity data

a2 = read.table("./UCI HAR Dataset/train/y_train.txt")

# add activity and subject to the table
dfTraining['subjectId']=s2[,1]
dfTraining['activity']=sapply(a2[,1],function(x) activityLabelTable[x,2])

# Merged data set 

dfTotal = merge(dfTraining,dfTest,all=TRUE) # TRUE should add test data rows to be added.

# label the columns
colnames(dfTotal)=append(as.character(featureTable[,2]),c("subjectId","activity"))

# create new smaller data set 
dfTotalSmall = dfTotal[,grep("mean\\()|std\\()|activity|subjectId",names(dfTotal))]

# summary statistics 
dfTidyData = dfTotalSmall %>% group_by(subjectId,activity)%>% summarise_each(funs(mean))

#write 
write.table(dfTidyData,"./tidy-data.txt",row.name=FALSE)

