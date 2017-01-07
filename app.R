library(shiny)
library(ggplot2)
library(dplyr)

data <- read.csv('data.csv')
termopt <- unique(data$term)
subjopt <- unique(data$crs)
radio <- c('gender','ethnicity')

ui <- fluidPage(
  checkboxGroupInput("strm","Select a Term", choices = termopt),
  plotOutput("hist")
)

server <- function(input, output) {
  output$hist <- renderPlot ({
    
    temp <- data %>%
      subset(term %in% input$strm) %>%
      group_by(term) %>%
      summarise(avg = mean(success))
    
    ggplot(data = temp, aes(x = term, y = avg)) +
      geom_bar(stat = 'identity')
    
  })
}

shinyApp(ui = ui, server = server)