#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- pageWithSidebar(
  headerPanel('Lab 1-Part 3'),      # title of the app
  sidebarPanel(
    selectInput('x', 'CDC Site Map vs Twitter Data Map', c("all" = "all",
                                                "flu" = "flu"
                                               ))
  ),     # create a sidebar which can include actionButtons, drop-downs, etc.
  
  mainPanel(imageOutput(outputId = "Twitter",width = "100%"),br(),br(),br(),br(),br(),br(), imageOutput(outputId = "CDC"),width = "100%")      
  )
server <- function(input, output) {
  # links all functions to ui
  output$CDC <- renderImage({
    filename <- normalizePath(file.path(dirname(rstudioapi::getSourceEditorContext()$path),
                                        paste(input$x, '.png', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename)
    
  }, deleteFile = FALSE)
  
  output$Twitter <- renderImage({
    filename1 <- normalizePath(file.path(dirname(rstudioapi::getSourceEditorContext()$path),
                                         paste(input$x, 'twitter.png', sep='')))
    # Return a list containing the filename and alt text
    list(src = filename1)
    
  }, deleteFile = FALSE)
  
  #output$imageTwitter <- img(src="myImage.png",height=500,width=500)
}


shinyApp(ui, server)

