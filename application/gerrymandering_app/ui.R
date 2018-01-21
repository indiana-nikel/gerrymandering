
which_state <- function(mapData, long, lat) {
  # This function decide the state being clicked. 
  #
  # Args:
  #   mapData: The map data has a column "long" and a column "lat" to determine
  #       state borders. 
  #   long, lat: longitude and latitude of the clicked point. They are actually
  #       input$clickMap$x and input$clickMap$y assuming click = "clickMap".
  #
  # Returns: 
  #   The name of the state containing the point (long, lat).
  
  # calculate the difference in long and lat of the border with respect to this point
  mapData$long_diff <- mapData$long - long
  mapData$lat_diff <- mapData$lat - lat
  
  # only compare borders near the clicked point to save computing time
  mapData <- mapData[abs(mapData$long_diff) < 20 & abs(mapData$lat_diff) < 15, ]
  
  # calculate the angle between the vector from this clicked point to border and c(1, 0)
  vLong <- mapData$long_diff
  vLat <- mapData$lat_diff
  mapData$angle <- acos(vLong / sqrt(vLong^2 + vLat^2))
  
  # calculate range of the angle and select the state with largest range
  rangeAngle <- tapply(mapData$angle, mapData$region, function(x) max(x) - min(x))
  return(names(sort(rangeAngle, decreasing = TRUE))[1])
}

library(shiny)
library(tidyverse)

usa_map <- map_data("state")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Maps"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("mapPlot", click="clickMap"),  
       plotOutput("zoomPlot")
    )
  )
))
