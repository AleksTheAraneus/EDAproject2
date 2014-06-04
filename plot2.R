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

## prepare the data set
NEI2<-NEI[(NEI$fips=="24510"), ]
NEI2<-aggregate(NEI2$Emissions, by=list(NEI2$year), FUN=sum)
colnames(NEI2)<-c("year", "emission")

## make the plot
windows()

plot(NEI2$year, NEI2$emission, xlab="year", ylab="total emissions [tonnes]", pch=16)
reg<-lm(NEI2$emission~NEI2$year)
abline(reg, col="red")
legend("topright", legend=paste("R^2=",format(summary(reg)$adj.r.squared, digits=2)))
title("Total emissions of PM2.5 in Baltimore City\nin 1999-2008\n")

## save the plot
dev.copy(png, file="plot2.png")

## clean up
graphics.off()
setwd("..")