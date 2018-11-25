library(readr)
library(dplyr)
library(plotly)

# read data
accidents <- read_csv("simple_examples/accidents.csv")

# aggregate data
accidents_agg <- accidents %>% 
  group_by(hour) %>% 
  summarize(frequency = n(), average = mean(accident_damages))

## phase 1

accidents_agg %>% 
  plot_ly(x = ~hour, y = ~frequency, type = "bar")

## phase 2

accidents_agg %>% 
  plot_ly(x = ~hour, y = ~frequency, type = "bar") %>% 
  add_lines(y = ~average, type = "line", yaxis = "y2") %>% 
  layout(
    yaxis = list(side = "left"),
    yaxis2 = list(side = "right", overlaying = "y"))

## phase 3

accidents_agg %>% 
  plot_ly(x = ~hour, y = ~frequency, type = "bar", name = "frequency", color = I("#A00606")) %>% 
  add_lines(y = ~average, type = "line", yaxis = "y2", name = "average damage", line = list(color = "#052F66")) %>% 
  layout(
    xaxis = list(title = "hour"),
    yaxis = list(side = "left", title = "frequency"),
    yaxis2 = list(side = "right", overlaying = "y", title = "damage in $"))


# more charts at https://plot.ly/r/#basic-charts