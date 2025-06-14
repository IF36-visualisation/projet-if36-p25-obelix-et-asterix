library(shiny)
library(shinydashboard)

server <- function(input, output) {
  
  output$commande_superstore <- renderInfoBox({
    data <- read.csv("../data/superstore.csv")
    n_commande <- nrow(data)
    
    infoBox(
      title = "Commande Superstore",
      value = n_commande,
      icon = icon("shop"),
      color = "light-blue",
      fill = TRUE
    )
  })
  
  output$commande_walmart <- renderInfoBox({
    data <- read.csv("../data/Walmart.csv")
    n_commande <- nrow(data)
    
    infoBox(
      title = "Commande Walmart",
      value = n_commande,
      icon = icon("shop"),
      color = "light-blue",
      fill = TRUE
    )
  })
}