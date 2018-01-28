
library(shiny)
library(tidyverse)
library(maps)
library(shinydashboard)
library(USAboundaries)
library(Hmisc)

dashboardPage(
  
  dashboardHeader(title="Redistricting through Machine Learning", titleWidth = 450),

  dashboardSidebar(
    div(p(
    "There are 435 members of the House of Representatives in the United States Congress. Each member is elected by a population represented by equivalent portion of the population of the United States, split by 50 states. These clusters of the population are bounded by the border of the state that they are in."
      )), 
    div(p(
      "Every 10 years, Congress can redraw the district lines to recapture the populatiuon fluctuations that occur over time. What is interesting is that there is not set algorithm for redrawing these lines, they are done by hand. To vote in a member of Congress, the winning majority is 50% plus 1. If you can draw districts to dilute an existing majority by spreading them across many, many districts, the election results can be altered. This practice is called 'Gerrymandering'."
    )), 
    div(p(
      "To 'Gerrymander' a district, you draw a continuous district boundary with the sole purpose to misrepresent the true political opinion of that state. I've used machine learning to redraw these district lines using mathematics."
    )), 
    div(p(
      "Currently, only North Carolina is fitted, due to the sheer size of the dataset (~260 million addresses)."
    )),
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
      div(p(
        "To select a state, click on the map. The information below will update accordingly. To see your state up close, double-click your state and navigate to the 'See your state' tab. To see your machine-learned districts, double-click your state and navigate to the 'See your new districts' tab."
      ))
    ),
    fluidRow(
      tabBox(
        title="Interactive Map", width=12,
        tabPanel("Select your state",
          plotOutput("mapPlot", 
                     click="clickMap",
                     dblclick="dblclickMap"
                     )
            ),
        tabPanel("See your state",
          plotOutput("zoomPlot")
        ),
        tabPanel("See your new districts",
          imageOutput("zoomImage")
        )
      )
    ),
    fluidRow(
      valueBoxOutput("stateBox", width=3),
      valueBoxOutput("popBox", width=3),
      valueBoxOutput("seatBox", width=3),
      valueBoxOutput("pop_seatBox", width=3)
    ),
    fluidRow(
      column(width=6,
        box(
          title="Scatter Plot", width=NULL, solidHeader = TRUE,
          plotOutput("scatterPlot")
        )
      ),
      column(width=6, 
        box(
          title="Histogram", width=NULL, solidHeader = TRUE,
          plotOutput("histPlot")
        )
      )
    )
  ),
skin="black")

