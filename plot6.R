# checks to see if dplyr package is installed. if not, it's installed.
if (!'dplyr' %in% installed.packages()) {
    install.packages('dplyr')
}
# checks to see if ggplot2 package is installed. if not, it's installed.
if (!'ggplot2' %in% installed.packages()) {
    install.packages('ggplot2')
}

# loads dplyr package
library(dplyr)

# loads ggplot2 package
library(ggplot2)

# reads summarySCC_PM25.rds into a data frame
NEI <- readRDS('summarySCC_PM25.rds')

# reads Source_Classification_Code.rds into a data frame
SCC <- readRDS('Source_Classification_Code.rds')

# from the SCC data frame, creates a vector of source codes for emissions
# related to motor vehicles
mv <- SCC$SCC[grepl('[vV]ehicle', SCC$SCC.Level.Two)]

# subsets NEI data set to only include motor-vehicle emissions data from
# Baltimore City and Los Angeles County
NEI_mvbl <- NEI[(NEI$fips == '24510' | NEI$fips == '06037') & NEI$SCC %in% mv,]


# uses dplyr's group_by() to group the subset by fips (local codes) then by year
# and then uses dplyr's summarize() to calculate a sum of motor-vehicle
# emissions for each of the years for both Baltimore City and Los Angeles
# County
ds <- summarize(group_by(NEI_mvbl, fips, year),
                total_emissions = sum(Emissions))

# changes the factor labels of fips to ones which make more sense (crucial
# for properly labelled facets).
ds <- transform(ds, fips = factor(fips, labels = c("Los Angeles County",
                                                   "Baltimore City")))

# creates a ggplot2 plot object with total motor-vehicle emissions vs year for
# each locale.
g <- ggplot(ds, aes(factor(year), total_emissions))

# adds a bar geom to the plot object for creation of a bar plot
g + geom_bar(stat = 'identity', fill = 'steelblue') +
labs(title = expression(atop('Yearly Total ' * PM[2.5] * ' Emissions from Coal-Combustion in Los Angeles',
                        paste('County and Baltimore City Reported Every Three Years(1999-2008)')))) +

# adds a main title to plot object
labs(x = 'Year',
     y = expression('Total Motor-Vehicle' * PM[2.5] * ' Emissions (Tons)')) +

# adds a theme to the plot object to adjust x-axis tic marks.
theme(axis.text.x = element_text(angle = 0)) +

# adds to plot object a facet grid of the locales with plots arranged
# vertically. The scales='free' argument. Proportionalizes the axes
# relative to the data in each of the two facets, thereby proportionalizing
# the changes from year to year for each locale.
facet_grid(fips ~ ., scales='free')

# writes display of plot object to a png file in which height and width are in inches
# and set to values which when used with a dpi of 72 result in a 480px x 480px
# png file.
ggsave('plot6.png', width = 6.6667, height = 6.6667, dpi = 72)
