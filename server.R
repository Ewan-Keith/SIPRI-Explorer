library(shiny)
library(googleVis)
library(reshape2)

sipri.plot <- function(data, country.var, value.var, tooltip.var, log = FALSE, regions = 'world'){
  plot.data <- data[complete.cases(data),]
  
  
  if(log == TRUE){
    if(regions == 'world'){
      plot.data$Log.Defence.Expenditure <- log(plot.data[,value.var] + 1)
      
      return(gvisGeoChart(plot.data, country.var, colorvar = "Log.Defence.Expenditure",
                          options = list(height=500, width = 750,
                                         colors="[\'blue', \'orange']",
                                         region = regions)))
    }else{
      plot.data$Log.Defence.Expenditure <- log(plot.data[,value.var] + 1)
      
      return(gvisGeoChart(plot.data, country.var, colorvar = "Log.Defence.Expenditure",
                          options = list(height=500, width = 750,
                                         colors="[\'blue', \'orange']",
                                         region = regions)))
      
    }
    end() 
  }
  
  return(gvisGeoChart(plot.data, country.var, value.var,
                      options = list(height=500, width = 750,
                                     colors="[\'blue', \'orange']",
                                     region = regions)))
  
}

sipri.line.plot <- function(){
  
}

data <- read.csv("SIPRI data (current US$).csv", na.string=c(". .", "", "xxx"),
                 fileEncoding = "Windows-1252")



line.data <- read.csv('linechart data.csv', na.string=c(". .", "", "xxx"),
                      fileEncoding = "Windows-1252")



shinyServer(function (input, output) {
  
  
  output$MapChart <- renderGvis({
    
    data <- read.csv("SIPRI data (current US$).csv", na.string=c(". .", "", "xxx"),
                     fileEncoding = "Windows-1252")
    
    SelectedYear <- as.numeric(input$Year)
    SelectedRegion <- input$plot.region
    
    temp <- as.data.frame(cbind(as.character(data[,1]), data[,SelectedYear]))
    temp[,2] <- as.numeric(as.character(temp[,2]))
    names(temp)[2] <- "defence.expenditure"
    
    tooltip.spot <- which(names(temp)=="defence.expenditure")
    data.frame(temp[1:tooltip.spot], defence.expenditure.html.tooltips = temp$defence.expenditure)
    
    return(sipri.plot(temp, "V1", "defence.expenditure", "defence.expenditure.html.tooltips", log=input$Log.expend, regions = SelectedRegion))
    
  })
  
  output$LineChart <- renderGvis({
    
    line.data <- read.csv('linechart data.csv', na.string=c(". .", "", "xxx"),
                          fileEncoding = "Windows-1252")
    
    
    line.countries <- c(names(line.data[,-c(1, 174)]), "None")
    
    test <- line.data
    for(i in 2:173){
      test[,i] <- line.data[,i]/line.data[,174]*100
    }
    
    ######## define null values for country selection #########
    if(input$Country1 == "None"){
      country1 <- NULL
    } else {
      country1 <- input$Country1
    }
    
    if(input$Country2 == "None"){
      country2 <- NULL
    } else {
      country2 <- input$Country2
    }
    
    if(input$Country3 == "None"){
      country3 <- NULL
    } else {
      country3 <- input$Country3
    }
    
    if(input$Country4 == "None"){
      country4 <- NULL
    } else {
      country4 <- input$Country4
    }
    
    
    #######  plot line chart ###########
    if(input$real.exp == F){
      return(gvisLineChart(line.data[line.data$Year >= input$line.years[1] & line.data$Year <= input$line.years[2],
                                     c('Year', country1, country2, country3, country4)],
                           options = list(height=500, width = 1000,
                                          vAxes="[{title:'Defence Expenditure (Current US$m)'}]",
                                          hAxes="[{title:'Year'}]")
      ))
      
    } else {
      return(gvisLineChart(test[test$Year >= input$line.years[1] & test$Year <= input$line.years[2],
                                c('Year', country1, country2, country3, country4)],
                           options = list(height=500, width = 1000,
                                          vAxes="[{title:'Defence Expenditure (Constant 2009 US$m)'}]",
                                          hAxes="[{title:'Year'}]")
      ))
    }
  })
})