
which_state <- function(mapData, long, lat) {
  # This function decides the state being clicked. 
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

zoom_state <- function(mapData, state) {
  # This function decides the cartesian coordinates to zoom into.
  #
  # Args:
  #   mapData: The map data has a column "long" and a column "lat" to determine
  #       state borders. 
  #   state: name of the state being zoomed into. Derived from the `which_states()`
  #       function.
  #
  # Returns: 
  #   The limits of the x and y coordinates as (long, lat).
  
  selected_state <- mapData %>% 
    filter(region == state)
  
  xmin <- min(selected_state$long)
  xmax <- max(selected_state$long)
  xrange <- abs(xmax - xmin)
  
  ymin <- min(selected_state$lat)
  ymax <- max(selected_state$lat)
  yrange <- abs(ymax - ymin)
  
  
  lims <- c(xmin, xmax, xrange, ymin, ymax, yrange)
  return(lims)
  
}

library(shiny)
library(tidyverse)
library(rsconnect)

usa_map <- map_data("state")
initial <- map_data("state") %>% filter(region=="oregon")
summary_tab <- read.csv("state_summary.csv")

plotMap <- ggplot(usa_map, aes(x = long, y = lat, group = group, fill=region)) + 
  geom_polygon() + 
  guides(fill = FALSE) + 
  theme_classic() + 
  xlab("Latitude") + 
  ylab("Longitude") + 
  labs(title="United States of America")

plotZoomInitial <- ggplot(initial, aes(x = long, y = lat, group = group, fill="black")) + 
  geom_polygon() + 
  guides(fill = FALSE) + 
  theme_classic() + 
  xlab("Latitude") + 
  ylab("Longitude") + 
  labs(title="oregon")

summary_plot <- ggplot(summary_tab, aes(x = pop)) + 
  geom_histogram() + 
  guides(fill = FALSE) + 
  theme_classic() + 
  xlab("Population") + 
  ylab("Frequency") + 
  labs(title="Summary Plot")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$mapPlot <- renderPlot({
    
    plotMap
    
  })
  
  output$zoomPlot <- renderPlot({
    
    plotZoomInitial
    
  })
  
  output$plotSummary <- renderPlot({
    
    summary_plot <- ggplot(summary_tab, aes(x = pop, y = seats)) + 
      geom_point() + 
      guides(fill = FALSE) + 
      theme_classic() + 
      xlab("Population") + 
      ylab("Congressional Seats") + 
      labs(title="Congressional Seats \n Based on Population")
    summary_plot
    
  })
  
  observeEvent(input$clickSummary, {
    xClick <- input$clickSummary$x
    yClick <- input$clickSummary$y
    state <- which_state(usa_map, xClick, yClick)
    zoom <- zoom_state(usa_map, state)
    
    summary_filter <- summary_tab %>% filter(states == state) 
    
    output$mapPlot <- renderPlot({
      plotMap +
        geom_polygon(data = usa_map[usa_map$region == state,], color = "black")
      })
    
    # output$plotSummary <- renderPlot({
    #   
    #   summary_plot <- ggplot(summary_tab, aes(x = pop, y = seats)) + 
    #     geom_point(data = summary_filter,
    #                size = 6, shape = 1, color = "red") + 
    #     guides(fill = FALSE) + 
    #     theme_classic() + 
    #     xlab("Population") + 
    #     ylab("Congressional Seats") + 
    #     labs(title="Congressional Seats \n Based on Population") + 
    #     theme_minimal()
    #   
    # })
    
      output$information <- renderText({
        paste("State:", summary_filter$states,
              "\nPopulation:", summary_filter$pop, 
              "\nCongressional Seats:", summary_filter$seats, 
              "\nPopulation per Seat:", summary_filter$pop_per_seat)
      })
    })
  
  observeEvent(input$clickMap, {
    xClick <- input$clickMap$x
    yClick <- input$clickMap$y
    state <- which_state(usa_map, xClick, yClick)
    zoom <- zoom_state(usa_map, state)
    data_state <- map_data("state") %>% filter(region==state)
    
    plotZoom <- ggplot(data_state, aes(x = long, y = lat, group = group, fill="black")) + 
      geom_polygon() + 
      guides(fill = FALSE) + 
      theme_classic() + 
      xlab("Latitude") + 
      ylab("Longitude") + 
      labs(title=state)
    
    output$zoomPlot <- renderPlot({
      plotZoom
      }) 
    })
  
  observeEvent(input$hoverStats, {
    xHover <- input$hoverStats$x
    yHover <- input$hoverStats$y
    state <- which_state(usa_map, xHover, yHover)
    zoom <- zoom_state(usa_map, state)
    
    output$mapPlot <- renderPlot(
      plotMap +
        geom_polygon(data = usa_map[usa_map$region == state,], color = "black")
    )
  })
  
})
