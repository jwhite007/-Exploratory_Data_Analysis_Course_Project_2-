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
# related to coal combustion
coal <- SCC$SCC[grepl('[cC]oal', SCC$EI.Sector) & grepl('[cC]omb', SCC$EI.Sector)]

# subsets the NEI data set to include only the data from coal-combustion
# sources
NEI_coal <- NEI[NEI$SCC %in% coal,]

# uses dplyr's group_by() to group the subset by year and then uses dplyr's
# summarize() to calculate a sum of emissions for each of the years
ds <- summarize(group_by(NEI_coal, year), total_emissions = sum(Emissions))

# creates a ggplot2 plot object with total coal-combustion emissions divided
# by 100,000 vs year
g <- ggplot(ds, aes(factor(year), total_emissions / 1e+05))

# adds a bar geom to the plot object for creation of a bar plot
g + geom_bar(stat = 'identity', fill = 'steelblue') +

# adds a main title to plot object
labs(title = expression(atop('Yearly Total ' * PM[2.5] * ' Emissions from Coal-Combustion Sources',
                             paste('Across the United States Reported Every Three Years (1999-2008)')))) +

# adds axes labels to plot object
labs(x = 'Year',
     y = expression('Total ' * PM[2.5] * ' Emissions (Tons x 1e+05)')) +

# adds a theme to the plot object to adjust x-axis tic marks.
theme(axis.text.x = element_text(angle = 0))

# writes display of plot object to a png file in which height and width are in inches
# and set to values which when used with a dpi of 72 result in a 480px x 480px
# png file.
ggsave('plot4.png', width = 6.6667, height = 6.6667, dpi = 72)
