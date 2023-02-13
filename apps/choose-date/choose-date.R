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
      helpText("Select date range to be displayed. If date range contains non-existent values (NAs), f.e. Ukraine pre 1991, those would be ommited")
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
