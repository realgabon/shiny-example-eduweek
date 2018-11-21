
# doplnit kniznice

library(shiny)
library(mapview)
library(leaflet)
library(DT)
library(readr)
library(rlang)
library(dplyr)
library(plotly)

accident_data <- read_rds("accidents_processed.rds")
