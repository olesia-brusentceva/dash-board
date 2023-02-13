ChooseIndicatorListUI <- function(id) {
  ns <- NS(id)
  fluidPage(
    theme = bs_theme(version = 4, bootswatch = "minty"),
    fluidRow(
      selectizeInput(
        inputId = ns('searchIndicator'),
        label = 'Select Indicator',
        choices = WDI_Indicators$Indicator.Name,
        selected = "GDP per capita (constant 2015 US$)",
        multiple = TRUE,
        # allow for multiple inputs
        options = list(create = FALSE) # if TRUE, allows newly created inputs
      )
    ),
    fluidRow(
      helpText(
        "Start typing Indicator name or select it out of the list. You can select up to 6 indicators to be displayed. If you select an indicator not applicable for chosen country or date range it will not be displayed. "
      )
    ),
    hr()
  )
}

ChooseIndicatorListServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$text = reactive({
                   WDI_Indicators[WDI_Indicators$Indicator.Name %in% input$searchIndicator, 2]
                 })
               })
}
