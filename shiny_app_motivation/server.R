server <- function(input, output) {
  
  filtered_data <- reactive({
    data <- accidents
    
    if(!is.null(input$accident_severity)) {
      data <- data %>% filter(accident_severity %in% input$accident_severity)
    }
    
    if(!is.null(input$police_attended)) {
      data <- data %>% filter(police_attended %in% input$police_attended)
    }
    
    if(!is.null(input$urban_vs_rural )) {
      data <- data %>% filter(urban_vs_rural  %in% input$urban_vs_rural )
    }
    
    data
    
  })
  
  grouping_var <- reactive({
    as.symbol(input$grouping_var)
  })
  
  grouped_data <- reactive({
    
    filtered_data() %>% 
      group_by(!!grouping_var()) %>%
      summarize(countx = n(), avg = round(mean(accident_damages),2))
  
  })
  
  output$plotly_chart <- renderPlotly({
    
    chart_bl <-  plot_ly(grouped_data(),x = ~eval_tidy(grouping_var()), y = ~countx, name = 'count', type= 'bar',color = I("#A00606")) %>%
      add_lines(y = ~avg, name = 'damages',  type= 'line', line = list(color = "#052F66"),yaxis = "y2") %>%
      
      layout(
        xaxis = list(
          title=  input$grouping_var
        ),
        yaxis = list(
          title=  "Frequency",
          side = "left"
        ),
        yaxis2 = list(
          title=  "Average Damage",
          side = "right",
          overlaying = "y",
          hoverformat = ',.'
          
        ),
         margin = list(r=77),
         legend = list(orientation = "h",  y=-0.5, x=0.3)
    )
  })
  
  output$accident_map <- renderLeaflet({
    map_data <- filtered_data() %>%
      select(longitude, latitude, !!grouping_var())
    
    longitude_center <- mean(map_data$longitude)
    latitude_center <- mean(map_data$latitude)
    center_coordinates <- c(longitude_center, latitude_center)
    
    coordinates(map_data) <- ~ longitude + latitude
    proj4string(map_data) <- "+init=epsg:4326"

    maps <- c("OpenStreetMap", "Esri.WorldImagery")
    
    zcol_text <- as.character(grouping_var())
    m <- mapview(map_data, map.types = maps, cex = 3, zcol = zcol_text, burst = TRUE, homebutton = FALSE)
    
    m@map %>% setView(center_coordinates[1], center_coordinates[2], zoom = 5)
    
  })
  
}

