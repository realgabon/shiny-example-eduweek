# downloaded datasets from 
# https://www.kaggle.com/silicon99/dft-accident-data
# then they were put into full_data folder

library(readr)
library(dplyr)
library(ggplot2)
library(leaflet)
library(stringr)
library(lubridate)

join_lookup_func <- function(data_df, lookup_df, field_name) {
  select_fields <- setdiff(c(colnames(data_df), "label"), field_name)
  by_statement <- setNames("code", field_name)
  
  data_df %>% left_join(lookup_df, by = by_statement) %>%
    select_(.dots = select_fields) %>% 
    rename_(.dots = setNames("label", field_name))
}

police_force_lookup <- read_csv("data_prep/full_data/lookup/Police_Force.csv")
accident_severity_lookup <- read_csv("data_prep/full_data/lookup/Accident_Severity.csv")
road_type_lookup <- read_csv("data_prep/full_data/lookup/Road_Type.csv")
light_conditions_lookup <- read_csv("data_prep/full_data/lookup/Light_Conditions.csv")
urban_rural_lookup <- read_csv("data_prep/full_data/lookup/Urban_Rural.csv")
police_attended_lookup <- read_csv("data_prep/full_data/lookup/Police_Officer_Attend.csv")

accidents_full <- read_csv("data_prep/full_data/Accidents0515.csv")
# casualties_full <- read_csv("data_prep/full_data/Casualties0515.csv")
# vehicles_full <- read_csv("data_prep/full_data/Vehicles0515.csv")

accidents_sampled <- accidents_full %>% sample_n(size = 10000)
# casualties_sampled <- casualties_full %>% inner_join(accidents_sampled, by = c("Accident_Index"))
# vehicles_sampled <- vehicles_full %>% inner_join(accidents_sampled, by = c("Accident_Index"))

accidents_processed <- accidents_sampled %>% 
  select(accident_id = Accident_Index,
         police_department = Police_Force,
         longitude = Longitude,
         latitude = Latitude,
         accident_severity = Accident_Severity,
         num_vehicles = Number_of_Vehicles,
         num_casualties = Number_of_Casualties,
         date = Date,
         time = Time,
         road_type = Road_Type,
         light_conditions = Light_Conditions,
         weather_conditions = Weather_Conditions,
         road_conditions = Road_Surface_Conditions,
         urban_vs_rural = Urban_or_Rural_Area,
         police_attended = Did_Police_Officer_Attend_Scene_of_Accident
         ) %>% 
  join_lookup_func(police_force_lookup, "police_department") %>% 
  join_lookup_func(accident_severity_lookup, "accident_severity") %>% 
  join_lookup_func(road_type_lookup, "road_type") %>% 
  join_lookup_func(light_conditions_lookup, "light_conditions") %>% 
  join_lookup_func(urban_rural_lookup, "urban_vs_rural") %>% 
  join_lookup_func(police_attended_lookup, "police_attended") %>%
  mutate(police_attended = case_when(
    str_detect(str_to_lower(.$police_attended), "yes") ~ "Yes",
    str_detect(str_to_lower(.$police_attended), "no") ~ "No",
    TRUE ~ NA_character_
  )) %>% 
  mutate(light_conditions = case_when(
    str_detect(str_to_lower(.$light_conditions), "daylight") ~ "Daylight",
    str_detect(str_to_lower(.$light_conditions), "darkness") ~ "Darkness",
    TRUE ~ NA_character_
  )) %>%
  mutate(road_conditions = case_when(
    .$road_conditions == 1 ~ "Dry",
    .$road_conditions == 2 ~ "Wet",
    .$road_conditions == 3 ~ "Snow",
    .$road_conditions == 4 ~ "Ice",
    .$road_conditions == 5 ~ "Flood",
    TRUE ~ NA_character_
  )) %>% 
  mutate(weather_conditions = case_when(
    .$weather_conditions %in% c(1, 4) ~ "Fine",
    .$weather_conditions %in% c(2, 5) ~ "Raining",
    .$weather_conditions %in% c(3, 6) ~ "Snowing",
    .$weather_conditions %in% c(7, 8, 9) ~ "Fog",
    TRUE ~ NA_character_
  )) %>% 
  mutate(year = year(dmy(date)),
         weekday = as.character(wday(dmy(date), label = TRUE, abbr = FALSE)),
         hour = hour(time)) %>% 
  mutate(accident_damages = case_when(
    .$accident_severity == "Slight" ~ sample(x = 1:1000, size = n(), replace = TRUE),
    .$accident_severity == "Serious" ~ sample(x = 1001:10000, size = n(), replace = TRUE),
    .$accident_severity == "Fatal" ~ sample(x = 10001:100000, size = n(), replace = TRUE)
  ) * 0.5 * (num_casualties + num_vehicles)) %>% 
  mutate(num_vehicles = case_when(
    .$num_vehicles == 1 ~ "1",
    .$num_vehicles == 2 ~ "2",
    .$num_vehicles >= 3 ~ "3+",
    TRUE ~ NA_character_
  )) %>% 
  mutate(num_casualties = case_when(
    .$num_casualties == 1 ~ "1",
    .$num_casualties == 2 ~ "2",
    .$num_casualties >= 3 ~ "3+",
    TRUE ~ NA_character_
  )) %>% 
  select(accident_id,
         num_vehicles,
         num_casualties,
         accident_severity,
         accident_damages,
         police_department,
         police_attended,
         urban_vs_rural,
         road_type,
         road_conditions,
         weather_conditions,
         light_conditions,
         date,
         year,
         weekday,
         hour,
         longitude,
         latitude
         ) %>% 
  filter(complete.cases(.)) %>% 
  as.data.frame()

write_rds(accidents_processed, "shiny_app_final/accidents_processed.rds", compress = "bz2")
write_rds(accidents_processed, "shiny_app_start/accidents_processed.rds", compress = "bz2")
