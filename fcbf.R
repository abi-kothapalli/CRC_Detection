rm(list=ls())
library(FCBF)
library(tibble)
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
target <- df[,"class"]

discrete_expression <- discretize_exprs(t(df[,-1613]))

export <- as.data.frame(t(discrete_expression))
export <- add_column(export, target, .before = 1)

write.csv(export, "discretize.csv", row.names = FALSE)

su_plot(discrete_expression,target)
fcbf_features <- fcbf(discrete_expression, target, thresh = 0.005, verbose = TRUE)
mini <- t(df)[fcbf_features$index,]

rfe_features <- read.csv("rfe_features_indices.csv", header = FALSE)+1
mifs_features <- read.csv("mifs_features_indices.csv", header = FALSE)+1

View(intersect(rfe_features[[1]], mifs_features[[1]]))

View(fcbf_features$index)


feature_indices <- union(rfe_features[[1]], mifs_features[[1]])
feature_indices <- union(feature_indices, fcbf_features$index)
View(feature_indices)

biomarkers <- df[,feature_indices]
biomarkers <- cbind(biomarkers, target)

write.csv(biomarkers, "biomarkers.csv", row.names = FALSE)
