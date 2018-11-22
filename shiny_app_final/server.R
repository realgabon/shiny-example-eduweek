server <- function(input, output) {
  
  filtered_data <- reactive({
    data <- accident_data
    
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
    
    sym(as_string(input$grouping_var))
  
  })
  
  grouped_data <- reactive({
    
    filtered_data() %>% 
      group_by(!!grouping_var()) %>%
      summarize(countx = n(), avg = mean(accident_damages))
  
  })
  
  
  output$grouped_table <- renderDataTable({
    
    grouped_data() %>% 
      datatable(options = list(dom = 't'), colnames = c('Group Variable', 'Counts', 'Mean'))
  
  })
  
  output$plotly_chart <- renderPlotly({
    
    chart_bl <- grouped_data() %>% 
      plot_ly(x = ~eval_tidy(grouping_var()), y = ~countx, name = 'count', type= 'bar',color = I("#A00606") ) %>%
      add_lines(y = ~avg, name = 'damages',  type= 'line', line = list(color = "#052F66"),yaxis = "y2") %>%

       layout(
        xaxis = list(
          title=  input$grouping_var,
          anchor = "bottom"
        ),
        yaxis = list(
          title=  "damages",
          side = "left",
          hoverformat = ',.'
        ),
        yaxis2 = list(
          title=  "count",
          side = "right",
          overlaying = "y",
          tickfont = list(size = 9.5)

        ),
        title = "WHAT IS THIS?",
        margin = list(
          l = 65,
          r = 65,
          t = 115,
          pad = 4
        ),
        legend = list(orientation = "h", yanchor = "top", borderwidth = 0,y=-0.75

        ))
  })
  
  output$accident_map <- renderLeaflet({
    map_data <- filtered_data() %>%
      select(longitude, latitude, !!grouping_var())
    
    longitude_center <- mean(map_data[, 1])
    latitude_center <- mean(map_data[, 2]) + 1
    
    center_coordinates <- c(longitude_center, latitude_center)
    
    coordinates(map_data) <- ~ longitude + latitude
    proj4string(map_data) <- "+init=epsg:4326"

    m <- mapview(map_data, zcol = as.character(grouping_var()), burst = TRUE, homebutton = FALSE,
                 cex = 2, alpha = 0.5, alpha.regions = 0.5, map.types = "OpenStreetMap")
    
    m@map %>% setView(center_coordinates[1], center_coordinates[2], zoom = 5)
    
  })
  
}

