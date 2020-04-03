##############
#server.r
#############

source("londongrapher.r")

shinyServer(function(input, output, session){
  
  output$map1 <- renderLeaflet({
    leaflet(wardBoundaries) %>% addProviderTiles("CartoDB.DarkMatter") %>%
      setView(-0.0881798, 51.48932, zoom = 10)
  })
  
  #observer for the map elements to redraw
  observe({
    breaks<-classIntervals(wardBoundaries@data[[input$variable]], n=5, style=input$classIntStyle)
    breaks <- breaks$brks
    
    pal <- colorBin(palette = input$colourbrewerpalette, 
                    domain = wardBoundaries@data[[input$variable]],
                    #create bins using the breaks object from earlier
                    bins = breaks
    )
    
    leafletProxy("map1", data = wardBoundaries) %>%
      clearShapes() %>% 
      addPolygons(stroke = F, 
                fillOpacity = 0.5, 
                smoothFactor = 0.5,
                color = ~pal(wardBoundaries@data[[input$variable]]),
                #popup = ~WD11NM
                popup = paste(wardBoundaries@data$WD11NM, 
                              "... ",wardBoundaries@data[[input$variable]])
                )
  })
  
  #observer for the legend to redraw
  observe({
    breaks<-classIntervals(wardBoundaries@data[[input$variable]], n=5, style=input$classIntStyle)
    breaks <- breaks$brks
    
    pal <- colorBin(palette = input$colourbrewerpalette, 
                    domain = wardBoundaries@data[[input$variable]],
                    #create bins using the breaks object from earlier
                    bins = breaks
    )
    
    proxy <- leafletProxy("map1", data = wardBoundaries)
    proxy %>% clearControls() %>%
    addLegend("bottomright", 
              pal= pal, 
              values = ~wardBoundaries@data[[input$variable]], 
              title = input$variable, 
              labFormat = labelFormat(prefix = ""),
              opacity = 1
    )
  })
    
  # output$plot1 <- renderPlotly({
  #   londongrapher(variable = input$variable, 
  #                 colourbrewerpalette = input$colourbrewerpalette
  #   )
  # })
  
  output$plot1 <- renderPlot({
    londongrapher(variable = input$variable,
                  colourbrewerpalette = input$colourbrewerpalette,
                  classIntStyle = input$classIntStyle)
  })
  
})