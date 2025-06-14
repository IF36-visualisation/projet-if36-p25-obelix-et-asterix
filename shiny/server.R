library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(lubridate)

server <- function(input, output, session) {
  walmart <- read_delim("../data/Walmart.csv", delim = ";")
  superstore <- read_csv("../data/superstore.csv")
  
  # ???????????????????????????Q5???
  observe({
    cats <- unique(superstore$Category)
    updateCheckboxGroupInput(session, "categories", 
                             choices = cats, selected = cats)
  })
  
  # Q2: Ventes par jour
  output$plot_jour <- renderPlot({
    df <- walmart %>% mutate(Date = as.Date(dtme))
    if (!is.null(input$date_jour)) {
      df <- df %>%
        filter(Date >= input$date_jour[1] & Date <= input$date_jour[2])
    }
    df <- df %>%
      mutate(Jour = factor(weekdays(Date),
                           levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))) %>%
      group_by(Jour) %>%
      summarise(Total = sum(total, na.rm = TRUE))
    
    ggplot(df, aes(x = Jour, y = Total)) +
      geom_col(fill = "steelblue") +
      labs(title = "Ventes par jour (Walmart)", x = "Jour", y = "Total ($)") +
      theme_minimal()
  })
  
  # Q3: Remise vs Profit
  output$plot_remise <- renderPlot({
    df <- superstore %>%
      filter(Discount >= input$discount_range[1], Discount <= input$discount_range[2])
    
    ggplot(df, aes(x = Discount, y = Profit)) +
      geom_point(alpha = 0.3, color = "darkred") +
      geom_smooth(method = "lm", se = FALSE, color = "black") +
      labs(title = "Remise vs Profit", x = "Remise", y = "Profit") +
      theme_minimal()
  })
  
  # Q4: Top produits par profit
  output$plot_produits <- renderPlot({
    topN <- input$topN
    df <- superstore %>%
      group_by(`Product Name`) %>%
      summarise(TotalProfit = sum(Profit, na.rm = TRUE)) %>%
      arrange(desc(TotalProfit)) %>%
      slice_head(n = topN)
    
    ggplot(df, aes(x = reorder(`Product Name`, TotalProfit), y = TotalProfit)) +
      geom_col(fill = "forestgreen") +
      coord_flip() +
      labs(title = paste0("Top ", topN, " produits par profit"),
           x = "Produit", y = "Profit total") +
      theme_minimal()
  })
  
  # Q5: Profit par cat??gorie et remise
  output$plot_cat_remise <- renderPlot({
    req(input$categories)
    
    df <- superstore %>%
      filter(Category %in% input$categories)
    
    cuts <- if (input$cut_remise == "4 groupes") {
      c(0, 0.2, 0.4, 0.6, 1)
    } else {
      c(0, 0.1, 0.2, 0.3, 0.4, 0.6, 1)
    }
    
    labs <- paste0(head(cuts, -1) * 100, "-", tail(cuts, -1) * 100, "%")
    
    df <- df %>%
      mutate(DiscGroup = cut(Discount, breaks = cuts, labels = labs, include.lowest = TRUE)) %>%
      group_by(Category, DiscGroup) %>%
      summarise(AvgProfit = mean(Profit, na.rm = TRUE), .groups = "drop")
    
    ggplot(df, aes(x = DiscGroup, y = AvgProfit, fill = Category)) +
      geom_col(position = "dodge") +
      labs(title = "Profit moyen par cat??gorie & remise",
           x = "Taux de remise", y = "Profit moyen") +
      theme_minimal()
  })
  
  # Q14: Mise ?? jour des villes disponibles
  observe({
    villes <- sort(unique(walmart$city))
    updateSelectInput(session, "ville", choices = villes, selected = villes[1])
  })
  
  # Q14: Produits populaires par ville
  output$plot_produits_walmart <- renderPlot({
    req(input$ville)
    
    filtered <- walmart %>% filter(city == input$ville)
    
    produits <- filtered %>%
      group_by(product_line) %>%
      summarise(Total_Quantity = sum(quantity, na.rm = TRUE)) %>%
      arrange(desc(Total_Quantity))
    
    ggplot(produits, aes(x = reorder(product_line, Total_Quantity), y = Total_Quantity)) +
      geom_col(fill = "skyblue") +
      coord_flip() +
      labs(title = paste("Produits les plus achet??s ??", input$ville),
           x = "Produit", y = "Quantit?? achet??e") +
      theme_minimal()
  })
  
  # Q17: Profits par segment ou ville
  output$plot_segment <- renderPlot({
    df <- superstore
    if (input$agg_segment == "Segment") {
      df2 <- df %>%
        group_by(Segment) %>%
        summarise(TotalProfit = sum(Profit, na.rm = TRUE))
      
      ggplot(df2, aes(x = Segment, y = TotalProfit, fill = Segment)) +
        geom_col() +
        labs(title = "Profit total par Segment", y = "Profit", x = "Segment") +
        theme_minimal()
    } else {
      df2 <- df %>%
        group_by(City) %>%
        summarise(TotalProfit = sum(Profit, na.rm = TRUE)) %>%
        arrange(desc(TotalProfit)) %>%
        slice_head(n = 10)
      
      ggplot(df2, aes(x = reorder(City, TotalProfit), y = TotalProfit)) +
        geom_col(fill = "steelblue") +
        coord_flip() +
        labs(title = "Top 10 villes par Profit", y = "Profit total", x = "City") +
        theme_minimal()
    }
  })
}
