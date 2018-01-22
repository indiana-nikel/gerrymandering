
library(shiny)
library(tidyverse)
library(maps)

usa_map <- map_data("state")
summary_tab <- read.csv("state_summary.csv")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Redistricting through Machine Learning"),
  
  # Sidebar with a slider input for number of bins 
  sidebarPanel(
    selectInput("state_select", "Choose a state:",
                unique(usa_map$region),
                selected="oregon"),
    verbatimTextOutput("information"), 
    plotOutput("plotSummary")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("mapPlot", dblclick="clickMap", click="clickSummary", hover ="hoverStats"),
       plotOutput("zoomPlot")
       
    )
  )
)
