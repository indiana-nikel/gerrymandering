
library(shiny)
library(tidyverse)
library(maps)
library(shinydashboard)
library(USAboundaries)

dashboardPage(
  
  dashboardHeader(title="Redistricting through Machine Learning", titleWidth = 450),

  dashboardSidebar(
    radioButtons("section_select", "Choose a region:",
                c("West" = "west",
                  "Southwest" = "southwest",
                  "Midwest" = "midwest",
                  "Northeast" = "northeast",
                  "Southeast" = "southeast",
                  "All" = "all"),
                selected = "all")
    ),
    
  dashboardBody(
    fluidRow(
      tabBox(
        title="Interactive Map", width=12,
        tabPanel("Select a state",
          plotOutput("mapPlot", 
                     click="clickMap",
                     dblclick="dblclickMap"
                     )
            ),
        tabPanel("See your state",
          plotOutput("zoomPlot")
        )
      )
    ),
    # fluidRow(
    #   valueBoxOutput("stateBox"),
    #   valueBoxOutput("popBox"),
    #   valueBoxOutput("seatBox"),
    #   valueBoxOutput("pop_seatBox")
    # ),
    fluidRow(
      column(width=4,
        box(
          title="Scatter Plot", width=NULL, solidHeader = TRUE,
          plotOutput("scatterPlot")
        )
      ),
      column(width=3, 
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

