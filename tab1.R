getDataFrame <- reactive({
  
  # Extract user input
  selectedEconomyIndicator <- input$economyIndicatorSelection
  
  newEurope <- europe
  
  #We rename the appropriate column to "value" in order to be able to distinguish it
  if (selectedEconomyIndicator == "GDP")
    names(newEurope)[names(newEurope) == 'GDP'] <- 'EconomyIndicator'
  else if (selectedEconomyIndicator == "Inflation")
    names(newEurope)[names(newEurope) == 'Inflation'] <- 'EconomyIndicator'
  else if (selectedEconomyIndicator == "Unemployment")
    names(newEurope)[names(newEurope) == 'Unemployment'] <- 'EconomyIndicator'
  else if (selectedEconomyIndicator == "Life.expect")
    names(newEurope)[names(newEurope) == 'Life.expect'] <- 'EconomyIndicator'
  
  newEurope
})

output$rangeSlider <- renderUI({
  
  filteredEurope <- getDataFrame()
  minRange <- min(filteredEurope$EconomyIndicator)
  maxRange <- max(filteredEurope$EconomyIndicator)
  
  sliderInput("range",
              label = "Choose the range:",
              min = minRange,
              max = maxRange,
              value = c(minRange, maxRange))
})

output$mapExploreEurope <- renderPlot({
  
  filteredDataFrame <- getDataFrame()
  
  sliderMin <- input$range[1]
  sliderMax <- input$range[2]
  if (is.null(sliderMin)) {
    sliderMin <- min(filteredDataFrame$EconomyIndicator)
  }
  if (is.null(sliderMax)) {
    sliderMax <- max(filteredDataFrame$EconomyIndicator)
  }
  
  for(i in 1:nrow(filteredDataFrame)) {
    
    isLowerThanMin <- filteredDataFrame$EconomyIndicator[i] < sliderMin
    isHigherThanMax <- filteredDataFrame$EconomyIndicator[i] > sliderMax
    
    if(isLowerThanMin | isHigherThanMax) {
      filteredDataFrame$EconomyIndicator[i] <- 0
    }
  }
  
  # Render plot
  targetCountries <- tolower(filteredDataFrame$Country)
  
  preparedDataFrame<-data.frame(region = targetCountries, value = filteredDataFrame$EconomyIndicator)
  preparedDataFrame$region<-as.character(preparedDataFrame$region)
  
  data(country.map)
  data(country.regions)
  
  gg <- country_choropleth(preparedDataFrame, legend="%", num_colors=1, zoom = targetCountries)
  gg <- gg + xlim(-31.266001, 43.869301)
  gg <- gg + ylim(34.636311, 73.008797)
  gg <- gg + coord_map("lambert", lat0=1.636311, lat1=7.008797)
  gg <- gg + scale_fill_continuous(low = "white", high = "red", na.value = "red")
  gg
})