library(shiny)
library(tidyverse)

basics_ratings <- as_tibble(read_csv("basics_ratings.csv", na = "\\N"))

actionRomance <- basics_ratings %>% filter(genres == 'Action,Romance')

aggRatings <- aggregate(titleId ~ genre, basics_ratings, function(x) length(unique(x)))

#print(aggRatings)


genreList <- sort(unique(basics_ratings$genre, incomparables = FALSE))



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput('groupCheckBox', 'Genres', choices = genreList, selected = NULL,
                               inline = FALSE, width = 200, choiceNames = NULL,
                               choiceValues = NULL)
            
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("interactiveGenre"),
            plotOutput("genres")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$genres <- renderPlot(
        {
            barplot(aggRatings$titleId, 
                    main="Movies per Genre", 
                    xlab="genres",
                    ylab="count"
                    )
        }
    )
    output$interactiveGenre <- renderPlot(
        aggRatings %>% filter(genre %in% input$groupCheckBox)
        %>% ggplot(aes(x = reorder(genre, titleId),
                   y = titleId)) +
            geom_col() +
            theme_minimal()
    )
    

}

# Run the application 
shinyApp(ui = ui, server = server)
