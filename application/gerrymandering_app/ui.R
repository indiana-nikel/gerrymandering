
library(shiny)
library(tidyverse)
library(maps)
library(shinydashboard)
library(USAboundaries)

dashboardPage(
  
  dashboardHeader(title="Redistricting through Machine Learning", titleWidth = 450),

  dashboardSidebar(
    selectInput("section_select", "Choose a region:",
                c("West" = "west",
                  "Southwest" = "southwest",
                  "Midwest" = "midwest",
                  "Northeast" = "northeast",
                  "Southeast" = "southeast",
                  "None" = "none"),
                selected = "none")
    ),
    
  dashboardBody(
    fluidRow(
      box(
        title="Interactive Map", width=6, solidHeader = TRUE,
        plotOutput("mapPlot", dblclick="dblclickMap", click="clickSummary", hover ="hoverStats")
        ),
      box(
        title="Zoomed-In Map", witdth=6, solidHeader = TRUE,
        plotOutput("zoomPlot")
      )
    ),
    fluidRow(
      column(width=4,
        box(
          title="Scatter Plot", width=NULL, solidHeader = TRUE,
          plotOutput("scatterPlot")
        )
      ),
      column(width=4, 
        valueBoxOutput("stateBox", width=NULL),
        valueBoxOutput("popBox", width=NULL),
        valueBoxOutput("seatBox", width=NULL),
        valueBoxOutput("pop_seatBox", width=NULL)
      ),
      column(width=4, 
        box(
          title="Histogram", width=NULL, solidHeader = TRUE,
          plotOutput("histPlot")
        )
      )
    )
  ),
skin="black")

