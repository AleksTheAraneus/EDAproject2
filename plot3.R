## download the data (required for all plot scripts)
if (! file.exists("project2")) {
    dir.create("project2")
}
setwd("./project2")

if (! file.exists("Source_Classification_Code.rds") & file.exists("summarySCC_PM25.rds")) {
    url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url, "fnei.zip")
    library(utils)
    unzip("fnei.zip")
}

## read the data in (required for all plot scripts)
if (! exists("NEI")) {
    NEI <- readRDS("summarySCC_PM25.rds")
}

if (! exists("SCC")) {
    SCC <- readRDS("Source_Classification_Code.rds")
}

## load libraries
library(ggplot2)

## create data set with variables to plot
NEI3<-NEI[(NEI$fips=="24510"), ]
NEI3<-aggregate(NEI3$Emissions, by=list(NEI3$year, NEI3$type), FUN=sum)
colnames(NEI3)<-c("year", "type", "emissions")

## draw the plot
windows()

qplot(year, emissions, data=NEI3, color=type, geom=c("point", "smooth"),
      method="lm", ylab="total emissions [tonnes]",
      main="Changes in total emissions of PM2.5\nin Baltimore City in 1999-2008 by source\n") 

## save the plot
dev.copy(png, file="plot3.png")

## clean up
graphics.off()
setwd("..")