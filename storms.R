## Set working directory
setwd("c:\\")
if (!file.exists("tmp")) {
  dir.create("tmp")
}
setwd("c:\\tmp")

## Set URL for download
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"

## Download the archive file
download.file(fileUrl, "repdata-data-StormData.csv.bz2")

## Document when the files have been downloaded
dateDownloaded <- date()
dateDownloaded

## Load the data into table
stormData <- read.table("repdata-data-StormData.csv.bz2", header = TRUE, sep = ",", fill = TRUE)

## Show the structure of the data set
str(stormData)

## Show number of rows and columns
dim(stormData)

## Create subset of data for fatalities only
fsum <- aggregate(stormData$FATALITIES, by = list(stormData$EVTYPE), FUN = sum)

## Ad names to columns of fatalities subset
names(fsum) <- c("fname","fnumber")

## Order fatalities subset decreasingly
fsum <- fsum[order(fsum$fnumber, decreasing=TRUE), ]

## Create subset of data for injuries only
isum <- aggregate(stormData$INJURIES, by = list(stormData$EVTYPE), FUN = sum)

## Ad names to columns of injuries subset
names(isum) <- c("iname","inumber")

## Order injuries subset decreasingly
isum <- isum[order(isum$inumber, decreasing=TRUE), ]

## Plot the data for injuries
barplot(height = isum[1:10, "inumber"], names.arg = isum[1:10, "iname"], las = 2, cex.axis = 0.7, 
        cex.names = 0.7, main = "Top 10 Events Causing Injuries", ylab = "Number Of Injuries")

## Plot the data for fatalities
barplot(height = fsum[1:10, "fnumber"], names.arg = fsum[1:10, "fname"], las = 2, cex.axis = 0.7, 
        cex.names = 0.7, main = "Top 10 Events Causing Fatalities", ylab = "Number Of Fatalities")

## Analyze data in PROPDMGEXP column
unique(stormData$PROPDMGEXP)

## Analyze data in CROPDMGEXP column
unique(stormData$CROPDMGEXP)

## Subset main data set to calculate only crop damage value
stormData$CROPDMGEXP2 <- as.character(stormData$CROPDMGEXP)
cropData <- stormData[stormData$CROPDMGEXP2 %in% c("","k","K","m", "M","b","B"), ]

cropData$DAMAGEVALUE <- NA
cropData$DAMAGEVALUE <- ifelse(cropData$CROPDMGEXP2 == "K" | cropData$CROPDMGEXP2 == "k", cropData$CROPDMG * 1000, cropData$DAMAGEVALUE)
cropData$DAMAGEVALUE <- ifelse(cropData$CROPDMGEXP2 == "M" | cropData$CROPDMGEXP2 == "m", cropData$CROPDMG * 1e+06, cropData$DAMAGEVALUE)
cropData$DAMAGEVALUE <- ifelse(cropData$CROPDMGEXP2 == "B" | cropData$CROPDMGEXP2 == "b", cropData$CROPDMG * 1e+09, cropData$DAMAGEVALUE)
cropData$DAMAGEVALUE <- ifelse(cropData$CROPDMGEXP2 == "", 0, cropData$DAMAGEVALUE)

## Summarize "crop" damage value per event and order this set by damage value descending
cropData <- cropData[order(cropData$DAMAGEVALUE, decreasing=TRUE), ] 
csum <- aggregate(cropData$DAMAGEVALUE, by = list(cropData$EVTYPE), FUN = sum)
names(csum) <- c("cname","cnumber")
csum <- csum[order(csum$cnumber, decreasing=TRUE), ]

## Subset main data set to calculate property damage value
stormData$PROPDMGEXP2 <- as.character(stormData$PROPDMGEXP)
propData <- stormData[stormData$PROPDMGEXP %in% c("","k","K","m", "M","b","B"), ]

propData$DAMAGEVALUE <- NA
propData$DAMAGEVALUE <- ifelse(propData$PROPDMGEXP2 == "K" | propData$PROPDMGEXP2 == "k", propData$PROPDMG * 1000, propData$DAMAGEVALUE)
propData$DAMAGEVALUE <- ifelse(propData$PROPDMGEXP2 == "M" | propData$PROPDMGEXP2 == "m", propData$PROPDMG * 1e+06, propData$DAMAGEVALUE)
propData$DAMAGEVALUE <- ifelse(propData$PROPDMGEXP2 == "B" | propData$PROPDMGEXP2 == "b", propData$PROPDMG * 1e+09, propData$DAMAGEVALUE)
propData$DAMAGEVALUE <- ifelse(propData$PROPDMGEXP2 == "", 0, propData$DAMAGEVALUE)

## Summarize "property" damage value per event and order this set by damage value descending
propData <- propData[order(propData$DAMAGEVALUE, decreasing=TRUE), ] 
psum <- aggregate(propData$DAMAGEVALUE, by = list(propData$EVTYPE), FUN = sum)
names(psum) <- c("pname","pnumber")
psum <- psum[order(psum$pnumber, decreasing=TRUE), ]

## Use "par" function to set a matrix of two plots
par(mfrow = c(1, 2))
par(oma = c(4, 2, 2, 2))

## Draw a multi panel window with two plots 
barplot(height = csum[1:10, "cnumber"], names.arg = csum[1:10, "cname"], las = 2, cex.axis = 0.7, cex.main = 0.8, 
        cex.names = 0.7, main = "Top 10 Events Causing Crop Damage", ylab = "Damage amount in US dollars")

barplot(height = psum[1:10, "pnumber"], names.arg = psum[1:10, "pname"], las = 2, cex.axis = 0.7, cex.main = 0.8,
        cex.names = 0.7, main = "Top 10 Events Causing Property Damage", ylab = "Damage amount in US dollars")
