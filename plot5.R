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

## prepare the data    
SCC5<-SCC[(grep("[Mm]obile", SCC$EI.Sector)), ]
SCC5<-SCC5$SCC
NEI5<-NEI[(NEI$SCC %in% SCC5), ]

NEI5<-NEI5[(NEI5$fips=="24510"), ]

NEI5<-aggregate(NEI5$Emissions, by=list(NEI5$year), FUN=sum)
colnames(NEI5)<-c("year","Emissions")

## draw the plot
windows()

ggplot() +
    geom_point(data=NEI5, aes(x=year, y=Emissions)) +
    stat_smooth(data=NEI5, aes(x=year, y=Emissions), method="lm") +
    ggtitle("Emissions of PM2.5 from mobile sources\nin Baltimore City in years 1999-2008\n") +
    ylab("total emissions [tonnes]")
    
## save the plot
dev.copy(png, file="plot5.png")

## clean up
graphics.off()
setwd("..")