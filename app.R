library(shiny)
library(ggplot2)
library(dplyr)

data <- read.csv('data.csv')
termopt <- unique(data$term)
subjopt <- unique(data$crs)
radio <- c('gender','ethnicity')

ui <- fluidPage()

server <- function(input, output) {}

shinyApp(ui = ui, server = server)