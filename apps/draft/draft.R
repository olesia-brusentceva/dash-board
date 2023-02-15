library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(ggplot2)
library(dplyr)

source("apps/data/get-data.r")
source("apps/choose-country-list/choose-country-list.R")
source("apps/choose-indicator/choose-indicator.R")
source("apps/choose-date/choose-date.R")

# APP
ui <- dashboardPage(
  dashboardHeader(title = "ShinyWidget Plot Change"),
  dashboardSidebar(
    ChooseCountryListUI("1"),
    ChooseIndicatorListUI("2"),
    ChooseDateUI("3")
  ),
  dashboardBody(
    fluidRow(
      box(plotOutput("plot1", brush = "plot_brush", height = 250),
          tableOutput("data")),
      div(radioGroupButtons(
        inputId = "change_plot",
        label = "Visualize:",
        choices = c(
          `<i class='fa fa-line-chart'></i>` = "line",
          `<i class='fa fa-circle fa-2xs'></i>` = "scatter"
        ),
        justified = TRUE,
        selected = "line"
      ))
    )
  )
)

server <- function(input, output) {
  
  selectData <- reactive({
    WDI(
      country = ChooseCountryListServer("1")(),
      indicator = ChooseIndicatorListServer("2")(),
      start = ChooseDateServer("3")()[1],
      end = ChooseDateServer("3")()[2]
    )
  })

  output$plot1 <- renderPlot({
    plotdata<-melt(setDT(selectData()),
                   id.vars = c("country","iso2c","iso3c","year"),
                   variable.name = "indicator")
    splotdata <- plotdata[dim(plotdata)[1]:1,]
    
    if (input$change_plot %in% "line") {
      plot<-ggplot()+
        geom_line(splotdata, mapping = aes(year, value, colour = country)) +
        ylab("value") +
        theme_classic() +
        scale_colour_brewer(palette = "RdPu")
      return(plot)
      
    } else {
      plot<-ggplot()+
        geom_area(splotdata, mapping = aes(year, value, fill = country)) +
        ylab("value") +
        theme_classic()+
        scale_fill_brewer(palette = "RdPu")
      return(plot)
    }
    
  }, res = 96)
  output$data <- renderTable({
    
    plotdata<-melt(setDT(selectData()),
                   id.vars = c("country","iso2c","iso3c","year"),
                   variable.name = "indicator")
    
    brushedPoints(plotdata, input$plot_brush)
  })
}
shinyApp(ui, server)
