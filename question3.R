## Download data and unzip

file.url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fp <- file.path(getwd(), "./airquality.zip")
download.file(file.url, fp)
unzip("./airquality.zip")

##  Upload data into R-Studio, subset by Baltimore, then calculate emission sum by type
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(reshape); library(reshape2);

bal <- subset(NEI, fips == "24510")
bal <- bal[, 4:6]
ballong <- melt(bal, id=c("type", "year"))
balResult <- dcast(ballong, type+year~variable, sum)

## Plot barplot for the change
library(ggplot2)
png(filename = "plot3.png", width = 480, height = 480, units = "px")

g <- ggplot(balResult, aes(x = year, y = Emissions, color = type))

g+geom_point()+facet_grid(type~.)+geom_smooth(method = "lm", se=FALSE
        )+xlab("Year")+ylab("Total Emissions (tons)")+ggtitle("Baltimore Emission Change by Types")

dev.off()
