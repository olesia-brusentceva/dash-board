ui <- fluidPage(
  tags$head(tags$style(HTML("
    .leaflet-container {
    background-color:rgba(255,0,0,0.0);}
    "))
  ),
  theme = bs_theme(version = 4, bootswatch = "minty"),
  shinydashboard::box(
    width = 12,
    column(
      width = 2,
      selectizeInput(
        inputId = 'searchCountry',
        label = strong('Select Country'),
        choices = WDI_Countries$Country.Name,
        selected = c("Ukraine","United States"),
        multiple = TRUE,
        # allow for multiple inputs
        options = list(create = FALSE))
    ),
    column(width = 10,
           leafletOutput(outputId = "myMap",
                         height = 850))
  )
)


server <- function(input, output, session) {
  foundational.map <- reactive({
    leaflet() %>%
      addPolygons(data = WB_CountryPolygons,
                  layerId = WB_CountryPolygons$NAME_EN,
                  group = "click.list", 
                  fill = TRUE,
                  fillColor = "#f8f4f4",
                  fillOpacity = 1,
                  weight=1,
                  color = "#5a5a5a",
                  highlightOptions = highlightOptions(weight= 4,
                                                      color = "#80c4ac",
                                                      bringToFront = T
                                                      ),
                  label = as.character(WB_CountryPolygons$NAME_EN),
                  labelOptions = labelOptions(noHide = FALSE)
                  
      )
  })
  
  output$myMap <- renderLeaflet({
    foundational.map()
    
  })
  
  output$text = reactive({WDI_Countries[WDI_Countries$Country.Name %in% input$searchCountry, 2]})
  
  click.list <- reactiveValues(ids = vector()) 
  
  # observe where the user clicks on the leaflet map
  # during the Shiny app session
  # Courtesy of two articles:
  # https://stackoverflow.com/questions/45953741/select-and-deselect-polylines-in-shiny-leaflet
  # https://rstudio.github.io/leaflet/shiny.html
  
  observeEvent(input$myMap_shape_click, {
    
    # store the click(s) over time
    click <- input$myMap_shape_click
    
    # store the polygon ids which are being clicked
    click.list$ids <- c(click.list$ids, click$id) 
    
    # filter the spatial data frame
    # by only including polygons
    # which are stored in the click.list$ids object
    lines.of.interest <-
      WB_CountryPolygons[which(WB_CountryPolygons$NAME_EN %in% click.list$ids) ,]
    
    if (is.null(click$id)) {
      req(click$id)
    }
    else if (!click$id %in% lines.of.interest@data$id) {
      # call the leaflet proxy
      leafletProxy(mapId = "myMap") %>%
        addPolygons(
          data = lines.of.interest,
          layerId = lines.of.interest@data$id,
          fill = TRUE,
          fillColor = "#f8949c",
          fillOpacity = 1,
          weight= 4,
          color = "#80c4ac"
        )
      updateSelectizeInput(session,"searchCountry", selected = c(input$searchCountry,click.list$ids))
    }
  })

  
  observeEvent(input$clearHighlight, {
    output$myMap <- renderLeaflet({
      click.list$ids <- NULL
      foundational.map()
      
    })
    
  })
  
}

## run shinyApp ##
shiny::shinyApp(ui = ui, server = server)

# end of script #
