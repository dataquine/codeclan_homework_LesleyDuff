#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#library(bslib)
#library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = bs_theme(bootswatch = "minty"),

  # Application title
  titlePanel("Diamonds Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput( # ?checkboxGroupInput
        "cut_input",
        strong("Filter by cut"),
        choices = unique(diamonds$cut),
        selected = unique(diamonds$cut),
       # inline = TRUE,
      ),
       sliderInput("carat_input",
                  strong("Carat:"),
                 min = min(diamonds$carat),
                max = max(diamonds$carat),
               value = range(diamonds$carat)
               )
    ),

    # Show a scatter plot
    mainPanel(
      plotOutput("histogram_plot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  filtered_data <- reactive({
    #req(input$cut_input) # ?req
    diamonds %>%
      #select(price, cut)
      filter(cut %in% input$cut_input)
  })
  #print(filtered_data)

  output$histogram_plot <- renderPlot({
    #print(filtered_data())
    ggplot(filtered_data(), aes(x = price)) +
      geom_histogram(color = "white", fill = "steelblue")

    # generate bins based on input$bins from ui.R
 #   x <- faithful[, 2]
  #  bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
   # hist(x,
    #  breaks = bins, col = "darkgray", border = "white",
     # xlab = "Waiting time to next eruption (in mins)",
      #main = "Histogram of waiting times"
    #)
  })

  output$table_output <- DT::renderDataTable({
    filtered_data()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
