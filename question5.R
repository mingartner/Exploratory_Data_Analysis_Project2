## Download data and unzip

file.url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fp <- file.path(getwd(), "./airquality.zip")
download.file(file.url, fp)
unzip("./airquality.zip")

##  Upload data into R-Studio, subset, then calculate emission
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

SCC2 <- SCC[grep("[Vv]ehicle", SCC$EI.Sector), 1:2]
pm25veh <- merge(NEI[NEI$fips=="24510",], SCC2)         ## Subset by Baltimore and Vehicle SCC number
pm25veh <- with(pm25veh, aggregate(Emissions, by = list(year), sum))
pm25veh$Change <- pm25veh$x/pm25veh$x[[1]]
names(pm25veh) <- c("Year", "Emissions", "Change")
pm25veh$Year <- factor(pm25veh$Year)

## Plot barplot for the change
library(ggplot2)
png(filename = "plot5.png", width = 480, height = 480, units = "px")

ggplot(pm25veh, aes(x = Year, y = Emissions, label=paste0(as.character(Year), "-", round(
        Change*100,1), "%"))) + geom_bar(stat = "identity", width = 0.6, fill = "green") + xlab(
        "Year")+labs(title=" Emissions Change from Motor Vehicle at Baltimore")+ylab(
                "Emissions (tons)")+geom_text(y = pm25veh$Emissions+10, size = 4)


dev.off()

