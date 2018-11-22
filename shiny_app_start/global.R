# loading libraries
library(shiny)
library(mapview)
library(leaflet)
library(DT)
library(readr)
library(rlang)
library(dplyr)
library(plotly)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(sp)

# loading data
accident_data <- read_rds("accidents_processed.rds")

# grouping var choices
grouping_columns <- c("road_type", 
                      "road_conditions", 
                      "weather_conditions", 
                      "light_conditions", 
                      "year", 
                      "weekday", 
                      "hour")