library(plotly)
library(dplyr)

# generate some data

weekday_list <- c("monday", "tuesday", "wednesday", "thursday", "friday")

n = 50
weekdays <- sample(x = weekday_list, size = n, replace = TRUE)
weekdays_factor <- factor(weekdays, levels = weekday_list) 
accident_damage <- rnorm(n, mean = 5000, sd = 1000)

accidents <- data.frame(day = weekdays_factor, damage = accident_damage)

# aggregate the data

accidents_agg <- accidents %>%
  group_by(day) %>% 
  summarize(frequency = n(), avg_dmg = mean(damage))

# create plotly chart

## phase 1

accidents_agg %>% 
  plot_ly(x = ~day, y = ~frequency, type = "bar")

## phase 2

accidents_agg %>% 
  plot_ly(x = ~day, y = ~frequency, type = "bar") %>% 
  add_lines(y = ~avg_dmg, type = "line", yaxis = "y2") %>% 
  layout(
    yaxis = list(side = "left"),
    yaxis2 = list(side = "right", overlaying = "y"))

## phase 3

accidents_agg %>% 
  plot_ly(x = ~day, y = ~frequency, type = "bar", name = "frequency", color = I("#A00606")) %>% 
  add_lines(y = ~avg_dmg, type = "line", yaxis = "y2", name = "average damage", line = list(color = "#052F66")) %>% 
  layout(
    xaxis = list(title = "weekday"),
    yaxis = list(side = "left", title = "frequency"),
    yaxis2 = list(side = "right", overlaying = "y", title = "damage in $"))


# more charts at https://plot.ly/r/#basic-charts