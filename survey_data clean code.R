#### Preamble ####
# Purpose: Cleaning Survey data
# Author: Xingnuo Zhang (1006145306)
# Data: 16 December 2020
# Contact: xingnuo.zhang@mail.utoronto.ca

#### Workspace setup ####
library(cesR)
library(tidyverse)
library(haven)
library(labelled)
library(plyr)

#### Creating Survey data ####

install.packages("devtools")
devtools::install_github("hodgettsp/cesR", force = TRUE)
# Get CES_web online survey
get_ces("ces2019_web")
# convert values to factor
ces2019_web <- to_factor(ces2019_web)
head(ces2019_web)

# Select variables of new dataset
survey_data <- 
  ces2019_web %>% 
  select(
    cps19_gender,
    cps19_education,
    cps19_yob,
    cps19_citizenship,
    cps19_province,
    cps19_votechoice
  )

#Clean the survey data
survey_data$cps19_education <- revalue(survey_data$cps19_education, 
                                 c("Professional degree or doctorate" = "Doctorate degree",
                                   "Master's degree" = "Master's degree",
                                   "Bachelor's degree" = "Bachelor's degree",
                                   "Some university" = "Bachelor's degree",
                                   "Completed technical, community college, CEGEP, College Classique" = "Associate degree",
                                   "Some technical, community college, CEGEP, College Classique" = "High school diploma",
                                   "Completed secondary/ high school" = "High school diploma",
                                   "Some secondary/ high school" = "No high school diploma",
                                   "Completed elementary school" = "No high school diploma",
                                   "Some elementary school" = "No high school diploma",
                                   "No schooling" = "No high school diploma",
                                   "Don't know/ Prefer not to answer" = "No high school diploma"))

survey_data$cps19_gender <- revalue(survey_data$cps19_gender,
                              c("A man" = "Male", 
                                "A woman" = "Female",
                                "Other (e.g. Trans, non-binary, two-spirit, gender-queer)" = "Other"))

survey_data <- survey_data %>% 
  mutate(cps19_yob = as.numeric(2019) - as.numeric(as.character(cps19_yob))) %>%
  filter(cps19_yob >=18)%>%
  filter(cps19_citizenship == "Canadian citizen")

survey_data$cps19_votechoice <- revalue(survey_data$cps19_votechoice,
                                    c("Liberal Party" = "Liberal Party", 
                                      "ndp" = "New Democratic Party",
                                      "Green Party" = "Green Party",
                                      "Conservative Party" = "Conservative Party",
                                      "Bloc Québécois" = "Bloc Québécois"))

# Set up our response variable
survey_data <- survey_data%>%
  filter(cps19_votechoice != "NA")

survey_data <- survey_data %>%
  filter(cps19_votechoice %in% c("Liberal Party","New Democratic Party", "Green Party", "Conservative Party", "Bloc Québécois",
                                 "Don't know/ Prefer not to answer"))%>%
  mutate(cps19_votechoice = 
           ifelse(cps19_votechoice == "Liberal Party", 1, 0))

survey_data <- rename(survey_data,
                    c("cps19_gender" = "sex",
                      "cps19_yob" = "age",
                      "cps19_education" = "education",
                      "cps19_citizenship" = "citizenship",
                      "cps19_province" = "province",
                      "cps19_votechoice" = "vote_liberal")) 

# Saving the survey data as a csv file
  
write_csv(survey_data, "survey_data.csv")
