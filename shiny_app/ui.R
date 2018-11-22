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
        selectInput("accident_severity", "Accident Severity", choices = unique(accident_data$accident_severity)),
        selectInput("police_attended", "Police Attended", choices = unique(accident_data$police_attended)),
        selectInput("urban_vs_rural", "Urban/Rural", choices = unique(accident_data$urban_vs_rural))
      ),
      menuItem(
        "Grouping",
        tabName = "grouping",
        startExpanded = TRUE,
        icon = icon("layer-group"),
        selectInput("grouping_var", "Grouping column", choices = grouping_columns)
      ),
      width = 240
    )
  ),
  dashboardBody(
    tabItem(tabName = "filters",
            fluidRow(
              column(
                width = 7,
                box(title = "Obraztek krasny", status = "primary", width = NULL, collapsible = TRUE, plotlyOutput("plotly_chart"))
              ),
              column(
                width = 5,
                box(title = "Mapka jukej", status = "primary", width = NULL, collapsible = TRUE, leafletOutput("accident_map"))
              )),
            fluidRow(
              column(
                width = 7,
                box(title = "Tabulecka este krajsia", status = "primary", width = NULL, DT::dataTableOutput("data_filtered_table"))
              )
              )
    )
  )
)