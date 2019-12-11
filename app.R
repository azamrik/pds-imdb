library(shiny)
library(tidyverse)
library(dbplyr)
library(wesanderson)
library(plotly)
library(readr)
library(sqldf)
library(DT)
library(networkD3)

basics_ratings <- filter(as_tibble(subset(read_csv("basics_ratings.csv", na = "\\N"), select = -c(endYear, runtimeMinutes, isAdult, titleType, primaryTitle, genres))), !is.na(startYear))
averageRatingInt<-(round((basics_ratings$averageRating)/0.5)*0.5)
basics_ratings <- cbind(basics_ratings, averageRatingInt)
aggRatings <- aggregate(titleId ~ genre + averageRatingInt, basics_ratings, function(x) length(unique(x)))
names(aggRatings)[names(aggRatings) == "titleId"] <- "Titles"
names(aggRatings)[names(aggRatings) == "averageRatingInt"] <- "AvgRating"
names(aggRatings)[names(aggRatings) == "genre"] <- "Genre"
genreList <- sort(unique(basics_ratings$genre, incomparables = FALSE))

###############################
### scatter plot  variables ###
###############################
principals <- subset((read_csv("principals.csv", na = "\\N")), select = -c(characters))
actorNames <- subset((read_csv("names.csv", na = "\\N")), select = -c(birthYear, deathYear, primaryProfession, knownForTitles))



