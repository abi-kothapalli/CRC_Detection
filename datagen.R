rm(list=ls())
suppressPackageStartupMessages(library(curatedMetagenomicData))

dsets <- c("ZellerG_2014.metaphlan_bugs_list.stool", "YuJ_2015.metaphlan_bugs_list.stool", 
           "FengQ_2015.metaphlan_bugs_list.stool", "VogtmannE_2016.metaphlan_bugs_list.stool", 
           "HanniganGD_2018.metaphlan_bugs_list.stool", "ThomasAM_2018a.metaphlan_bugs_list.stool", 
           "ThomasAM_2018b.metaphlan_bugs_list.stool")
retr <- curatedMetagenomicData(dsets, dryrun = FALSE)
eset <- mergeData(retr)

meta <- pData(eset)
class <- meta$study_condition

exprData <- t(exprs(eset))
df <- as.data.frame(exprData)

df <- df[,grep("s__", colnames(df), fixed = TRUE)]

df <- cbind(df, class)
df <- df[complete.cases(df),]
df <- df[!df$class=="adenoma",]
  
write.csv(df, "dataset.csv", row.names = FALSE)

t1 = read.csv("abundance.csv")
t2 = read.csv("abundance_activeFeatures.csv")
t3 = read.csv("biomarkers.csv")
t4 = read.csv("dataset.csv")
t5 = read.csv("extra.csv")