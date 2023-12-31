# File: diamonds.R 
# Author: Lesley Duff
# Date Created: 2023-08-27
# Description:
#   https://ggplot2.tidyverse.org/reference/diamonds.html
#   A dataset containing the prices and other attributes of almost 54,000 
# diamonds. The variables are as follows:
# A data frame with 53940 rows and 10 variables:

#  price
# price in US dollars ($326--$18,823)

# carat
# weight of the diamond (0.2--5.01)

# cut
# quality of the cut (Fair, Good, Very Good, Premium, Ideal)

# color
# diamond colour, from D (best) to J (worst)

# clarity
# a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, 
# VVS2, VVS1, IF (best))

# x
# length in mm (0--10.74)

# y
# width in mm (0--58.9)

# z
# depth in mm (0--31.8)

# depth
# total depth percentage = z / mean(x, y) = 2 * z / (x + y) (43--79)

# table
# width of top of diamond relative to widest point (43--95)

library(ggplot2)

#### Load diamond library from ggplot2 ####
data(diamonds)


#### UI choices for which fill to use ####
choices_fill_variables <- list("Cut" = "cut", 
                               "Colour" = "color",
                               "Clarity" = "clarity")