
library(shiny)
library(tidyverse)
library(maps)
library(shinydashboard)

usa_map <- map_data("state")
summary_tab <- read.csv("state_summary.csv")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Redistricting through Machine Learning"),
  
  # Sidebar with a slider input for number of bins 
  sidebarPanel(
    selectInput("section_select", "Choose a region:",
                c("West" = "west",
                  "Southwest" = "southwest",
                  "Midwest" = "midwest",
                  "Northeast" = "northeast",
                  "Southeast" = "southeast",
                  "None selected" = "none"),
                selected = "none"),
    verbatimTextOutput("information"), 
    plotOutput("summaryPlot")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("mapPlot", dblclick="dblclickMap", click="clickSummary", hover ="hoverStats"),
       plotOutput("zoomPlot")
       
    )
  )
)
