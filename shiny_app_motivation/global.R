
# doplnit kniznice
library(readr)
library(dplyr)
library(plotly)
library(mapview)
library(leaflet)
library(sp)
library(rlang)
library(shinydashboard)

accidents <- read_csv("accidents.csv")

grouping_columns <- c("road_type", 
                      "road_conditions", 
                      "weather_conditions", 
                      "light_conditions", 
                      "year", 
                      "weekday", 
                      "hour")