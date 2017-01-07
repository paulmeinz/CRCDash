library(shiny)
library(ggplot2)

data <- read.csv('data.csv')

ui <- fluidPage()

server <- function(input, output) {}

shinyApp(ui = ui, server = server)