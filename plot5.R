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
# Baltimore City.
NEI_mv <- NEI[NEI$SCC %in% mv & NEI$fips == '24510',]

# uses dplyr's group_by() to group the data by year in the subset, then uses
# dplyr's summarize() to sum emissions for each year.
ds <- summarize(group_by(NEI_mv, year), total_emissions = sum(Emissions))

# creates a ggplot2 plot object with total motor-vehicle emissions vs year
g <- ggplot(ds, aes(factor(year), total_emissions))

# adds a bar geom to the plot object for creation of a bar plot
g + geom_bar(stat = 'identity', fill = 'steelblue') +

# adds a main title to plot object
labs(title = expression(atop('Yearly Total ' * PM[2.5] * ' Emissions from Motor Vehicle Sources',
                             paste('in Baltimore City Reported Every Three Years (1999-2008)')))) +

# adds axes labels to plot object
labs(x = 'Year',
     y = expression('Total Motor-Vehicle' * PM[2.5] * ' Emissions (Tons)')) +

# adds a theme to the plot object to adjust x-axis tic marks.
theme(axis.text.x = element_text(angle = 0))

# writes display of plot object to a png file in which height and width are in inches
# and set to values which when used with a dpi of 72 result in a 480px x 480px
# png file.
ggsave('plot5.png', width = 6.6667, height = 6.6667, dpi = 72)
