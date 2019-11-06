library(choroplethr)
library(choroplethrMaps)
library(ggplot2)

europe <- read.csv("data/europe.csv", header=TRUE)
europe$mapColour <- 0

neighbours <- read.csv("data/neighbours.csv", header = FALSE)
colnames(neighbours)[1] <- "Country"

shinyServer(
  function(input, output) {
  
    source('tab1.R', local = TRUE)
    source('tab2.R', local = TRUE)
    source('tab3.R', local = TRUE)
    source('tab4.R', local = TRUE)
  }
)