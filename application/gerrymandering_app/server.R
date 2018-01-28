
# Pulled from http://playshiny.com/
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

# Pulled from http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html
no_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

library(shiny)
library(tidyverse)
library(maps)
library(shinydashboard)
library(USAboundaries)

summary_tab <- read.csv("state_summary.csv")

full_map <- left_join(map_data("state"), summary_tab, by=c("region"="states"))
initial <- full_map  %>% filter(region=="oregon")
initial_filter <- summary_tab %>% filter(states == "oregon") 

full_county <- left_join(map_data("county"), summary_tab, by=c("region"="states"))
county_sub <- subset(full_county, region == "oregon")

plotZoomInitial <- ggplot(initial, aes(x = long, y = lat, group = group)) + 
  geom_polygon(fill="grey", color="black") + 
  geom_polygon(data = county_sub, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA) + 
  coord_fixed(1.3) +
  guides(fill = FALSE) + 
  theme_classic() +
  no_axes + 
  xlab("Latitude") + 
  ylab("Longitude") + 
  labs(title="oregon")

plotSummaryHist <- ggplot(summary_tab, aes(x = pop)) + 
  geom_histogram() + 
  guides(fill = FALSE) + 
  theme_classic() + 
  xlab("Population") + 
  ylab("Frequency") + 
  labs(title="Summary Plot")

plotSummaryScatter <- ggplot(summary_tab, aes(x = pop, y = seats)) + 
  geom_point() + 
  guides(fill = FALSE) + 
  theme_classic() + 
  xlab("Population") + 
  ylab("Congressional Seats") + 
  labs(title="Congressional Seats \n Based on Population")

