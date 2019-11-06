
kmeansClustering <- reactive({
  
  columnsSelected <- c()
  if(input$checkboxGDP)
    columnsSelected <- c(columnsSelected, "GDP")
  if(input$checkboxInflation)
    columnsSelected <- c(columnsSelected, "Inflation")
  if(input$checkboxMilitary)
    columnsSelected <- c(columnsSelected, "Military")
  if(input$checkboxUnemployment)
    columnsSelected <- c(columnsSelected, "Unemployment")
  
  kmeansClusters <- NULL
  if(length(columnsSelected) != 0) {
    kmeansClusters <- kmeans(europe[columnsSelected], input$kChoice)
  }
  kmeansClusters
})

output$clusterPlot <- renderPlot({
  
  kmeansResult <- kmeansClustering()
  if(!is.null(kmeansResult)) {
    europe$Cluster <- as.factor(kmeansResult$cluster)
    
    xAxis <- input$xAxisChoice
    yAxis <- input$yAxisChoice
    lab <- labs(x= xAxis , y=yAxis, color="Cluster")
    
    clusterPlot <- ggplot(europe, aes(europe[xAxis], europe[yAxis], color = europe$Cluster)) + geom_point(alpha = 0.8, size = 3.5) + scale_size_discrete(range = c(8,10))
    clusterPlot <- clusterPlot + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                                                    panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
    clusterPlot <- clusterPlot + lab + ggtitle("Grouping of countries")
    clusterPlot
  } else {
    plot.new()
  }
})

output$clusterMap <- renderPlot({
  
  kmeansResult <- kmeansClustering()
  if(!is.null(kmeansResult)) {
    europe$Cluster <- as.factor(kmeansResult$cluster)
  
    # Render plot
    preparedDataFrame <- data.frame(region=tolower(europe$Country), value=europe$Cluster)
    preparedDataFrame$region <- as.character(preparedDataFrame$region)
    
    data(country.map)
    data(country.regions)
    
    numberOfColors <- as.numeric(input$kChoice)
    
    gg <- country_choropleth(preparedDataFrame, num_colors=9, zoom = tolower(europe$Country))
    gg <- gg + xlim(-31.266001, 43.869301)
    gg <- gg + ylim(34.636311, 73.008797)
    gg <- gg + coord_map("lambert", lat0=1.636311, lat1=7.008797)
    gg <- gg + scale_color_discrete(h = 250, direction = 1, l = 80,c = 200)
    gg <- gg + scale_fill_discrete(h.start = 0, c = 200, l = 90)
    gg
  } else {
    plot.new()
  }
})
