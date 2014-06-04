## download the data (required for all plot scripts)
if (! file.exists("project2")) {
    dir.create("project2")
}
setwd("./project2")

if (! (file.exists("Source_Classification_Code.rds") & file.exists("summarySCC_PM25.rds"))) {
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

## prepare the data set
SCC4<-SCC[(grep("[Cc]oal", SCC$EI.Sector)),]
SCC4<-SCC4$SCC

NEI4<-NEI[(NEI$SCC %in% SCC4),]
NEI4<-aggregate(NEI4$Emissions, by=list(NEI4$year), FUN=sum)
colnames(NEI4)<-c("year", "Emissions")

## draw the plot
windows()

ggplot() +
    geom_point(data=NEI4, aes(x=year, y=Emissions)) +
    stat_smooth(data=NEI4, aes(x=year, y=Emissions), method="lm") +
    ggtitle("Emissions of PM2.5 from coal combustion-related\nsources in the US in 1999-2008\n") +
    ylab("total emissions [tonnes]")


## save the plot
dev.copy(png, file="plot4.png")

## clean up
graphics.off()
setwd("..")