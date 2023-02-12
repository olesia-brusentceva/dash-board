ChooseIndicatorListUI <- function(id) {
  ns <- NS(id)
  shinyUI(
    selectizeInput(
      inputId = ns('searchIndicator'),
      label = 'Select Indicator',
      choices = WDI_Indicators$Indicator.Name,
      selected = NULL,
      multiple = TRUE, # allow for multiple inputs
      options = list(create = FALSE) # if TRUE, allows newly created inputs
    )
  )
}

ChooseIndicatorListServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$text = reactive({WDI_Indicators[WDI_Indicators$Indicator.Name %in% input$searchIndicator,2]})
    }
  )
}
