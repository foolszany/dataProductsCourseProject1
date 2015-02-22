---
title       : Course_Project 
subtitle    : 
author      : dp
job         : n/a
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [bootstrap]   # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## World Cup Player - Nearest Neighbor

This application uses data collected during the 2014 World Cup to help identify similar players to that entered by the user.
There are two aspects to the app
1. Data Exploration of actual world cup players
2. Identifying players of with greatest similarity to a player with data entered by the user

---

## Slide 2 - Data Exploration

1. The first set of widgets allow for exploration of the dataset
2. The scatter graph illustrates two metrics for the players
3. Use the widgets to explore the data and identify outliers

---


## Slide 3 - Finding comparitors

1. Enter the stats for the palyer you want to assess
2. Kmeans package is used to find clusters of similar players
3. input player attributes on the bottom left set of widgets to find the most similar cohort of players

---

## Slide 4 - how it works
1. 6 key variables from the world cup 2014 data set are used for developing the clusters
2. Only players with 50+ minutes of playing time are included in the data
3. Most variables are normalized on a per game basis (i.e. 90 minutes)
4. A function finds the closest cluster, and returns a table of the comparator players

---


## Slide 5 - results
1. hopefully you find this to be a fun tool for identifying similar football players
2. In total, there are 50 clusters of players

---
