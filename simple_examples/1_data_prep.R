library(readr)
library(dplyr)

# read and inspect
accidents <- read_csv("shiny_app_start/accidents.csv")

accidents %>% colnames()
accidents %>% head()
accidents %>% count()

accidents %>% View()

# filter
accidents_filtered <- 
  accidents %>% 
  filter(accident_severity == "Serious")

accidents_filtered %>% count()

# group by and summarize
accidents %>% 
  group_by(hour) %>% 
  summarize(frequency = n(), average = mean(accident_damages)) %>% 
  print(n = 24)

# other possible dataframe operations
# select(), mutate(), arrange()

# more at https://dplyr.tidyverse.org/