# ui.R

shinyUI(navbarPage("EU Economic Analysis",

  tabPanel("Explore Europe",
    column(3,
      selectInput("economyIndicatorSelection", label = h4("Choose indicator"), 
                  choices = c("GDP", "Inflation", "Unemployment", "Life.expect"), 
                  selected = 2, width = 150),
      htmlOutput("rangeSlider")
    ),
    column(6,
      plotOutput("mapExploreEurope", hover = "plot_hover")
    )
  ),

  tabPanel("Compare economic indicators",

    fluidRow(
      column(2,{}),
      column(2,{}),
      column(2,{}),
      column(2, h3(textOutput("text1"),style="float:right"))
    ),

    fluidRow(
          column(1,{}),
          column(3,
             selectInput("countrySelection", label = h4("Choose country"), 
                         choices = europe$Country, 
                         selected = 5, width = 150),
             selectInput("indicatorSelection", label = h4("Choose indicator"), 
                         choices = c("GDP", "Inflation", "Unemployment", "Life.expect"), 
                         selected = 1, width = 150),
             plotOutput("barPlot", width = 300, height = 300)
             ),
          column(7, plotOutput("mapEurope", hover = "plot_hover"))
    ),
    
    fluidRow()
 ),

  tabPanel("Grouping of countries",
           column(2,
             selectInput("kChoice", label = h4("Number of clusters:"), 
                         choices = c("2", "3", "4", "5", "6"), 
                         selected = "2", width = 170),
             
             checkboxInput("checkboxGDP", "GDP", value = TRUE, width = NULL),
             checkboxInput("checkboxInflation", "Inflation", value = TRUE, width = NULL),
             checkboxInput("checkboxMilitary", "Military", value = TRUE, width = NULL),
             checkboxInput("checkboxUnemployment", "Unemployment", value = TRUE, width = NULL),
             
             selectInput("xAxisChoice", label = h4("X Axis:"), 
                         choices = c("GDP", "Inflation", "Military", "Unemployment"), 
                         selected = "GDP", width = 150),
             
             selectInput("yAxisChoice", label = h4("Y Axis:"), 
                         choices = c("GDP", "Inflation", "Military", "Unemployment"), 
                         selected = "Inflation", width = 150)
           ),
           column(5,
            plotOutput("clusterPlot", width = 750, height = 400)
           ),
           column(1, {}),
           column(2,
             plotOutput("clusterMap", width = 380, height = 280)
           )
  ),
 
  tabPanel("Economic attribute relations", 
           
              column(2,
                selectInput("xAxisChoice", label = h4("X Axis"), 
                            choices = c("GDP", "Inflation", "Unemployment", "Area"), 
                            selected = "GDP", width = 150),
                selectInput("yAxisChoice", label = h4("Y Axis"), 
                            choices = c("GDP", "Inflation", "Unemployment", "Area"), 
                            selected = "Inflation", width = 150),
                selectInput("sizeAxisChoice", label = h4("Size Dimension"), 
                            choices = c("GDP", "Inflation", "Unemployment", "Area"), 
                            selected = "Unemployment", width = 150),
                selectInput("colorAxisChoice", label = h4("Color Dimension"), 
                            choices = c("GDP", "Inflation", "Unemployment", "Area"), 
                            selected = "Area", width = 150)
              ),

              column(8, plotOutput("scatter")),

              column(2, {})
  )
))