
data_filtered <- reactive({
  # placeholder na filtre
  data <- accident_data
  
  if(!is.null(input$dummy_filter)) {
    data <- data %>% filter(dummy_field %in% input$dummy_filter)
  }
  
  # repeat...
})

data_filtered_grouped <- reactive({
  data <- data_filtered()
  
  data %>%
    group_by(!!input$dummy_group_field) %>% 
    summarize(n = n(), avg = mean())
    
})

data_table_server <- DT::renderDataTable({
  data_filtered_grouped() %>% 
    datatable()
})

plotly_chart <- renderplotly({
  data_filtered_grouped() %>% nieco_co_vie_len_janka()
})

mapa_nieco <- rendermapa({
  data_filtered() %>% nieco_co_este_neviem()
})