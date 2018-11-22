server <- function(input, output) {
  
  filtered_data <- reactive({
    data <- accident_data
    
    if(!is.null(input$num_vehicles)) {
      data <- data %>% filter(num_vehicles %in% input$num_vehicles)
    }

    if(!is.null(input$num_casualties)) {
      data <- data %>% filter(num_casualties %in% input$num_casualties)
    }
    
    if(!is.null(input$accident_severity)) {
      data <- data %>% filter(accident_severity %in% input$accident_severity)
    }
    
    if(!is.null(input$police_department)) {
      data <- data %>% filter(police_department %in% input$police_department)
    }
    
    if(!is.null(input$police_attended)) {
      data <- data %>% filter(police_attended %in% input$police_attended)
    }
    
    if(!is.null(input$urban_vs_rural )) {
      data <- data %>% filter(urban_vs_rural  %in% input$urban_vs_rural )
    }
    
    data
    
  })
  


  
  data_filtered_grouped <- reactive({

    #group_column_text <- input$dummy_grouping_field
    #group_column_expr <- parse_expr(group_column_text)
      
    var_enq <- rlang::sym(as_string(input$grouping_var))
    
    tmp <- filtered_data() %>% 
 
      group_by(!!var_enq) %>%
      summarize(countx = n(), avg = mean(accident_damages))

    data
  })


  output$plotly_chart <- renderPlotly({
    
    var_enq1 <- rlang::sym(as_string(input$grouping_var))
    
    tmp <- filtered_data() %>% 
      group_by(!!var_enq1) %>%
      summarize(countx = n(), avg = mean(accident_damages))
    
    chart_bl <- plot_ly(tmp,x = ~eval_tidy(var_enq1), y = ~countx, name = 'count', type= 'bar',color = I("#A00606")) %>%
      add_lines(y = ~avg, name = 'damages',  type= 'line', line = list(color = "#052F66"),yaxis = "y2") %>%

       layout(
        xaxis = list(
          title=  input$grouping_var
        ),
        yaxis = list(
          title=  "Count",
          side = "left"
        ),
        yaxis2 = list(
          title=  "Damages",
          side = "right",
          overlaying = "y"

        ),
        title = "WHAT IS THIS?",

        legend = list(orientation = "h", yanchor = "top", borderwidth = 0,y=-0.75

        ))
  })
  
  output$tabulka <- renderDataTable({
    summary(cars)
  })
  
  output$accident_map <- renderLeaflet({
    
    # group_column_text <- input$dummy_grouping_field
    # group_column_expr <- parse_expr(group_column_text)
    
    # map_data <- data_filtered() %>% 
    #   select(longitude, latitude, !!group_column_expr) %>% 
    #   filter(complete.cases(longitude, latitude, !!group_column_expr))
    
    map_data <- accident_data %>% 
      select(longitude, latitude) %>% 
      filter(complete.cases(longitude, latitude))
    
    longitude_center <- mean(map_data[, 1])
    latitude_center <- mean(map_data[, 2]) + 1
    
    center_coordinates <- c(longitude_center, latitude_center)
    
    coordinates(map_data) <- ~ longitude + latitude
    proj4string(map_data) <- "+init=epsg:4326"
    
    m <- mapview(map_data, cex = 2, alpha = 0.5, alpha.regions = 0.5)
    # m <- mapview(map_data, zcol = group_column_text, burst = TRUE, cex = 2, alpha = 0.5, alpha.regions = 0.5)
    m@map %>% setView(center_coordinates[1], center_coordinates[2], zoom = 6)
    
  })
  
}

