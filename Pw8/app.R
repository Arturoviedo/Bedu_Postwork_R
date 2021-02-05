## app.R ##

## Dash board para el data set 'mtcars'

library(shiny)
library(shinydashboard)
#install.packages("shinythemes")
library(shinythemes)
library(ggplot2)
library(dplyr)

#Esta parte es el análogo al ui.R
ui <- 
    
    fluidPage(
        
        dashboardPage(
            
            dashboardHeader(title = "Basic dashboard"),
            
            dashboardSidebar(
                
                sidebarMenu(
                    menuItem("Histograma", tabName = "Dashboard", icon = icon("dashboard")),
                    menuItem("Imagen", tabName = "img1", icon = icon("file-picture-o")),
                    menuItem("Data Table", tabName = "data_table", icon = icon("table")),
                    menuItem("Imagen", tabName = "img2", icon = icon("file-picture-o"))
                )
                
            ),
            
            dashboardBody(
                
                tabItems(
                    
                    # Histograma
                    tabItem(tabName = "Dashboard",
                            fluidRow(
                                titlePanel("Goles a favor y en contra por equipo"), 
                                selectInput("x", "Seleccione el valor de X",
                                            choices = c("home.score", "away.score")),
                                
                                
                                plotOutput("plot1", height = 450, width = 750)
                            )
                    ),
                    #Data Table
                    tabItem(tabName = "data_table",
                            fluidRow(        
                                titlePanel(h3("Data Table")),
                                dataTableOutput ("data_table")
                            )
                    ), 
                    #Imagen 
                    tabItem(tabName = "img1",
                            fluidRow(
                                titlePanel(h3("Gráficas Postwork 3")),
                                img( src = "PW3_g1.png", height = 300, width = 460),
                                img( src = "PW3_g2.png", height = 300, width = 460),
                                img( src = "PW3_g3.png", height = 300, width = 460)
                            )
                    ),
                    #Imagen
                    tabItem(tabName = "img2",
                            fluidRow(
                                titlePanel(h3("Ganancia mínimo y máximo")),
                                img( src = "Momios_g1.png", height = 300, width = 460),
                                img( src = "Momios_g2.png", height = 300, width = 460)

                            )
                    )
                    
                )
            )
        )
    )

#De aqui en adelante es la parte que corresponde al server

server <- function(input, output) {
    data1 <- read.csv(file = "match.data.csv") 
    data1 <- mutate(data1, FTR = ifelse(home.score > away.score, "H", ifelse(home.score < away.score, "A", "D")))
    
    #Gráfico de Histograma
    output$plot1 <- renderPlot({
        
        data <-  read.csv("match.data.csv", header = T)
        
        data <- mutate(data, FTR = ifelse(home.score > away.score, "H", ifelse(home.score < away.score, "A", "D")))
        
        x <- data[,input$x]
        
        #summary(data)
        data %>% ggplot(aes(x, fill = FTR)) + 
            geom_bar() + 
            facet_wrap("away.team") +
            labs(x =input$x, y = "Goles") + 
            ylim(0,50)
        
        
    })
    
    
   #Data Table
    output$data_table <- renderDataTable( {data1}, 
                                          options = list(aLengthMenu = c(5,25,50),
                                                         iDisplayLength = 5)
    )
    
}
shinyApp(ui, server)