## Download data and unzip

file.url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fp <- file.path(getwd(), "./airquality.zip")
download.file(file.url, fp)
unzip("./airquality.zip")

##  Upload data into R-Studio, subset (Baltimore), then calculate emission by year
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

bal <- subset(NEI, fips == "24510")
bal <- with(bal, aggregate(Emissions, by = list(year), FUN = sum))
names(bal) <- c("Year", "Sum")

## Plot barplot for the change
png(filename = "plot2.png", width = 480, height = 480, units = "px")
barplot(bal$Sum, names.arg = bal$Year, col = "blue", ylab = "Total Emission (ton)", 
        xlab = "Year", border = TRUE, ylim = c(0, max(bal$Sum+1000)), 
        main = "Baltimore PM2.5 Emission from 1999 to 2008")
box()
dev.off()
