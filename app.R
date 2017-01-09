library(shiny)
library(rCharts)
library(dplyr)

# Grab data and calculate button/input values
data <- read.csv("data.csv")
termopt <- unique(data$term)
subjopt <- unique(data$crs)
radio <- c("Gender","Ethnicity")

ui <- fluidPage(
  
  #link css file
  theme = "style.css",
  
  # Headers
  fluidRow(
    column(4, class = "top1",
      tags$p(tags$h1(style = "color: white",
                     "CRC HawkDash"))),
    column(8, class = "top2",
      tags$p(
        tags$h1(style = "color: White; text-align: center",
                "Interactive Course Success Dashboard")))),
  
  # Input buttons and plot area
  sidebarLayout(
    sidebarPanel(checkboxGroupInput("strm","Select a Term", choices = termopt),
      radioButtons("demo","Select a Demographic", choices = radio),
      checkboxGroupInput("sub","Subject Area", choices = subjopt),
      actionButton("go", "Update")),
    mainPanel(showOutput("hist", lib = 'nvd3'))),
  
  # Bottom row with note about fabricated data
  fluidRow(
    column(12, class = "bottom",
      tags$p(style = "color: White; size: 16px","Product of CRC Research.
             Data are fabricated for demonstration purposes."))
  )
)

server <- function(input, output) {
  
  # Calculate plot data after update has been clicked
  temp <- eventReactive(input$go, {
    dots <- lapply(list("term",input$demo), as.symbol)
    
    temp <- data %>%
      subset(term %in% input$strm & crs %in% input$sub) %>%
      group_by_(.dots = dots) %>%
      summarise(avg = mean(success))
    
    names(temp)[2] <- "demo_col"
    temp
  })
  
  # Create javascript Rcharts plot
  output$hist <- renderChart ({
    n1 <- nPlot(avg ~ term, group = "demo_col", data = temp(), type = "multiBarChart")
    n1$addParams(dom = 'hist')
    n1$chart(color = c('blue', 'orange', 'brown', 'green', 'red'))
    n1$chart(forceY = c(0,100))
    n1$chart(tooltipContent = "#! function(key, x, y, e){ 
      return '<p>' + '<strong>' + key + '</strong>' + '</p>' + 
      '<strong>' + y + '%' + '</strong>' +' in ' + x
      } !#")
    n1$yAxis(axisLabel='Course Success Rate (%)', width=50)
    return(n1)
  })
}

shinyApp(ui = ui, server = server)