# nieco co vie len miso
dashboardPage(
  dashboardHeader(title = "One visualiasation"),
  dashboardSidebar(
    sidebarMenu(
      # it s crucial to name sidebar menu
      id = "sbm",
      menuItem(
        "Filters",
        tabName = "filters",
        icon = icon("filter"),
        startExpanded = TRUE,
        selectInput(
          "phs1",
          "Number of Casualties",
          choices = c(1,2,3)
        ),
        selectInput(
          "phs2",
          "Accident Severity",
          choices = c(3,4,5)
        ),
        selectInput(
          "phs3",
          "Road Type",
          choices = c(6,7,8)
          )
        ),
      width = 240
      )
    ),
  dashboardBody(
    tabItem(tabName = "filters",
            fluidRow(
              valueBox(10 * 2, "Killed", icon = icon("male"), width = 4),
              valueBox('15M', "Damaged", icon = icon("usd"), width = 4),
              valueBox(44, "Some Number", icon = icon("address-book"), width = 4)),
            fluidRow(
              column(width = 6,
                     box(title = "Tabulecka este krajsia", 
                         solidHeader = FALSE, 
                         status = "primary",
                         width = NULL,
                         DT::dataTableOutput("tabulka")
                         )),
              column(width = 6,
                     box(title = "Obraztek krasny",
                         solidHeader = FALSE,
                         status = "primary",
                         width = NULL,
                         plotOutput("obraztek")))),
            fluidRow(
              column(width = 12,
                     box(title = "Mapka jukej",
                         solidHeader = FALSE,
                         width = NULL,
                         leaflet::leafletOutput("accident_map")))
            )
            )
            
      )
  )

  






# fluidPage(
#   leaflet::leafletOutput("accident_map")
# )