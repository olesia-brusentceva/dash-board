ChooseCountryListUI <- function(id) {
  ns <- NS(id)
  fluidPage(
  fluidRow(
    selectizeInput(
      inputId = ns('searchCountry'),
      label = 'Search Country',
      choices = WDI_Countries$Country.Name,
      selected = "Ukraine",
      multiple = TRUE, # allow for multiple inputs
      options = list(create = FALSE) # if TRUE, allows newly created inputs
    )),
  fluidRow(
    helpText("Start typing country or region name or select it on the map")
  ),
  hr()
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
