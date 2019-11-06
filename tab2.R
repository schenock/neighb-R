
output$mapEurope <- renderPlot({
  
  # Extract user input
  selectedCountry <- input$countrySelection
  selectedIndicator <- input$indicatorSelection
  
  neigboursOfSelected <- subset(neighbours, Country == selectedCountry)
  
  neighboursIndexList <- c(neigboursOfSelected[1, 2:8])
  
  # Fill mapColour with neighbour's values
  for(i in 1:length(neighboursIndexList)) {
    currentNeighbourIndex <- as.numeric(neighboursIndexList[[i]])
    
    if(selectedIndicator == "GDP")
      europe$mapColour[currentNeighbourIndex] <- europe$GDP[currentNeighbourIndex]
    
    else if(selectedIndicator == "Inflation")
      europe$mapColour[currentNeighbourIndex] <- europe$Inflation[currentNeighbourIndex]
    
    else if(selectedIndicator == "Unemployment")
      europe$mapColour[currentNeighbourIndex] <- europe$Unemployment[currentNeighbourIndex]
    
    else if(selectedIndicator == "Life.expect")
      europe$mapColour[currentNeighbourIndex] <- europe$Life.expect[currentNeighbourIndex]
  }
  
  indexOfSelectedCountry <- match(selectedCountry, europe$Country)
  europe$mapColour[indexOfSelectedCountry] <- NA
  
  # Render plot
  preparedDataFrame<-data.frame(region=tolower(europe$Country), value=europe$mapColour)
  preparedDataFrame$region<-as.character(preparedDataFrame$region)
  
  data(country.map)
  data(country.regions)
  
  target <- tolower(europe$Country)
  
  gg <- country_choropleth(preparedDataFrame, num_colors=1, zoom = target)
  gg <- gg + xlim(-31.266001, 43.869301)
  gg <- gg + ylim(34.636311, 73.008797)
  gg <- gg + coord_map("lambert", lat0=1.636311, lat1=7.008797)
  gg <- gg + scale_fill_continuous(low = "#eff3ff", high = "#084594", na.value = "red")
  gg
})

output$barPlot <- renderPlot({
  
  # Extract user input
  selectedCountry <- input$countrySelection
  selectedIndicator <- input$indicatorSelection
  
  # Get neighbours values and put them in europe$mapColour
  neigboursOfSelected <- subset(neighbours, Country == selectedCountry)
  neighboursIndexList <- c(neigboursOfSelected[1, 2:8])
  
  names <- list()
  # Fill colouring column
  for(i in 1:length(neighboursIndexList)) {
    currentNeighbourIndex <- as.numeric(neighboursIndexList[[i]])
    
    if(selectedIndicator == "GDP")
      europe$mapColour[currentNeighbourIndex] <- europe$GDP[currentNeighbourIndex]
    
    else if(selectedIndicator == "Inflation")
      europe$mapColour[currentNeighbourIndex] <- europe$Inflation[currentNeighbourIndex]
    
    else if(selectedIndicator == "Unemployment")
      europe$mapColour[currentNeighbourIndex] <- europe$Unemployment[currentNeighbourIndex]
    
    else if(selectedIndicator == "Life.expect") 
      europe$mapColour[currentNeighbourIndex] <- europe$Life.expect[currentNeighbourIndex]
    
    names[[length(names) + 1]] <- neighbours$Country[currentNeighbourIndex]
  }
  
  # Add value for the selected country
  colorVector <- c(rep("grey", length(neighboursIndexList) + 1))
  indexOfSelectedCountry <- match(selectedCountry, europe$Country)
  
  if(selectedIndicator == "GDP")
    europe$mapColour[indexOfSelectedCountry] <- europe$GDP[indexOfSelectedCountry]
  else if(selectedIndicator == "Inflation")
    europe$mapColour[indexOfSelectedCountry] <- europe$Inflation[indexOfSelectedCountry]
  else if(selectedIndicator == "Unemployment")
    europe$mapColour[indexOfSelectedCountry] <- europe$Unemployment[indexOfSelectedCountry]
  else if(selectedIndicator == "Life.expect")
    europe$mapColour[indexOfSelectedCountry] <- europe$Life.expect[indexOfSelectedCountry]
  
  if(selectedIndicator == "GDP")
    valueForSelected <- europe$GDP[indexOfSelectedCountry]         
  else if(selectedIndicator == "Inflation")
    valueForSelected <- europe$Inflation[indexOfSelectedCountry]
  else if(selectedIndicator == "Unemployment")
    valueForSelected <- europe$Unemployment[indexOfSelectedCountry]
  else if(selectedIndicator == "Life.expect")
    valueForSelected <- europe$Life.expect[indexOfSelectedCountry]
  
  neighboursValues <- europe$mapColour[europe$mapColour != 0 ]
  indexOfSelectedForColouring <- match(valueForSelected, neighboursValues) # put this in ifelse
  
  colorVector[indexOfSelectedForColouring[1]] <- "red"
  
  # Render a barplot
  if(selectedIndicator == "GDP")               selected <- europe$GDP
  else if(selectedIndicator == "Inflation")    selected <- europe$Inflation
  else if(selectedIndicator == "Unemployment") selected <- europe$Unempl
  else if(selectedIndicator == "Life.expect")  selected <- europe$Life.expect
  
  # Get values for bar plot
  europe$barValues <- europe$mapColour
  europeBarSubset <- subset(europe, europe$barValues != 0)

  op <- par(mar = c(7,4,1,2) + 0.1)
  
  barplot(rep(NA,length(colorVector)),ylim=c(min(0,selected),max(selected)),las=2)
  abline(h=mean(selected), col = "grey")
  
  barplot(europeBarSubset$barValues, 
          names.arg = europeBarSubset$Country,
          col = colorVector,
          add = T,
          las=2)
  par(op)
})

output$text1 <- renderText({ 
  
  # LEAVE ONLY THIS LINE BEFORE RELEASE
  paste("", input$countrySelection)
})

