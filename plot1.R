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

## prepare the data set
NEI1<-aggregate(NEI$Emissions, by=list(NEI$year), FUN=sum)
colnames(NEI1)<-c("year", "emission")

## make the plot
windows()

plot(NEI1$year, NEI1$emission, xlab="year", ylab="total emissions [tonnes]", pch=16)
reg<-lm(NEI1$emission~NEI1$year)
abline(reg, col="red")
legend("topright", legend=paste("R^2=",format(summary(reg)$adj.r.squared, digits=2)))
title("Total emissions of PM2.5 in the US\nin 1999-2008\n")

## save the plot
dev.copy(png, file="plot1.png")

## clean up
graphics.off()
setwd("..")