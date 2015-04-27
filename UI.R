library(shiny)
line.data <- read.csv('linechart data.csv', na.string=c(". .", "", "xxx"),
                      fileEncoding = "Windows-1252")


line.countries <- c(names(line.data[,-c(1, 174)]), "None")

shinyUI(pageWithSidebar(
  # Application title
  headerPanel("International Defence Expenditure"),
  
  sidebarPanel(
    conditionalPanel(
      "$('li.active a').first().html()==='Map View'",
    selectInput("Year", "Select Year", 
                choices = list("1988" = 2, "1989" = 3, "1990" = 4, "1991" = 5, "1992" = 6, 
                               "1993" = 7, "1994" = 8, "1995" = 9, "1996" = 10, "1997" = 11, 
                               "1998" = 12, "1999" = 13, "2000" = 14, "2001" = 15, "2002" = 16,
                               "2003" = 17, "2004" = 18, "2005" = 19, "2006" = 20, "2007" = 21,
                               "2008" = 22, "2009" = 23, "2010" = 24, "2011" = 25, "2012" = 26, 
                               "2013" = 27), 
                selected = 27),
    checkboxInput("Log.expend", label = "Log Expenditure (Recomended due to very large US Expenditure)", value = TRUE),
    radioButtons("plot.region", "Region to Display",
                 choices = list("World" = 'world', "Europe" = '150', "Americas" = '019',
                                "Africa" = '002', "Asia"='142', "Oceania" = '009'), 
                 selected = 'world')
    ),
    conditionalPanel(
      "$('li.active a').first().html()==='Trends Over Time'",
      
      sliderInput("line.years", label = h3("Select Time Period"), min = 1988, 
                  max = 2013, value = c(1988, 2013),sep=""),
      
      selectInput("Country1", label = h3("Select First Country"), 
                  choices = line.countries, selected = "United.Kingdom"),
      
      selectInput("Country2", label = h3("Select Second Country"), 
                  choices = line.countries, selected = "None"),
      
      selectInput("Country3", label = h3("Select Third Country"), 
                  choices = line.countries, selected = "None"),
      
      selectInput("Country4", label = h3("Select Fourth Country"), 
                  choices = line.countries, selected = "None"),
      
      checkboxInput("real.exp", label = "Constant 2009$ (Recomended: if not selected Current US$ will be used)", value = TRUE)
      
    ),
    conditionalPanel(
      "$('li.active a').first().html()==='Notes'",
      h2("Data Sources"),
      p("All expenditure data is provided by the Stockholm International Peace Research Institute (SIPRI) 
        and is current as of 19/03/2015."),
      p("The raw data underlying these visualisations is avialable from " , 
        a("The SIPRI Website.", href = "http://www.sipri.org/research/armaments/milex/milex_database")),
      p("GDP deflators from the International Monetary Fund (IMF) World Economic Outlook Database (October 2014)
         were used to produce the constant prices displayed in the 'Trends Over Time' tab"),
      p("These deflators are available from the ",
        a("IMF Website", href = "https://www.imf.org/external/pubs/ft/weo/2014/02/weodata/index.aspx"))
    )
    ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Map View",h4("Global Defence Expenditure (Current US$)"),htmlOutput("MapChart")),
      tabPanel("Trends Over Time",h4("International Defence Expenditure Over Time"),htmlOutput("LineChart")),
      tabPanel("Notes",h4("Notes on Expenditure Data"),
               p("All data presented by this application is produced and freely provided for non-commercial 
                 purposes by the Stockholm International Peace Research Institute (SIPRI). Full details
                 on the methodology behind the production of these figures can be found at the ",
               a("sources and methods section of the SIPRI website.", href = "http://www.sipri.org/research/armaments/milex/milex_database/copy_of_sources_methods")),
               p("SIPRI data is used as a common definition and methodology for calculating defence expenditure is 
                 required in order for meaningful international comparisons to be made and SIPRI produce such consistent 
                 estimates for a large number of countries. However, SIPRI's estimates
                 of defence expenditure for the UK and other nations differ from those of other sources 
                 (for example, those of the UK Ministry of Defence or NATO). Figures reported in this 
                 application may differ from those of other sources."),
               p("All visualisations are produced using the ", a("google charts API", href="https://developers.google.com/chart/interactive/docs/index"), 
                 ", implemented using", a(" the googleVis package", href= "http://cran.r-project.org/web/packages/googleVis/vignettes/googleVis.pdf"), 
                 " for the R statistical programming language. The User Interface and interactive elements were produced using the",
                 a("Shiny package", href = "http://shiny.rstudio.com/"), " for R.")
    ))
  )
))