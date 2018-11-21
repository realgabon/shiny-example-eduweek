
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
