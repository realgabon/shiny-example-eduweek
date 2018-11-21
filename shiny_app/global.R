
# doplnit kniznice

library(shiny)
library(mapview)
library(leaflet)
library(DT)
library(readr)
library(rlang)


accident_data <- read_rds("accidents_processed.rds")
