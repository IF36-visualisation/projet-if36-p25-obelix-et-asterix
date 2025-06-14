library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Analyse interactive Superstore & Walmart"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Ventes par jour", tabName = "jour", icon = icon("calendar")),
      menuItem("Remise vs Profit", tabName = "remise", icon = icon("percent")),
      menuItem("Top produits", tabName = "produits", icon = icon("star")),
      menuItem("Profit Cat??gories", tabName = "categorie", icon = icon("tags")),
      menuItem("Profits par Segment", tabName = "segment", icon = icon("users")),
      menuItem("Produits populaires (Walmart)", tabName = "populaires", icon = icon("shopping-cart"))
    )
  ),
  dashboardBody(
    tabItems(
      # Q2
      tabItem(tabName = "jour",
              box(width = 12,
                  dateRangeInput("date_jour",
                                 "P??riode (Walmart)", 
                                 start = NULL, end = NULL)
              ),
              box(plotOutput("plot_jour"), width = 12)
      ),
      # Q3
      tabItem(tabName = "remise",
              box(width = 6,
                  sliderInput("discount_range", "Filtrer par remise (%)", 
                              min = 0, max = 0.8, value = c(0, 0.8), step = 0.01)
              ),
              box(plotOutput("plot_remise"), width = 12)
      ),
      # Q4
      tabItem(tabName = "produits",
              box(width = 4,
                  sliderInput("topN", "Nombre de produits ?? afficher", 
                              min = 5, max = 20, value = 10, step = 1)
              ),
              box(plotOutput("plot_produits"), width = 12)
      ),
      # Q5
      tabItem(tabName = "categorie",
              box(width = 4,
                  checkboxGroupInput("categories", "Choisir cat??gories", 
                                     choices = NULL, selected = NULL),
                  radioButtons("cut_remise", "Grille remise", choices = c("4 groupes", "6 groupes"))
              ),
              box(plotOutput("plot_cat_remise"), width = 12)
      ),
      # Q14
      tabItem(tabName = "populaires",
              fluidRow(
                box(
                  title = "Choisissez une ville",
                  width = 4,
                  selectInput("ville", "Ville :", choices = NULL)
                ),
                box(
                  title = "Produits les plus achet??s dans la ville",
                  width = 8,
                  plotOutput("plot_produits_walmart")
                )
              )
      ),
      # Q17
      tabItem(tabName = "segment",
              box(width = 4,
                  radioButtons("agg_segment",
                               "Agr??gation :",
                               choices = c("Segment", "City"))
              ),
              box(plotOutput("plot_segment"), width = 12)
      )
    )
  )
)
