ChooseDateUI <- function(id) {
  ns <- NS(id)
  fluidPage(
    theme = bs_theme(version = 4, bootswatch = "minty"),
    fluidRow(
      sliderInput(
        ns("daterange"),
        label = strong("Select date range"),
        min = 1960,
        max  = 2023,
        value = c(1995, 2023),
        sep = "",
        width = "100%"
      )
    ),
    fluidRow(
      helpText(
        "Select date range to be displayed. If date range contains non-existent values (NAs), f.e. Ukraine pre 1991, those would be ommited"
      )
    ),
    hr()
  )
}

ChooseDateServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$text = reactive({
                   input$daterange
                 })
               })
}
