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
  
  data_filtered_grouped <- reactive({
      
    var_enq <- rlang::sym(as_string(input$grouping_var))
    
    tmp <- filtered_data() %>% 
 
      group_by(!!var_enq) %>%
      summarize(countx = n(), avg = mean(accident_damages))

    data
  })
  
  output$obraztek <- renderPlot({
    plot(pressure)
  })

  output$plotly_chart <- renderPlotly({
    
    var_enq1 <- sym(as_string(input$grouping_var))
    
    tmp <- filtered_data() %>% 
      group_by(!!var_enq1) %>%
      summarize(countx = n(), avg = mean(accident_damages))
    
    chart_bl <- plot_ly(tmp,x = ~eval_tidy(var_enq1), y = ~countx, name = 'count', type= 'bar',color = I("#A00606") )%>%
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
  
  output$tabulka <- renderDataTable({
    summary(cars)
  })
  
  output$accident_map <- renderLeaflet({
    
    grouping_var_text <- input$grouping_var
    grouping_var <- sym(as_string(grouping_var_text))
    
    map_data <- filtered_data() %>%
      select(longitude, latitude, !!grouping_var) %>%
      filter(complete.cases(longitude, latitude, !!grouping_var))
    
    longitude_center <- mean(map_data[, 1])
    latitude_center <- mean(map_data[, 2]) + 1
    
    center_coordinates <- c(longitude_center, latitude_center)
    
    coordinates(map_data) <- ~ longitude + latitude
    proj4string(map_data) <- "+init=epsg:4326"
    
    m <- mapview(map_data, zcol = grouping_var_text, burst = TRUE, cex = 2, alpha = 0.5, alpha.regions = 0.5)
    m@map %>% setView(center_coordinates[1], center_coordinates[2], zoom = 6)
    
  })
  
}

