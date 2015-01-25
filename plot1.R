# reads summarySCC_PM25.rds into a data frame
NEI <- readRDS('summarySCC_PM25.rds')

# # reads Source_Classification_Code.rds into a data frame
SCC <- readRDS('Source_Classification_Code.rds')

# opens png device
png(file = 'plot1.png')

# sums emissions from all sources for each year in NEI with tapply,
# then creates a bar plot using R's base-plotting package, plotting
# total emissions vs year. Since a png device is open, the plot is
# written to a png file.
with(NEI, barplot(tapply(Emissions, year, sum) / 1e+06,
                  main = expression(atop('Yearly Total ' * PM[2.5] * ' Emissions in the United States',
                                    paste('Reported Every Three Years (1999 - 2008)'))),
                  ylab = expression('Total ' * PM[2.5] * ' Emissions (Tons x 1e+06)'),
                  xlab = 'Year',
                  col = 'steelblue'))

# png device is closed
dev.off()
