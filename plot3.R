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

# creates a subset which only includes data for Baltimore City from the NEI
# data frame. dplyr's group_by() is then used to group the data by type of
# emssion source, then by year. dplyr's summarize() is used to calculate sums
# of each type of emission source for each year.
ds <- summarize(group_by(subset(NEI, fips == '24510'), type, year),
                total_emissions = sum(Emissions))

# changes the order of the factor levels so ON-ROAD and NON-ROAD are displayed
# side-by-side and POINT and NONPOINT are displayed side-by-side. The default
# ordering is alphabetical.
ds$type <- factor(ds$type, levels = c('ON-ROAD', 'NON-ROAD', 'POINT', 'NONPOINT'))

# creates a ggplot2 plot object with total emissions divided by 1,000 vs year
g <- ggplot(ds, aes(factor(year), total_emissions / 1e+03))

# adds a bar geom to the plot object for creation of a bar plot
g + geom_bar(stat = 'identity', fill = 'steelblue') +

# adds to plot object a facet grid of the types with data plotted side-by-side
facet_grid(. ~ type) +

# adds a main title to plot object
labs(title = expression(atop('Yearly Total ' * PM[2.5] * ' Emissions from Four Different Sources',
                             paste('for Baltimore City Reported Every Three Years (1999-2008)')))) +

# adds axes labels to plot object
labs(x = 'Year',
     y = expression('Total ' * PM[2.5] * ' Emissions (Tons x 1e+03)')) +

# adds a theme to the plot object to adjust x-axis tic marks.
theme(axis.text.x = element_text(angle = 0))

# writes display of plot object to a png file in which height and width are in inches
# and set to values which when used with a dpi of 72 result in a 480px x 480px
# png file.
ggsave('plot3.png', width = 6.6667, height = 6.6667, dpi = 72)
