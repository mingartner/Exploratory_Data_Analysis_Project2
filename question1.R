## Download data file

file.url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fp <- file.path(getwd(), "./airquality.zip")
download.file(file.url, fp)
unzip("./airquality.zip")

##  Upload data into R-Studio and calculate total emission based on year
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

total <- with(NEI, aggregate(Emissions, by = list(year), FUN = sum))
names(total) <- c("Year", "Sum")

## Using barplot function to plot the total emission change over the year
png(filename = "plot1.png", width = 480, height = 480, units = "px")
barplot(total$Sum/10^6, names.arg = total$Year, col = "green", ylab = "Total Emission (million ton)", 
        xlab = "Year", border = TRUE, ylim = c(0, max(total$Sum/10^6)+1), 
        main = "Total PM2.5 Emission from 1999 to 2008")
box()
dev.off()