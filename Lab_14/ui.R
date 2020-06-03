selection_column = column(
    3,
    box(title = "Start and end date", solidHeader = TRUE,
        dateRangeInput("times", "", start = min_time, end = max_time)),
    box(title = "Include skipped songs?",
        checkboxInput("include_skipped", label = "Yes please", value = FALSE)),
    box("Plot my habits!",
        actionButton("do_plot", "Pls"))
)

output_column = column(
    9,
    fluidRow(infoBox("Musical habits",
                     value = "Have a look at your favorite time for music!",
                     icon = icon("headphones-alt")),
             infoBox("Sharing is caring",
                     value = "Don't forget to share this app on social media",
                     icon = icon("share"))),
    fluidRow(box(title = "Listening hours",
                 solidHeader = TRUE, status = "primary",
                 plotOutput("hours_plot")),
             box(title = "Listening days",
                 solidHeader = TRUE, status = "primary",
                 collapsible = TRUE,
                 plotOutput("days_plot"))
    )
)

sidebar = dashboardSidebar(
    sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("About", tabName = "about")
    )
)

body = dashboardBody(
    tabItems(
        tabItem(tabName = "dashboard",
                selection_column,
                output_column
        ),

        tabItem(tabName = "about",
                h2("About this app"),
                fluidRow(infoBox(title = "Visits this site to see more",
                                 value = "Github", href = "https://github.com/StatsIMUWr/SpotifyViz"))
        )
    )
)

# Put them together into a dashboardPage
dashboardPage(
    dashboardHeader(title = "SpotifyViz"),
    sidebar,
    body
)
