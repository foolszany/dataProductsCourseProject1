
library(shiny)
library(ggplot2)


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


shinyUI(pageWithSidebar(
  headerPanel("2014 World Cup Players"),
  
  sidebarPanel(
    
    h3("Select Attribute"),
    
    radioButtons(inputId="Position", 
                       label="Select Positions",
                       c("All"="All",
                         "Forward"="F",
                         "Defense"="D",
                         "Midfield"="M",
                         "Goalie"="G")),
    
    
   # sliderInput(inputId="mu", label="guess the mean",
   #             min=0, max=100, step=5, value=c(0,100)),
    
   h4("Add a Smoother Line to the Data?"),
    checkboxInput(inputId="smoother", label="LM smoother", value=FALSE)
   
   
    
    ),
  
  mainPanel(
    
    h4("This is an analysis of player performance in the 2014 world cup"),
    p("the graph below shows a scatter plot of player top speed and distance covered on a per game basis. Use the widgets below to isoloate diferent positions."),
    
    plotOutput("graph1")
    
 
    
   
    )
  
    ))