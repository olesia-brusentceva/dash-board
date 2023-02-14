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
      box(plotOutput("plot1", height = 250)),
      box(radioGroupButtons(
        inputId = "change_plot",
        label = "Visualize:",
        choices = c(
          `<i class='fa fa-bar-chart'></i>` = "line",
          `<i class='fa fa-pie-chart'></i>` = "point"
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
      ggplot()+
        geom_line(splotdata, mapping = aes(year, value, colour = country)) +
        ylab("value") +
        theme_classic() +
        scale_color_grey()
      return(plot)
      
    } else {
      ggplot()+
        geom_point(splotdata, mapping = aes(year, value, colour = country)) +
        ylab("value") +
        theme_classic() +
        scale_color_grey()
      return(plot)
    }
    
  })
}
shinyApp(ui, server)