###############################
######### Generate UI #########
###############################

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$style(type = "text/css", ".container-fluid {font-size:80%;}"),
  tags$style(type="text/css", ".forceNetwork{margin:10px;}"),
  tags$style(type="text/css", ".modebar{visibility:hidden;}"),
  tags$style(type="text/css", ".forceNetwork{margin:10px;} 
             .dataTables_filter{font-size:80%}
             .dataTables_length{font-size:80%}
             .sorting{font-size:80%}
             .noplaceholder{background-color:white;color: white;border-color: white;}"
             ),
  
    # Application title
    titlePanel("IMDB Data Analysis"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          sliderInput('minVotes', 
                      'Select Minimum Votes',
                      min=0,
                      max=1000000,
                      value=1000,
                      step=1000),
          numericInput('textNum', 'or insert number here',
               value = 1000,
               min=0,
               max=1000000,
               step=1),
          sliderInput('prodYear', 
                      'Select production years range',
                      min=1920,
                      max=2018,
                      value=c(1998, 2018),
                      step=1,
                      sep=""),
          checkboxGroupInput('groupCheckBox', 
                               'Genres', 
                               choices = genreList, 
                               selected = list('Action'),
                               inline = FALSE)
            ,width = 3
          
        ),

        # Show a plot of the generated distribution
        mainPanel(
            width = 9,
            fluidRow(
              column(7,plotlyOutput("interactiveGenre", height = "250px")),
              column(5,plotlyOutput("scaterPlot", height = "250px"))
            ),
            fluidRow(
              plotlyOutput("trendLine", height = "250px"),
              verbatimTextOutput("range")
              ),
            fluidRow(
              column(
                width = 5,
                DT::dataTableOutput("moviesTable")
                ),
              column(
                7,
                forceNetworkOutput("network")
                )
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  selectedList <- c(1)
  selectedRow <- reactive({
    if(is.null(input$moviesTable_rows_selected)){
      return((((c(dplyr::filter(basics_ratings, genre %in% input$groupCheckBox) %>%
                    filter(numVotes >= input$minVotes) %>%
                    filter(startYear >= input$prodYear[1]) %>%
                    filter(startYear <= input$prodYear[2]) %>%
                    arrange(desc(numVotes)))[1]))[[1]])[1])
    }
    (((c(dplyr::filter(basics_ratings, genre %in% input$groupCheckBox) %>%
           filter(numVotes >= input$minVotes) %>%
           filter(startYear >= input$prodYear[1]) %>%
           filter(startYear <= input$prodYear[2]) %>%
           arrange(desc(numVotes)))[1]))[[1]])[c(input$moviesTable_rows_selected)]
  })
    output$interactiveGenre <- renderPlotly(
      {
        data <- basics_ratings %>%
          filter(genre %in% input$groupCheckBox) %>% 
          filter(numVotes >= input$minVotes) %>%
          filter(startYear >= input$prodYear[1]) %>%
          filter(startYear <= input$prodYear[2]) %>%
          arrange(averageRatingInt)
        
        ggplotly(
            ggplot(data, aes(x = averageRatingInt,
                   fill = genre,
                   avgRating2 = averageRating)) +
            geom_bar(stat = "count") +
            theme_minimal() +
            labs(x = "Rating") +
            labs(y = "Movies") +
            labs(title = "Titles distribution per rating") +
            labs(fill = "")
            , dynamicTicks = TRUE
            , tooltip = c("fill", "y", "avgRating2")
            , barmode="group"
            
        )
      }
      
    )
    output$scaterPlot <- renderPlotly(
      {
        castList <- principals %>% 
          dplyr::filter(tconst %in% selectedRow()) %>%
          select(nconst)
        castList <- unique(castList$nconst, incomparables = FALSE)
        
        movie <- inner_join(
          basics_ratings, 
          principals %>% filter(nconst %in% castList), by=c("titleId" = "tconst")
        )
        movie <-  inner_join(actorNames, movie, by=c("nameId"= "nconst"))
        plotDf <- movie %>%
          group_by(primaryName, category) %>%
          summarize(
            mean_imdb_rating = round(weighted.mean(averageRating), digits = 2),
            movie_count = n())
        ggplotly(
          ggplot(
            plotDf, 
            aes(
              x = mean_imdb_rating, 
              y = movie_count, 
              color = category,
              text = paste(
                "Category:\t", category,
                "\nName:\t", primaryName,
                "\nMovies:\t", movie_count,
                "\nAvg Rating:\t", mean_imdb_rating)
              )) +
            geom_point(alpha = 0.6) +
            xlab("Number of movies")+
            ylab("Average ratings")+
            ggtitle("Cast's average rating and\nmovie counts")+
            theme_minimal() +
            theme(legend.position = "none"),
          tooltip="text"
        ) 
      }
    )
    output$trendLine <- renderPlotly(
      {
        data <- basics_ratings %>%
          filter(genre %in% input$groupCheckBox) %>% 
          filter(numVotes >= input$minVotes) %>%
          filter(startYear >= input$prodYear[1]) %>%
          filter(startYear <= input$prodYear[2]) %>%
          group_by(startYear,genre)%>%
          summarise(averatings=round(mean(averageRating,na.rm=TRUE),2))
        ggplotly(
          ggplot(data=data,aes(
              y=averatings,
              x=as.numeric(as.character(startYear)),
              group=genre,
              "Average Rating" = averatings,
              text = paste(
                "Genre:\t", genre,
                "\nYear:\t", as.numeric(as.character(startYear)),
                "\nAvg Rating:\t", averatings)
              ))+
            geom_line(aes(color=genre))+
            geom_point(aes(color=genre))+
            theme_minimal() +
            xlab("Production Year")+
            ylab("Average ratings")+
            labs(color="") +
            ggtitle("Average ratings by genre over start year")+
            scale_x_continuous(
              breaks=seq(
                input$prodYear[1],
                input$prodYear[2],
                ceiling((input$prodYear[2]-input$prodYear[1])/10)
                )
              ) 
          , tooltip = "text"
        )
          
      }
    )
    # highlight selected rows in the table
    output$moviesTable <- DT::renderDataTable({
      dataForTable <- dplyr::filter(basics_ratings, genre %in% input$groupCheckBox) %>% 
        filter(numVotes > input$minVotes) %>%
        filter(startYear >= input$prodYear[1]) %>%
        filter(startYear <= input$prodYear[2]) %>%
        arrange(desc(numVotes))
      
      datatable(
        dataForTable,
        options = list(
          # 0 titleId
          # 1 averageRatingInt
          # 2 numVotes
          # 3 averageRating
          # 4 genre
          # 5 startYear
          # 6 originalTitle
          columnDefs=list(
            list(visible=FALSE, targets=-c(0,1,5))
            ),
          
          orderClasses=TRUE
          ),
        rownames = FALSE,
        colnames=c('Title ID', 'Title','Production Year', 'Genre','Rating', 'Votes', 'Rating Rounded'),
        selection = "multiple"
      ) 
      })
    
    observe({
      val <- input$minVotes
      updateNumericInput(session, "textNum", value = val)
    })
    observe({
      val <- input$textNum
      updateNumericInput(session, "minVotes", value = val)
    })
    
    output$range <- renderPrint(
      ((selectedRow()))
      )
    output$network <- renderForceNetwork({
      principals2 <- principals %>% 
        dplyr::filter(tconst %in% selectedRow())
      
      edges1 <- sqldf("select 
                  p1.nconst as \"source\",
                  p2.nconst as \"target\"
               from principals2 p1
               left join principals2 p2
                on p1.tconst = p2.tconst
                and p2.category in ('director')
               where p2.nconst is not null")
      
      directors <- sqldf("select 
                  p1.nconst,
                  p1.category
               from principals2 p1
               ")
      
      nodes <- sqldf("select nameId as nconst, primaryName from actorNames
               where nconst in (select distinct \"source\" from edges1)")
      edges <- edges1 %>% 
        select(-3)
      
      id_ref <- unique(edges$source) %>% 
        tibble::enframe() %>% 
        mutate(row_number = row_number()-1) %>% 
        select(-name)
      
      
      edges_new <- edges %>% 
        left_join(id_ref, by = c('source' = 'value')) %>% 
        mutate(Source = row_number) %>% 
        select(-source, -row_number) %>% 
        left_join(id_ref, by = c('target' = 'value')) %>% 
        mutate(Target = row_number) %>% 
        select(-target, -row_number)
      
      nodes_new <- id_ref %>% 
        left_join(nodes, by = c('value' = 'nconst')) %>% 
        rename('name' = primaryName, 'group' = row_number)
      
      nodes3 <- unique(nodes_new %>% left_join(directors, by = c('value' = 'nconst')))
      
      plotnet <- forceNetwork(
        edges_new, nodes3, NodeID = 'name', Group = 'category', opacity = 0.8,
        bounded = TRUE, zoom = FALSE, fontSize = 10, linkDistance = 30, charge = -10,
        colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10);"), legend=TRUE)
      
      plotnet
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
