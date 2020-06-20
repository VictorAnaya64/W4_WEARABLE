library(reshape2)
library(dplyr)

## Load all data files
Train_X<-read.table(file="UCI HAR Dataset/train/X_train.txt")
Train_Y<-read.table(file="UCI HAR Dataset/train/y_train.txt")
Train_Subject<-read.table(file="UCI HAR Dataset/train/subject_train.txt")
Test_X<-read.table(file="UCI HAR Dataset/test/X_test.txt")
Test_Y<-read.table(file="UCI HAR Dataset/test/y_test.txt")
Test_Subject<-read.table(file="UCI HAR Dataset/test/subject_test.txt")

Feat<-read.table(file="UCI HAR Dataset/features.txt")

## Name columns of both DataSets 
## (please note this is step 4 of the assignment)
## (We keep descriptive variable names from the begining)
names(Train_X)<-Feat[,2]
names(Test_X)<-Feat[,2]

## Add activity column
Train_X$act.labels<-Train_Y[,1]
Test_X$act.labels<-Test_Y[,1]

## Add subject column
Train_X$subject<-Train_Subject[,1]
Test_X$subject<-Test_Subject[,1]


## Add a coolumn with the origin input source 
Train_X$input.label<-rep("Train",length(Train_Y[,1]))
Test_X$input.label<-rep("Test",length(Test_Y[,1]))


## Merge training and the test sets to create one data set
## This is step 1 of the assignment
Both_DSs<-rbind(Train_X,Test_X)

## Select only colums that contains means and std
Vect_means<-grep("*mean*", names(Both_DSs))
Vect_SD<-grep("*std*", names(Both_DSs))
Select_Cols<-c(Vect_means,Vect_SD,562,563,564)

##Subset only columns with means and std
## This is step 2 of assignment
Both_DSs<-Both_DSs[,Select_Cols]

## Assign descriptive labels to the activity columns
## This is step 3 of the assignment
Both_DSs$act.labels <- factor(Both_DSs$act.labels,
                              levels = c(1,2,3,4,5,6),
                              labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
                                         "SITTING","STANDING","LAYING")) 

#In order to compute easily the averages, we will build a "skin dataset"
Skiny_DS<-melt(Both_DSs,id=c("act.labels","input.label","subject"), 
               measure.vars=names(Both_DSs)[1:79])

#Gruping dataset by activity, subject and variable
Skiny_DS<- group_by(Skiny_DS,act.labels,subject,variable)

#We can get the mean value for each subject and activity,
#based on the groups defined in the dataset
Step5_DS<-summarise(Skiny_DS,mean(value))

