server <- function(input, output) {
  
  filtered_data <- reactive({
    data <- accident_data

    if(!is.null(input$num_casualties)) {
      data <- data %>% filter(num_casualties %in% input$num_casualties)
    }
    
    if(!is.null(input$accident_severity)) {
      data <- data %>% filter(accident_severity %in% input$accident_severity)
    }
    
    if(!is.null(input$road_type)) {
      data <- data %>% filter(road_type %in% input$road_type)
    }
    
  })
  

  col_names <- reactive({
    
    filtered_data() %>% select(
      weekday,
      road_type
    ) %>% names
  })
  
   
  
  output$grouping_var <- renderUI({
    
    selectInput("grouping_var", label = h3("Select Groups to plot"), 
                choices = col_names())
    
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
  # 
  # data_filtered_grouped <- reactive({
  # 
  #   group_column_text <- input$dummy_grouping_field
  #   group_column_expr <- parse_expr(group_column_text)
  # 
  #   filtered_data() %>%
  #     group_by(!!grouping_column) %>%
  #     summarize(count = n(), avg = mean(!!grouping_column))
  # 
  # })
  # 
  # output$data_table_server <- DT::renderDataTable({
  #   data_filtered_grouped() %>%
  #     datatable()
  # })
  # 
  # output$plotly_chart <- renderplotly({
  #   data_filtered_grouped() %>% nieco_co_vie_len_janka()
  # })
  
  output$obraztek <- renderPlot({
    plot(pressure)
  })

  output$plotly_chart <- renderPlotly({
    
    var_enq1 <- rlang::sym(as_string(input$grouping_var))
    
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

