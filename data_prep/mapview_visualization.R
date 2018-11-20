library(readr)
library(dplyr)
library(mapview)
library(sp)

accidents_processed <- read_rds("processed_data/accidents_processed.rds")

points <- accidents_processed %>%
  select(longitude, latitude) %>% 
  rename(x = longitude,
         y = latitude) %>% 
  filter(complete.cases(x, y))

longitude_center <- mean(points[, 1])
latitude_center <- mean(points[, 2]) + 1

center_coordinates <- c(longitude_center, latitude_center)

coordinates(points) <- ~ x + y
proj4string(points) <- "+init=epsg:4326"

m <- mapview(points, cex = 0.1)
m@map %>% setView(center_coordinates[1], center_coordinates[2], zoom = 6)
