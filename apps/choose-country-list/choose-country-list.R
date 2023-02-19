ChooseCountryListUI <- function(id, all.choices) {
  ns <- NS(id)
  fluidPage(
    theme = bs_theme(version = 4, bootswatch = "minty"),
    fluidRow( 
      selectizeInput(
        inputId = ns('searchCountry'),
        label = strong('Select Country'),
        choices = all.choices,
        selected = c("Ukraine","United States"),
        multiple = FALSE,
        options = list(create = FALSE),
        width = "100%"
      )
    ),
    fluidRow(
      helpText(
        "Start typing country or region name. You may select only one country"
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