plotter <- function(section) {
  if (section == "west"){ 
    sub_map <- full_map %>% filter(section=="west")
    
    plotMap <- ggplot(sub_map, aes(x = long, y = lat, group = group, fill=region)) + 
      geom_polygon(color="white") + 
      coord_fixed(1.3) + 
      guides(fill = FALSE) + 
      theme_classic() +
      no_axes + 
      xlab("Latitude") + 
      ylab("Longitude") + 
      labs(title="United States of America\nWest")
  } else if (section == "southwest"){ 
    sub_map <- full_map %>% filter(section=="southwest")
    
    plotMap <- ggplot(sub_map, aes(x = long, y = lat, group = group, fill=region)) + 
      geom_polygon(color="white") + 
      coord_fixed(1.3) + 
      guides(fill = FALSE) + 
      theme_classic() +
      no_axes + 
      xlab("Latitude") + 
      ylab("Longitude") + 
      labs(title="United States of America\nSouthwest")
  } else if (section == "midwest"){ 
    sub_map <- full_map %>% filter(section=="midwest")
    
    plotMap <- ggplot(sub_map, aes(x = long, y = lat, group = group, fill=region)) + 
      geom_polygon(color="white") + 
      coord_fixed(1.3) + 
      guides(fill = FALSE) + 
      theme_classic() +
      no_axes + 
      xlab("Latitude") + 
      ylab("Longitude") + 
      labs(title="United States of America\nMidwest")
  } else if (section == "northeast"){ 
    sub_map <- full_map %>% filter(section=="northeast")
    
    plotMap <- ggplot(sub_map, aes(x = long, y = lat, group = group, fill=region)) + 
      geom_polygon(color="white") + 
      coord_fixed(1.3) + 
      guides(fill = FALSE) + 
      theme_classic() +
      no_axes + 
      xlab("Latitude") + 
      ylab("Longitude") + 
      labs(title="United States of America\nNortheast")
  } else if (section == "southeast"){ 
    sub_map <- full_map %>% filter(section=="southeast")
    
    plotMap <- ggplot(sub_map, aes(x = long, y = lat, group = group, fill=region)) + 
      geom_polygon(color="white") + 
      coord_fixed(1.3) + 
      guides(fill = FALSE) + 
      theme_classic() +
      no_axes + 
      xlab("Latitude") + 
      ylab("Longitude") + 
      labs(title="United States of America\nSoutheast")
  } else {
    plotMap <- ggplot(full_map, aes(x = long, y = lat, group = group, fill=region)) + 
      geom_polygon(color="white") + 
      coord_fixed(1.3) + 
      guides(fill = FALSE) + 
      theme_classic() +
      no_axes + 
      xlab("Latitude") + 
      ylab("Longitude") + 
      labs(title="United States of America")
  }
  return(plotMap)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$mapPlot <- renderPlot({
    plotter(input$section_select) + 
      geom_polygon(data = full_map[full_map$region == "oregon",], color = "black", size = 1)
  })
  
  output$zoomPlot <- renderPlot({
    plotZoomInitial
  })
  
  output$scatterPlot <- renderPlot({
    plotSummaryScatter
  })
  
  output$histPlot <- renderPlot({
    plotSummaryHist
  })
  
  output$stateBox <- renderValueBox({
    valueBox(
      paste0(capitalize(initial_filter$states)), "State", icon = icon("flag"),
      color = "red"
    )
  })
  
  output$popBox <- renderValueBox({
    valueBox(
      paste0(initial_filter$pop), "Population", icon = icon("id-card-o"),
      color = "yellow"
    )
  })
  
  output$seatBox <- renderValueBox({
    valueBox(
      paste0(initial_filter$seats), "Congressional Seats", icon = icon("institution"),
      color = "green"
    )
  })
  
  output$pop_seatBox <- renderValueBox({
    valueBox(
      paste0(initial_filter$pop_per_seat), "Population per Seat", icon = icon("male"),
      color = "blue"
    )
  })
  
  observeEvent(input$clickMap, {
    xClick <- input$clickMap$x
    yClick <- input$clickMap$y
    state <- which_state(full_map, xClick, yClick)
    zoom <- zoom_state(full_map, state)
    state_zoom <- full_map %>% filter(region==state)
    county_sub <- subset(full_county, region==state)
    
    summary_filter <- summary_tab %>% filter(states == state) 
    
    output$mapPlot <- renderPlot({
          if (input$section_select == "all"){
            plotter(input$section_select) +
              geom_polygon(data = full_map[full_map$region == state,], color = "black", size = 1)
          } else {
            sub_map <- full_map %>% filter(section==input$section_select)
            plotter(input$section_select) +
              geom_polygon(data = sub_map[sub_map$region == state,], color = "black", size = 1)
          }
        })
    
    
    
    output$stateBox <- renderValueBox({
      valueBox(
        paste0(capitalize(summary_filter$states)), "State", icon = icon("list"),
        color = "red"
        )
      })
    output$popBox <- renderValueBox({
      valueBox(
        paste0(summary_filter$pop), "Population", icon = icon("list"),
        color = "yellow"
      )
    })
    output$seatBox <- renderValueBox({
      valueBox(
        paste0(summary_filter$seats), "Congressional Seats", icon = icon("list"),
        color = "green"
      )
    })
    output$pop_seatBox <- renderValueBox({
      valueBox(
        paste0(summary_filter$pop_per_seat), "Population per Seat", icon = icon("list"),
        color = "blue"
      )
    })
    })
  
  observeEvent(input$dblclickMap, {
    xClick <- input$dblclickMap$x
    yClick <- input$dblclickMap$y
    state <- which_state(full_map, xClick, yClick)
    zoom <- zoom_state(full_map, state)
    state_zoom <- full_map %>% filter(region==state)
    county_sub <- subset(full_county, region==state)

    plotZoom <- ggplot(state_zoom, aes(x = long, y = lat, group = group)) +
      geom_polygon(fill="grey", color="black") +
      geom_polygon(data = county_sub, fill = NA, color = "white") +
      geom_polygon(color = "black", fill = NA) +
      coord_fixed(1.3) +
      guides(fill = FALSE) +
      theme_classic() +
      no_axes +
      xlab("Latitude") +
      ylab("Longitude") +
      labs(title=state)

    output$zoomPlot <- renderPlot({

      plotZoom

      })
    })
})
