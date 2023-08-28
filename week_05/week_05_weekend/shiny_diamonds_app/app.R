#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(bslib)

library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = bs_theme(bootswatch = "flatly"),

  # Application title
  titlePanel("Diamonds Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        inputId = "filter_cut",
        label = strong("Filter by cut:"),
        choices = unique(diamonds$cut),
        selected = unique(diamonds$cut)
      ),
      hr(),
      radioButtons("fill_variable",
        label = strong("Fill"),
        choices = choices_fill_variables
      ),
      hr(),
      sliderInput(
        inputId = "slider_carat",
        label = strong("Carat:"),
        min = min(diamonds$carat),
        max = max(diamonds$carat),
        value = range(diamonds$carat),
        round = TRUE,
        ticks = TRUE,
        step = 0.2
      )
    ),

    # Main panel ####
    mainPanel(
      # Tabset with plot and table ####
      tabsetPanel(
        id = "tabset_tabs",
        type = "tabs",
        selected = NULL,
        header = br(),
        tabPanel(
          "Prices",
          plotOutput("histogramPlot"),
          icon = icon("gem")
        ),
        tabPanel(
          "Table",
          DT::dataTableOutput("tablePlot"),
          icon = icon("table")
        )
      )
    )
  )
)

# Define server logic required to draw plots
server <- function(input, output, session) {
  fill_variable <- reactive({
    # Get the index of the name
    pos <- match(input$fill_variable, choices_fill_variables)
    names(choices_fill_variables)[pos]
  })

  carat_range <- reactive({
    cbind(
      input$caretInput[1],
      input$caretInput[2]
    )
  })

  filtered_data <- reactive({
    req(input$filter_cut, input$slider_carat)
    diamonds %>%
      filter(cut %in% input$filter_cut) %>%
      filter(carat >= input$slider_carat[1] &
        carat <= input$slider_carat[2])
  })

  # Histogram plot of diamond price by counts ####
  output$histogramPlot <- renderPlot({
    ggplot(
      filtered_data(),
      aes(
        x = price,
        fill = !!as.name(input$fill_variable)
      )
    ) +
      geom_histogram(
        color = "white",
        binwidth = 1000,
        boundary = 0
      ) +
      labs(
        title = "Diamond Price vs. Count",
        x = "\nPrice",
        y = "Count\n",
        fill = fill_variable()
      ) +
      scale_x_continuous(labels = scales::dollar_format()) +
      scale_y_continuous(labels = scales::comma_format()) +
      scale_fill_brewer(palette = "Blues") +
      theme_minimal()
  })

  # Table plot of diamond data ####
  output$tablePlot <- DT::renderDataTable({
    filtered_data()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
