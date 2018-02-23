## Download data and unzip

file.url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fp <- file.path(getwd(), "./airquality.zip")
download.file(file.url, fp)
unzip("./airquality.zip")

##  Upload data into R-Studio, subset, then calculate emission
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(reshape); library(reshape2);

SCC_coal <- SCC[unique(c(grep("[Cc]oal", SCC$Short.Name),grep("[Cc]oal", SCC$EI.Sector))), 1:2] ## Finding SCC number for Coal
coal <- merge(NEI, SCC_coal)
coal <- with(coal, aggregate(Emissions, by = list(year), sum))
coal$change <- coal$x/coal$x[[1]]
names(coal) <- c("Year", "Emissions", "changes")
coal$Year <- factor(coal$Year)

## Plot barplot for the change
library(ggplot2)
png(filename = "plot4.png", width = 480, height = 480, units = "px")

ggplot(coal, aes(x = Year, y = Emissions, label=paste0(round(changes*100,1), "%"))) + geom_bar(
        stat = "identity", width = 0.75, fill = "blue") + xlab("Year")+labs(
        title="US PM2.5 Emissions from Coal Combustions")+ylab("Emissions (tons)")+geom_text(
        y = coal$Emissions+20000, size = 5)


dev.off()

