# nieco co vie len miso
fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      uiOutput("grouping_var")


    ),
    mainPanel(
      DTOutput('data_table_server'),
      plotly::plotlyOutput("plotly_chart", height="100%", width="100%"),

      leaflet::leafletOutput("accident_map")
      )
   
  )
  

)