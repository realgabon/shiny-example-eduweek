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
        selectInput("num_casualties", "Number of Casualties", choices = unique(accident_data$num_casualties)),
        selectInput("accident_severity", "Accident Severity", choices = unique(accident_data$accident_severity)),
        selectInput("road_type", "Road Type", choices = unique(accident_data$road_type))
      ),
      menuItem(
        "Grouping",
        tabName = "grouping",
        icon = icon("filter"),
        selectInput("grouping_var", "Grouping column", choices = grouping_columns)
      ),
      width = 240
    )
  ),
  dashboardBody(
    tabItem(tabName = "filters",
            # fluidRow(
            #   valueBox(10 * 2, "Killed", icon = icon("male"), width = 4),
            #   valueBox('15M', "Damaged", icon = icon("usd"), width = 4),
            #   valueBox(44, "Some Number", icon = icon("address-book"), width = 4)),
            fluidRow(
              column(
                width = 6,
                box(title = "Tabulecka este krajsia", status = "primary", width = NULL, DT::dataTableOutput("tabulka"))
              ),
              column(
                width = 6,
                box(title = "Obraztek krasny", status = "primary", width = NULL, plotlyOutput("plotly_chart"))
              )
            ),
            fluidRow(
              column(
                width = 12,
                box(title = "Mapka jukej", width = NULL, leafletOutput("accident_map"))
              )
            )
    )
  )
)