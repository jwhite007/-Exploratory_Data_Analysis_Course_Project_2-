# reads summarySCC_PM25.rds into a data frame
NEI <- readRDS('summarySCC_PM25.rds')

# reads Source_Classification_Code.rds into a data frame
SCC <- readRDS('Source_Classification_Code.rds')

# opens png device
png(file = 'plot2.png')

# creates a subset which only includes data for Baltimore City from the NEI
# data frame. sums emissions from all sources for each year in this subset
# with tapply, then creates a bar plot using R's base-plotting package,
# plotting total emissions vs year for Baltimore City. Since a png device is
# open, the plot is written to a png file.
with(subset(NEI, fips == '24510'),
     barplot(tapply(Emissions, year, sum) / 1e+03,
             main = expression(atop('Yearly Total ' * PM[2.5] * ' Emissions for Baltimore City',
                               paste('Reported Every Three Years (1999 - 2008)'))),
             ylab = expression('Total ' * PM[2.5] * ' Emissions (Tons x 1e+03)'),
             xlab = 'Year',
             col = 'steelblue'))

# png device is closed
dev.off()