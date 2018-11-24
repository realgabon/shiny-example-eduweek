# loading libraries
library(readr)
library(dplyr)
library(plotly)
library(mapview)
library(leaflet)
library(sp)
library(rlang)
library(shinydashboard)

# loading data
accidents <- read_csv("accidents.csv")

# grouping var choices
grouping_columns <- c("road_type", 
                      "road_conditions", 
                      "weather_conditions", 
                      "light_conditions", 
                      "year", 
                      "weekday", 
                      "hour")