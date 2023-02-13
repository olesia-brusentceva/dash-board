ChooseCountryListUI <- function(id) {
  ns <- NS(id)
  fluidPage(
    theme = bs_theme(version = 4, bootswatch = "minty"),
    fluidRow(
      selectizeInput(
        inputId = ns('searchCountry'),
        label = strong('Select Country'),
        choices = WDI_Countries$Country.Name,
        selected = c("Ukraine","United States"),
        multiple = TRUE,
        # allow for multiple inputs
        options = list(create = FALSE) # if TRUE, allows newly created inputs
      )
    ),
    fluidRow(
      helpText(
        "Start typing country or region name or select it on the map. You can select any number of countries or WB defined zones. "
      )
    ),
    hr()
  )
}

ChooseCountryListServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$text = reactive({
                   WDI_Countries[WDI_Countries$Country.Name %in% input$searchCountry, 2]
                 })
               })
}
