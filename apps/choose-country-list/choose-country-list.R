ChooseCountryListUI <- function(id) {
  ns <- NS(id)
  shinyUI(
    selectizeInput(
      inputId = ns('searchCountry'),
      label = 'Select Country',
      choices = WDI_Countries$Country.Name,
      selected = NULL,
      multiple = TRUE, # allow for multiple inputs
      options = list(create = FALSE) # if TRUE, allows newly created inputs
    )
  )
}

ChooseCountryListServer <- function(id) {
  moduleServer(
    id,
  function(input, output, session) {
    output$text = reactive({WDI_Countries[WDI_Countries$Country.Name %in% input$searchCountry,2]})
  }
  )
}
