# Author: Lesley Duff
# Filename: housing_prices.R
# Title: Clean some California Housing Prices data
# Date Created: 2023-09-20
# Data Source:
# [California Housing Prices](https://www.kaggle.com/datasets/camnugent/california-housing-prices).
# Description:
# Clean data for analysis

library(tidyverse)

housing_prices <- read_csv("raw_data/housing_prices.csv")

# Explore data ====
head(housing_prices)
str(housing_prices)
glimpse(housing_prices)
summary(housing_prices)

# Rows: 19,675
# Columns: 10
# All numeric except ocean_proximity

# Show what values in ocean proximity
housing_prices %>%
  distinct(ocean_proximity)

# check for missing values
skimr::skim(housing_prices)

# 	total_bedrooms: missing:	200

200 / 19675 * 100
# Around 1% of observations missing total_bedrooms data

# Fix NA total_bedrooms
housing_prices_clean <- housing_prices %>%
  mutate(total_bedrooms = coalesce(
    total_bedrooms,
    median(total_bedrooms, na.rm = TRUE)
  ))
# View(housing_prices_clean)

write_csv(housing_prices_clean, "clean_data/housing_prices.csv")
