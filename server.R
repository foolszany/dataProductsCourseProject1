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

training1 <- lapply(training[,-c(1,2)], scale)
training2 <- (as.data.frame(training1))


nrow(training2) ## 523
training2 <- replace(training2, is.na(training2), 0)

km <- kmeans(training2, 50, iter.max=100, nstart=1)

plot(training2$TOP_SPEED, training2$CROSSES)
points(km$centers, col="red", pch=20)
myResults <- cbind(training, km$cluster)

colnames(myResults) <- c("PLAYER", "POSITION", "TOP_SPEED", "TOTAL_GOALS_SCORED", "DISTANCE_COVERED", "TOTAL_PASSES", "CROSSES", "SOLO_RUNS_INTO_AREA", "CLUSTER")

compResults <- function(x){
  myResults[myResults$CLUSTER==x,c(1,2)]
}

yy <- myResults[myResults$CLUSTER==3, c(1,2)]

closest.cluster <- function(x) {
  cluster.dist <- apply(km$centers, 1, function(y) sqrt(sum((x-y)^2)))
  return(which.min(cluster.dist)[1])
}



shinyServer(
  function(input, output){
      
    selectedData <- reactive({
      playerData[, c(input$xcol, input$ycol)]
   })  
    
     
    ##selectedData <- as.data.frame(playerData[,c(input$xcol, input$ycol, playerData$POSITION)])
    
  output$oPosition <- renderPrint({input$Position})
  
  output$graph1 <- renderPlot ({
    
    plot(selectedData(), col="red")  
           
    })
  
  ## data for kmeans
 
    df <- reactive({c(input$topSpeed, input$goals, input$distance, input$passes, input$crosses, input$soloRuns) })
  
  
   output$view <- renderText({ 
   ## aa <- c(input$topSpeed, input$goals, input$distance, input$passes, input$crosses, input$soloRuns)
    df()
    
    ##cluster2 <- apply(aa, 1, closest.cluster)
    
  })
  
  output$oresults <- renderText({ 
  df1 <- df()
  means <- apply(training[,-c(1,2)], 2, mean, na.rm=TRUE)
  sds <- apply(training[,-c(1,2)], 2, sd, na.rm=TRUE)
  df1 <- (df1-means)/sds
  
  #df1 <- c(((df1[1]-mean(training[,3]))/sd(training[,3])), ((df1[2]-mean(training[,4]))/sd(training[,4])), ((df1[3]-mean(training[,5]))/sd(training[,5])),  ((df1[4]-mean(training[,6]))/sd(training[,6])),  ((df1[5]-mean(training[,7]))/sd(training[,7])), ((df1[6]-mean(training[,8]))/sd(training[,8])) )
  closest.cluster(df1)
  
  })
  
 
  output$oresults2 <- renderTable({ 
    df1 <- df()
    means <- apply(training[,-c(1,2)], 2, mean, na.rm=TRUE)
    sds <- apply(training[,-c(1,2)], 2, sd, na.rm=TRUE)
    df1 <- (df1-means)/sds
    
    compResults(closest.cluster(df1))
    
    
  })
  
  
})