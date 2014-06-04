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

## prepare the data

SCC6<-SCC[(grep("[Mm]obile", SCC$EI.Sector)), ]
SCC6<-SCC6$SCC
NEI6<-NEI[(NEI$SCC %in% SCC6), ]

NEI6<-NEI6[(NEI6$fips=="06037"|NEI6$fips=="24510"),]

NEI6<-aggregate(NEI6$Emissions, by=list(NEI6$year, NEI6$fips), FUN=sum)
colnames(NEI6)<-c("year", "place", "Emissions")
NEI6$place[NEI6$place=="06037"]<-c("Los Angeles County")
NEI6$place[NEI6$place=="24510"]<-c("Baltimore City")

NEI6$difference<-c(0, diff(NEI6$Emissions[NEI6$place=="Baltimore City"]),
                0, diff(NEI6$Emissions[NEI6$place=="Los Angeles County"]))

## draw the plot
windows()

ggplot() +
    geom_bar(data=NEI6, aes(x=year, y=difference, fill=place), stat="identity") +
    facet_wrap(~place) +
    ggtitle("Changes in total PM2.5 emissions from mobile sources\nin Baltimore City and in Los Angeles County 1999-2008\n") +
    ylab("change since the previous measurement [tonnes]")
    
## save the plot
dev.copy(png, file="plot6.png")

## clean up
graphics.off()
setwd("..")