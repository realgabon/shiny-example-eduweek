server <- function(input, output) {
  
  filtered_data <- reactive({
    # Server code for filtering
  
  })
  
  output$plotly_chart <- renderPlotly({
    # Server code for plotly chart
    
  })
  
  output$accident_map <- renderLeaflet({
    # Server code for mapping filtered accidents
    
  })
  
  
}
  