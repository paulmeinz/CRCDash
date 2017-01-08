library(shiny)
library(ggplot2)
library(dplyr)

data <- read.csv('data.csv')
termopt <- unique(data$term)
subjopt <- unique(data$crs)
radio <- c('Gender','Ethnicity')

ui <- fluidPage(
  
  titlePanel("HawkDash"),
  sidebarLayout(
    sidebarPanel(checkboxGroupInput("strm","Select a Term", choices = termopt),
      radioButtons("demo","Select a Demographic", choices = radio),
      actionButton("go", "Update")),
    mainPanel(plotOutput("hist")))
)

server <- function(input, output) {
  temp <- eventReactive(input$go, {
    dots <- lapply(list("term",input$demo), as.symbol)
    
    temp <- data %>%
      subset(term %in% input$strm) %>%
      group_by_(.dots = dots) %>%
      summarise(avg = mean(success))
    
    names(temp)[2] <- "demo_col"
    temp
  })
  
  output$hist <- renderPlot ({
    ggplot(data = temp(), aes(x = term, y = avg, fill = demo_col)) +
      geom_bar(stat = "identity", position = position_dodge(), colour = "black")
    
  })
}

shinyApp(ui = ui, server = server)