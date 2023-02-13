ChooseDateUI <- function(id) {
  ns <- NS(id)
  fluidPage(
    fluidRow(
      sliderInput(ns("daterange"), "Select date range:",
                     min = 1960,
                     max  = 2023,
                     value = c(2007,2023),
                     sep="")
      ),
    fluidRow(
      helpText("Select date range to be displayed")
    ),
    hr()
  )
}

ChooseDateServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$text = reactive({input$daterange})
    }
  )
}
