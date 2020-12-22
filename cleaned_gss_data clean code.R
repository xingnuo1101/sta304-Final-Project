#### Preamble ####
# Purpose: Cleaning Census data
# Author: Xingnuo Zhang(1006145306)
# Data: 16 December 2020
# Contact: xingnuo.zhang@mail.utoronto.ca

################## Cleaning Census data #####################

#### Workspace setup ####
library(haven)
library(tidyverse)
library(plyr)

# load in the General Social Survey(GSS) dataset
gss_data <- read.csv("gss.csv")

# Select variables of new dataset
cleaned_gss_data <- 
  gss_data %>% 
  select(
    age,
    sex,
    province,
    education
)

cleaned_gss_data <- cleaned_gss_data %>% 
  mutate(age = as.integer(as.character(age)))

cleaned_gss_data$education <- revalue(cleaned_gss_data$education, 
                                       c("Bachelor's degree (e.g. B.A., B.Sc., LL.B.)" = "Bachelor's degree",
                                         "College, CEGEP or other non-university certificate or di..." = "Associate degree",
                                         "High school diploma or a high school equivalency certificate" = "High school diploma",
                                         "Less than high school diploma or its equivalent" = "No high school diploma",
                                         "Trade certificate or diploma" = "Associate degree",
                                         "University certificate or diploma below the bachelor's level" = "Associate degree",
                                         "University certificate, diploma or degree above the bach..." = "Master's degree"))

cleaned_gss_data = na.omit(cleaned_gss_data, c[4])

# Saving the census data as a csv file

write_csv(cleaned_gss_data, "cleaned_gss_data.csv")


