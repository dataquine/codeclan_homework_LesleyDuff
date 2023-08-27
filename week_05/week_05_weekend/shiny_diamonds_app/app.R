#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(bslib)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = bs_theme(bootswatch = "minty"),
  
    # Application title
    titlePanel("Diamonds Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          checkboxGroupInput( # ?checkboxGroupInput
            "cut", 
            strong("Filter by cut"),
            choices = unique(diamonds$cut), 
            selected = unique(diamonds$cut)
          )
           # sliderInput("bins",
            #            "Number of bins:",
             #           min = 1,
              #          max = 50,
               #         value = 30)
        ),

        # Show a scatter plot
        mainPanel(
           plotOutput("scatterPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  filteredDiamonds <- reactive({
    req(input$cut) # ?req
    diamonds %>%
      filter(cut %in% input$cut)
    })
  
    output$histogramPlot <- renderPlot({
      filteredDiamonds() %>% 
        ggplot(aes(x = price))+
        geom_histogram(color = "white")
      
        # generate bins based on input$bins from ui.R
#        x    <- faithful[, 2]
 #       bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
  #      hist(x, breaks = bins, col = 'darkgray', border = 'white',
   #          xlab = 'Waiting time to next eruption (in mins)',
    #         main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
