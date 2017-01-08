library(shiny)
library(rCharts)
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
      checkboxGroupInput("sub","Subject Area", choices = subjopt),
      actionButton("go", "Update")),
    mainPanel(showOutput("hist", lib = 'nvd3')))
)

server <- function(input, output) {
  temp <- eventReactive(input$go, {
    dots <- lapply(list("term",input$demo), as.symbol)
    
    temp <- data %>%
      subset(term %in% input$strm & crs %in% input$sub) %>%
      group_by_(.dots = dots) %>%
      summarise(avg = mean(success))
    
    names(temp)[2] <- "demo_col"
    temp
  })
  
  output$hist <- renderChart ({
    n1 <- nPlot(avg ~ term, group = "demo_col", data = temp(), type = "multiBarChart")
    n1$addParams(dom = 'hist')
    n1$chart(color = c('blue', 'orange', 'brown', 'green', 'red'))
    n1$chart(forceY = c(0,100))
    n1$chart(tooltipContent = "#! function(key, x, y, e){ 
      return '<h3>' + key + '</h3>' + '<strong>' + y + '%' + '</strong>' +' in ' + x
      } !#")
    n1$yAxis(axisLabel='Course Success Rate (%)', width=50)
    return(n1)
  })
}

shinyApp(ui = ui, server = server)