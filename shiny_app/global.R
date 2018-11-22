
# doplnit kniznice

library(shiny)
library(mapview)
library(leaflet)
library(DT)
library(readr)
library(rlang)
library(dplyr)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(sp)

accident_data <- read_rds("accidents_processed.rds")

grouping_columns <- c("road_type", 
                      "road_conditions", 
                      "weather_conditions", 
                      "light_conditions", 
                      "year", 
                      "weekday", 
                      "hour")