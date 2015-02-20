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


shinyServer(
  function(input, output){
      
  
    selectedData <- reactive({
      playerData[, c(input$xVar, input$yVar, playerData$POSITION)]
    })  
    
    
  output$oPosition <- renderPrint({input$Position})
  
  playerDataGraph <- playerData
  
      
  output$graph1 <- renderPlot ({
    
    if(input$Position=="All"){
      
      theGraph <- ggplot(data=playerData, aes(x=TOP_SPEED,
                  y=DISTANCE_COVERED, group=POSITION)) + ggtitle("All Positions") + ylab("Distance Covered per Game (km)") + xlab("Top Speed (km/h)") + geom_point(aes(size=4, colour=POSITION))
    }
    
        
    if(input$Position=="F"){
    
    theGraph <- ggplot(data=playerData[playerData$POSITION=="F",], aes(x=TOP_SPEED,
                y=DISTANCE_COVERED, group=POSITION)) + ggtitle("Forwards")  + ylab("Distance COvered per Game (km)") + xlab("Top SPeed (km/h)") + geom_point(aes(size=4, colour=POSITION), show_guide=FALSE)
    }
     
    
    if(input$Position=="M"){
      
      theGraph <- ggplot(data=playerData[playerData$POSITION=="M",], aes(x=TOP_SPEED,
                y=DISTANCE_COVERED, group=POSITION)) + ggtitle("Midfield") + ylab("Distance COvered per Game (km)") + xlab("Top SPeed (km/h)")+ geom_point(aes(size=4, colour=POSITION), show_guide=FALSE)
    }
    
    if(input$Position=="D"){
      
      theGraph <- ggplot(data=playerData[playerData$POSITION=="D",], aes(x=TOP_SPEED,
               y=DISTANCE_COVERED, group=POSITION)) + ggtitle("Defenders") + ylab("Distance COvered per Game (km)") + xlab("Top SPeed (km/h)") + geom_point(aes(size=4, colour=POSITION), show_guide=FALSE)
    }
    
    if(input$Position=="G"){
      
      theGraph <- ggplot(data=playerData[playerData$POSITION=="D",], aes(x=TOP_SPEED,
              y=DISTANCE_COVERED, group=POSITION)) + ggtitle("Goalies") + ylab("Distance COvered per Game (km)") + xlab("Top SPeed (km/h)") + geom_point(aes(size=4, colour=POSITION), show_guide=FALSE)
    }
    
    
   if(input$smoother){
    theGraph <- theGraph + geom_smooth(method="lm") 
    }
   
   print(theGraph) 

  })
  
  
})