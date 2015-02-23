
library(shiny)
library(ggplot2)
library(caret)
library(ggvis)


WCraw <- read.csv("data/worldCup.csv")

## eliminate all players less than 50 minutes
WCraw <- WCraw[WCraw$MINUTES_PLAYED>=50,]


WCtrim <- WCraw[,-c(1:5)]


## calculate normalized values of minutes played

ninetyMinutes <- function (x){
  return((x/WCtrim$MINUTES_PLAYED)*90)
}

WCstats <- as.data.frame(lapply(WCtrim, ninetyMinutes))

## replace variables that should not have been divided by minutes played
WCstats$TOP_SPEED <- WCtrim$TOP_SPEED
WCstats$PASSES_COMPLETED_PERCENT <- WCtrim$PASSES_COMPLETED_PERCENT
WCstats$CROSSES_COMPLETED_PERCENT <- WCtrim$CROSSES_COMPLETED_PERCENT

# combine with player name and add back column name
WCstats <- cbind(WCraw[,1:4],WCstats)
colnames(WCstats)[1:4] <- c("PLAYER", "LEAGUE", "POSITION", "TEAM")

playerData <- WCstats

## training set

training <- playerData[,c("PLAYER", "POSITION", "TOP_SPEED", "TOTAL_GOALS_SCORED", "DISTANCE_COVERED", "TOTAL_PASSES", "CROSSES", "SOLO_RUNS_INTO_AREA")]

shinyUI(pageWithSidebar(
  headerPanel("2014 World Cup Players"),
  
  sidebarPanel(
    
    h3("Select Attribute"),
    
       
    selectInput('xcol', 'X Variable', names(training)[-c(1:2)], selected="TOP_SPEED"),
    selectInput('ycol', 'Y Variable', names(training)[-c(1:2)], selected="DISTANCE_COVERED"),  
    
   ## enter info for the comparator player
   ### enter here
   
   h3("Enter Data for comparator player"),
   
   sliderInput(inputId="topSpeed", label="What is the top speed",
               min=10, max=40, step=0.5, value=20),
   
   sliderInput(inputId="goals", label="Number of goals per game",
               min=0, max=2, step=0.1, value=0.2),
   
   sliderInput(inputId="distance", label="km covered per game",
               min=5, max=15, step=.5, value=7),
   
   
   sliderInput(inputId="passes", label="passes per game",
               min=20, max=120, step=.5, value=5),
   
   sliderInput(inputId="crosses", label="crosses per game",
               min=0, max=5, step=.1, value=.4),
   
   sliderInput(inputId="soloRuns", label="solo runs into box per game",
               min=0, max=4, step=.25, value=.5)
   
   
    ),
  
  mainPanel(
    
    h4("This is an analysis of player performance in the 2014 world cup"),
    p("the graph below shows a scatter plot of key variables that are used in the subsequent cluster analysis. All variables are normalized to a per game basis (90 minutes). Use the top widgets below to explore the data."),
    
    plotOutput("graph1"),
    
    h4("comparator analysis"),
    
        
    h5("Based on the statistics entered, here are the most comparable players (based on the 2014 world cup statistics. Change the sliders to see how the comparable group of players changes."),
    
    tableOutput("oresults2")
    
    
 
    
   
    )
  
    ))