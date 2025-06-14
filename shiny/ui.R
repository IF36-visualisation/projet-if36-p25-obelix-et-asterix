library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Supermarché"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Information", tabName = "Information", icon = icon("circle-info")),
      menuItem("La list", tabName = "list", icon = icon("list"))
    )
  ),
  dashboardBody(
    tags$head(
      includeCSS("www/style.css")  # 引入 CSS 样式表
    ),
    tabItems(
      tabItem(tabName = "Information",
              h2("Information sur les datasets",class = "title"),
              infoBoxOutput("commande_superstore"),
              infoBoxOutput("commande_walmart"),
      ),
      tabItem(tabName = "list",
              h2("Widgets tab content")
      )
    )
  )
)

