library(shiny)
library(ggplot2)
library(dplyr)

data <- read.csv('data.csv')
termopt <- unique(data$term)
subjopt <- unique(data$crs)
radio <- c('gender','ethnicity')
testing <- c("Fall, 2014" = 'Wrong',
             "Spring, 2015" = 'Wrong',
             "Fall, 2015" = 'Right!',
             "Spring, 2016" = 'Wrong')

ui <- fluidPage(
  checkboxGroupInput("term","Select a Term", choices = termopt),
  textOutput("test")
)

server <- function(input, output) {
  output$test <- renderText ({
    testing[input$term]
  })
}

shinyApp(ui = ui, server = server)