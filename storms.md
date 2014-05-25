Reproducible Research - Exploring the NOAA Storm Database
=========================================================

by Vajo Lukic

Synopsis
---------------

The goal of this analysis is to explore the NOAA Storm Database and answer some basic questions about severe weather events. This database tracks features of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage. The events in the database start in the year 1950 and end in November 2011. 

In this analysis we are going to answer following questions:
- Across the United States, which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health?
- Across the United States, which types of events have the greatest economic consequences?


Data Processing
---------------

The data for this assignment come in the form of a comma-separated-value file compressed via the bzip2 algorithm to reduce its size. File can be downloaded from this link: [NOAA Storm Data Set] (https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2) 

There is also some documentation explaining database in detail:

- National Weather Service [Storm data documentation] (https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf)
- National Climatic Data Center Storm Events [FAQ] (https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf)

Here are the steps we have performed to process the data:

- Set up or create a working directory

```r
setwd("c:\\")
if (!file.exists("tmp")) {
    dir.create("tmp")
}
setwd("c:\\tmp")
```


- Set URL for download and download the file

```r
fileUrl <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
download.file(fileUrl, "repdata-data-StormData.csv.bz2")
```


- Document when the files have been downloaded

```r
dateDownloaded <- date()
dateDownloaded
```

```
## [1] "Sun May 25 12:32:30 2014"
```


- Load the data into table

```r
stormData <- read.table("repdata-data-StormData.csv.bz2", header = TRUE, sep = ",", 
    fill = TRUE)
```


- Display the structure of the data set

```r
str(stormData)
```

```
## 'data.frame':	902297 obs. of  37 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : Factor w/ 16335 levels "1/1/1966 0:00:00",..: 6523 6523 4242 11116 2224 2224 2260 383 3980 3980 ...
##  $ BGN_TIME  : Factor w/ 3608 levels "00:00:00 AM",..: 272 287 2705 1683 2584 3186 242 1683 3186 3186 ...
##  $ TIME_ZONE : Factor w/ 22 levels "ADT","AKS","AST",..: 7 7 7 7 7 7 7 7 7 7 ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: Factor w/ 29601 levels "","5NM E OF MACKINAC BRIDGE TO PRESQUE ISLE LT MI",..: 13513 1873 4598 10592 4372 10094 1973 23873 24418 4598 ...
##  $ STATE     : Factor w/ 72 levels "AK","AL","AM",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ EVTYPE    : Factor w/ 985 levels "   HIGH SURF ADVISORY",..: 834 834 834 834 834 834 834 834 834 834 ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : Factor w/ 35 levels "","  N"," NW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_LOCATI: Factor w/ 54429 levels "","- 1 N Albion",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_DATE  : Factor w/ 6663 levels "","1/1/1993 0:00:00",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_TIME  : Factor w/ 3647 levels ""," 0900CST",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : Factor w/ 24 levels "","E","ENE","ESE",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ END_LOCATI: Factor w/ 34506 levels "","- .5 NNW",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: Factor w/ 19 levels "","-","?","+",..: 17 17 17 17 17 17 17 17 17 17 ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: Factor w/ 9 levels "","?","0","2",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ WFO       : Factor w/ 542 levels ""," CI","$AC",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ STATEOFFIC: Factor w/ 250 levels "","ALABAMA, Central",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ ZONENAMES : Factor w/ 25112 levels "","                                                                                                                               "| __truncated__,..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : Factor w/ 436781 levels "","-2 at Deer Park\n",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10 ...
```


- Display number of rows and columns in the data set

```r
dim(stormData)
```

```
## [1] 902297     37
```


- Create subset of data for fatalities only

```r
fsum <- aggregate(stormData$FATALITIES, by = list(stormData$EVTYPE), FUN = sum)
```


- Ad names to columns of fatalities subset

```r
names(fsum) <- c("fname", "fnumber")
```


- Order fatalities subset decreasingly

```r
fsum <- fsum[order(fsum$fnumber, decreasing = TRUE), ]
```


- Create subset of data for injuries only

```r
isum <- aggregate(stormData$INJURIES, by = list(stormData$EVTYPE), FUN = sum)
```


- Ad names to columns of injuries subset

```r
names(isum) <- c("iname", "inumber")
```


- Order injuries subset decreasingly

```r
isum <- isum[order(isum$inumber, decreasing = TRUE), ]
```



This completes data processing for getting answers about most harmful types of events.

To further analyze the economic impact of those events on crops and property, we need to analyze data in these columns:
- PROPDMGEXP: magnitude of the number value of property damage 
- CROPDMGEXP: magnitude of the number value of crop damage 

- Analyze data in PROPDMGEXP column

```r
unique(stormData$PROPDMGEXP)
```

```
##  [1] K M   B m + 0 5 6 ? 4 2 3 h 7 H - 1 8
## Levels:  - ? + 0 1 2 3 4 5 6 7 8 B h H K m M
```


- Analyze data in CROPDMGEXP column

```r
unique(stormData$CROPDMGEXP)
```

```
## [1]   M K m B ? 0 k 2
## Levels:  ? 0 2 B k K m M
```


We can see that there is a lot of different values in these two columns, and ot all of this data is correct. Document "National Weather Service Storm Data Documentation", page 12. states: 

"Estimates should be rounded to three significant digits, followed by an alphabetical character signifying the magnitude of the number, i.e., 1.55B for $1,550,000,000. Alphabetical characters used to signify magnitude include "K" for thousands, "M" for millions, and "B" for billions."

