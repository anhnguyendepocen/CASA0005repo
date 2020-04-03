#user interface for London Shiny
library(plotly)
library(leaflet)
library(sp)
library(maptools)
library(RColorBrewer)
library(maptools)
library(rgdal)
library(classInt)
library(shiny)

source("dataloader.r")

shinyUI(fluidPage(
  
  #in this new page, first plot me a nice big map
  leafletOutput("map1", width = "100%", height = 1000),
    
  #then, create me a nice floaty panel which has all of the options in in, plus 
  #a histogram of the variables selected
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                width = 330, height = "auto",
                #gimme a title
                h2("Social Statistics for Wards in London"),
                #gimme a drop down to select variables from the ward 
                #boundaries dataset
                selectInput("variable", "Variable",
                            names(wardBoundaries@data)[11:79]),
                #gimme some colour options from colourbrewer
                selectInput("colourbrewerpalette", "Color Scheme",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                ),
                selectInput("classIntStyle", "Interval Style",
                            c("Jenks Natural Breaks" = "jenks",
                              "Quantile" = "quantile",
                              "Equal Interval" = "equal",
                              "Pretty" = "pretty")),
                #plot me a nice plotly histogram
                #plotlyOutput("plot1")
                plotOutput("plot1")
  )
))

#length(names(wardBoundaries@data))
