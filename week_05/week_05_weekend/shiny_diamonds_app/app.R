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
 # theme = bs_theme(bootswatch = "minty"),

  # Application title
  titlePanel("Diamonds Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput( # ?checkboxGroupInput
        "cutInput",
        label = strong("Filter by cut:"),
        choices = unique(diamonds$cut),
        selected = unique(diamonds$cut),
      ),
      # br() element to introduce extra vertical spacing ----
      br(),
       sliderInput("caratInput",
                  label = strong("Carat:"),
                 min = min(diamonds$carat),
                max = max(diamonds$carat),
               value = range(diamonds$carat),
               round = TRUE,
               ticks =  TRUE,
               step = 0.2
               )
    ),

    # Show a scatter plot
    mainPanel(
      # Tabset with plot, and table ----
      tabsetPanel(id = "tabset_id",
                  type = "tabs",
                  selected = NULL,
        tabPanel(id = "plot_panel_id",
                 "Diamond Prices", 
                 plotOutput("histogramPlot"),
                 verbatimTextOutput("sliderText"),
                 icon = icon("gem")
                 
                 ),
    #    tabPanel("Summary", verbatimTextOutput("summary")),
        tabPanel(id = "table_panel_id",
                 "Table", 
                 DT::dataTableOutput("tablePlot"),
                 icon = icon("table")
                 )
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  carat_range <- reactive({
    cbind(input$caretInput[1],
          input$caretInput[2])
  })

  filtered_data <- reactive({
    #req(input$cutInput) # ?req
    #print(input$caretInput)
    diamonds %>%
      #select(price, cut)
     # mutate(test = count())
      filter(cut %in% input$cutInput) %>% 
      filter(carat >= input$caratInput[1] & 
              carat <= input$caratInput[2]) 
  })

  output$sliderText <- renderText({
 #   print(input$caratInput)
    paste0("You've selected the range: ", # ?toJSON
           input$caratInput[1], " to ", input$caratInput[2])
  })
  
  output$histogramPlot <- renderPlot({
    #print(filtered_data())
    ggplot(filtered_data(), 
           aes(x = price, fill = cut)) +
      #?geom_histogram
      #?geom_bar
      #geom_bar(aes(fill = cut),
               # cut_width(x,width
            
      geom_histogram(aes(fill = cut),
                     #color = "white", 
       # fill = "steelblue",
        binwidth = 1000
      ) +
      labs(
        title = "Diamond price vs. Count",
        x = "\nPrice",
        y = "Count\n"
      )
  })
  # Generate an HTML table view of the data ----
  output$tablePlot <- DT::renderDataTable({
    filtered_data()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