For this reason we are going to use only those records which have one of these values in these fields: "", m", "k", "b", "M", "K", "B"
- ""      : hundrets
- "k", "K": thousands
- "m", "M": milions
- "b", "B": bilions

- Subset main data set to calculate only crop damage value

```r
stormData$CROPDMGEXP2 <- as.character(stormData$CROPDMGEXP)
cropData <- stormData[stormData$CROPDMGEXP2 %in% c("", "k", "K", "m", "M", "b", 
    "B"), ]
```


- Create new column DAMAGEVALUE and calculate it by multipying damage value by magnitude

```r
cropData$DAMAGEVALUE <- NA
cropData$DAMAGEVALUE <- ifelse(cropData$CROPDMGEXP2 == "K" | cropData$CROPDMGEXP2 == 
    "k", cropData$CROPDMG * 1000, cropData$DAMAGEVALUE)
cropData$DAMAGEVALUE <- ifelse(cropData$CROPDMGEXP2 == "M" | cropData$CROPDMGEXP2 == 
    "m", cropData$CROPDMG * 1e+06, cropData$DAMAGEVALUE)
cropData$DAMAGEVALUE <- ifelse(cropData$CROPDMGEXP2 == "B" | cropData$CROPDMGEXP2 == 
    "b", cropData$CROPDMG * 1e+09, cropData$DAMAGEVALUE)
cropData$DAMAGEVALUE <- ifelse(cropData$CROPDMGEXP2 == "", 0, cropData$DAMAGEVALUE)
```


- Order "crop" data set by damage value descending

```r
cropData <- cropData[order(cropData$DAMAGEVALUE, decreasing = TRUE), ]
```


- Summarize "crop" damage value per event and order this set by damage value descending

```r
csum <- aggregate(cropData$DAMAGEVALUE, by = list(cropData$EVTYPE), FUN = sum)
names(csum) <- c("cname", "cnumber")
csum <- csum[order(csum$cnumber, decreasing = TRUE), ]
```


- Subset main data set to calculate property damage value

```r
stormData$PROPDMGEXP2 <- as.character(stormData$PROPDMGEXP)
propData <- stormData[stormData$PROPDMGEXP %in% c("", "k", "K", "m", "M", "b", 
    "B"), ]
```



```r
propData$DAMAGEVALUE <- NA
propData$DAMAGEVALUE <- ifelse(propData$PROPDMGEXP2 == "K" | propData$PROPDMGEXP2 == 
    "k", propData$PROPDMG * 1000, propData$DAMAGEVALUE)
propData$DAMAGEVALUE <- ifelse(propData$PROPDMGEXP2 == "M" | propData$PROPDMGEXP2 == 
    "m", propData$PROPDMG * 1e+06, propData$DAMAGEVALUE)
propData$DAMAGEVALUE <- ifelse(propData$PROPDMGEXP2 == "B" | propData$PROPDMGEXP2 == 
    "b", propData$PROPDMG * 1e+09, propData$DAMAGEVALUE)
propData$DAMAGEVALUE <- ifelse(propData$PROPDMGEXP2 == "", 0, propData$DAMAGEVALUE)
```


- Order "property" data set by damage value descending

```r
propData <- propData[order(propData$DAMAGEVALUE, decreasing = TRUE), ]
```


- Summarize "property" damage value per event and order this set by damage value descending

```r
psum <- aggregate(propData$DAMAGEVALUE, by = list(propData$EVTYPE), FUN = sum)
names(psum) <- c("pname", "pnumber")
psum <- psum[order(psum$pnumber, decreasing = TRUE), ]
```




Results
---------------

Most harmful events (injuries and fatalities )
-----------------------------------------------------------------

- Plot the data for injuries showing top 10 events causing injuries

```r
barplot(height = isum[1:10, "inumber"], names.arg = isum[1:10, "iname"], las = 2, 
    cex.axis = 0.7, cex.names = 0.7, main = "Top 10 Events Causing Injuries", 
    ylab = "Number Of Injuries")
```

![plot of chunk unnamed-chunk-23](figure/unnamed-chunk-23.png) 


- Plot the data for fatalities showing top 10 events causing fatalities

```r
barplot(height = fsum[1:10, "fnumber"], names.arg = fsum[1:10, "fname"], las = 2, 
    cex.axis = 0.7, cex.names = 0.7, main = "Top 10 Events Causing Fatalities", 
    ylab = "Number Of Fatalities")
```

![plot of chunk unnamed-chunk-24](figure/unnamed-chunk-24.png) 



Events with greates economic impact (crops and propery damage value)
--------------------------------------------------------------------

IMPORTANT! This is a multi panel window with two plots 

- Use "par" function to set a matrix of two plots

```r
par(mfrow = c(1, 2))
par(oma = c(4, 2, 2, 2))
barplot(height = csum[1:10, "cnumber"], names.arg = csum[1:10, "cname"], las = 2, 
    cex.axis = 0.7, cex.main = 0.8, cex.names = 0.7, main = "Top 10 Crop Damage Events", 
    ylab = "Damage amount in US dollars")
barplot(height = psum[1:10, "pnumber"], names.arg = psum[1:10, "pname"], las = 2, 
    cex.axis = 0.7, cex.main = 0.8, cex.names = 0.7, main = "Top 10 Property Damage Events", 
    ylab = "Damage amount in US dollars")
```

![plot of chunk unnamed-chunk-25](figure/unnamed-chunk-25.png) 


