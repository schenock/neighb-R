output$scatter <- renderPlot({
  
  # Extract user input
  xChoice <- input$xAxisChoice
  yChoice <- input$yAxisChoice
  sizeChoice <- input$sizeAxisChoice
  colorChoice <- input$colorAxisChoice
  
  aesData <- aes(x=europe[,xChoice], y=europe[,yChoice],
                 size=europe[,sizeChoice],
                 color=europe[,colorChoice])
  
  lab <- labs(x= xChoice , y=yChoice, size=sizeChoice, color=colorChoice)
  
  scatterPlot <- ggplot(europe, aesData)
  scatterPlot <- scatterPlot + ggtitle("Europe economic analysis") + lab
  scatterPlot <- scatterPlot + geom_point(data = europe, alpha = 0.8) + scale_size_continuous(range = c(3,12))
  
  scatterPlot <- scatterPlot + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                              panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
  scatterPlot
})
