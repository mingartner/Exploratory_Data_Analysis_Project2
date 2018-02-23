## Download data and unzip

file.url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fp <- file.path(getwd(), "./airquality.zip")
download.file(file.url, fp)
unzip("./airquality.zip")

##  Upload data into R-Studio, subset with Baltimore, LA, and Vehicle
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
SCC2 <- SCC[grep("[Vv]ehicle", SCC$EI.Sector), 1:2]  ## Find SCC number for on-road Moto Vehicle categories

df <- merge(NEI[NEI$fips%in%c("24510", "06037"), ], SCC2)
df <- df[, c(2, 4, 6)]

## Reshape the data set to find the comparison of the two cities
library(tidyr)
df_long <- melt(df, id=c("fips", "year"))
df1 <- dcast(df_long, fips+year~variable, sum)

library(dplyr)
df_result <- df1 %>% group_by(fips) %>% mutate(ch = Emissions/Emissions[[1]]) ## Adding a column of %change over the year
df_result$city <- ifelse(df_result$fips=="24510", "Baltimore", "Los Angeles")  ## Adding a column for city names for plot

## Plot barplot for the change
library(ggplot2); library(dplot)
png(filename = "plot6.png", width = 480, height = 480, units = "px")
ggplot(df_result, aes(x= year, y = ch*100)) + geom_point(aes(color=year), size = 4
        )+ geom_smooth(method = "lm", se=FALSE) + facet_grid(city~.) + ylab("Percent change over the years") + ggtitle(
        "LA and Baltimore Motor Vehicle Emission Change Comparison")

dev.off()

