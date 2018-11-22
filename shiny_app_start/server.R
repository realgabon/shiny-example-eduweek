server <- function(input, output) {
  
  filtered_data <- reactive({
    
    # Server code for filtering
  
  })
  
  grouping_var <- reactive({
    
    # Server code for grouping variable symbol
  
  })
  
  grouped_data <- reactive({
    
    # Server code for further grouping of filtered data
    
  })
  
  output$plotly_chart <- renderPlotly({
    
    # Server code for plotly chart
    
  })
  
  output$grouped_table <- renderDataTable({
    
    # Server code for grouped data table
    
  })
  
  output$accident_map <- renderLeaflet({
    
    # Server code for mapping filtered accidents
    
  })
  
  
  
  
  
}
  