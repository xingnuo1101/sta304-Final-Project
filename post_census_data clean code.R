#### Preamble ####
# Purpose: Cleaning post stratification data
# Author: Xingnuo Zhang (1006145306)
# Data: 17 December 2020
# Contact: xingnuo.zhang@mail.utoronto.ca


############# Cleaning Post stratification data #################

#### Workspace setup ####
library(haven)
library(tidyverse)

#load in the cleaned census data

census_data <- read_csv("cleaned_gss_data.csv")

# Set up Post stratification data

post_census_data <- 
  census_data %>%
  count(age,sex,province,education) %>%
  group_by(age,sex,province,education) 


# Saving the poststratification data

write_csv(post_census_data, "post_census_data.csv")