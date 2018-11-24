library(readr)
library(dplyr)
library(mapview)
library(sp)
library(leaflet)

# read data
accidents <- read_csv("shiny_app_start/accidents.csv")

# process data
accidents_points <- 
  accidents %>%
  filter(accident_severity == "Fatal") %>% 
  select(longitude, latitude, hour)

# optional - compute center coordinates
longitude_center <- mean(accidents_points$longitude)
latitude_center <- mean(accidents_points$latitude)
center_coordinates <- c(longitude_center, latitude_center)

# define which columns are used for location
coordinates(accidents_points) <- ~ longitude + latitude
proj4string(accidents_points) <- "+init=epsg:4326"

# choose maps
maps <- c("OpenStreetMap", "Esri.WorldImagery")

# map 1 - create map of points
m1 <- mapview(accidents_points, map.types = maps, cex = 3)
m1@map

# map 2 - include hour into map
m2 <- mapview(accidents_points, map.types = maps, cex = 3, zcol = "hour", burst = TRUE)
m2@map

# map 3 - optional, center the view with computed coordinate center
m3 <- mapview(accidents_points, map.types = maps, cex = 3, zcol = "hour", burst = TRUE)
m3@map %>% setView(center_coordinates[1], center_coordinates[2], zoom = 6)
