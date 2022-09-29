library(shiny)
library(shinydashboard)
library(dplyr)

library(gsheet)
df<-gsheet2tbl("https://docs.google.com/spreadsheets/d/1-VSMRylNtxMgOriLFNa5VttoL2cMWHeRXl0gbEadHjU/edit?usp=sharing")
#-----------------------------------------------------------------------------------------------#
X <- dashboardHeader(
  title = "BLBC"
)
#-----------------------------------------------------------------------------------------------#
Y <- dashboardSidebar(
  selectInput("Att1", "Choose Center", choices = c("NULL", as.character(unique(df$`Name of Center`))), selected = "NULL"),
  uiOutput("c")
)
#----------------------------------------------------------------------------------------------#
Z <- dashboardBody(
  DT::dataTableOutput("table")
)
#----------------------------------------------------------------------------------------------#
ui<-dashboardPage(X,Y,Z)
#----------------------------------------------------------------------------------------------#
server <- function(input, output) {
  selectedData <- reactive({
    if(input$Att1 == "NULL") Ddata <- df #Keep full data set if NULL
    else Ddata <- subset(df, `Name of Center` == input$Att1)
    
    Ddata
  })
  
  
  ######################
  output$c <- renderUI({selectInput("Att2", "Choose Month", choices = c("NULL", as.character(unique(selectedData()$Month))), selected = "NULL")})
  
  selectedData2 <- reactive({
    if(input$Att2 == "NULL") Vdata <- selectedData()
    else Vdata <- subset(selectedData(), Month == input$Att2)
    
    Vdata
  })
  
  #=====================
  
  output$table <- DT::renderDataTable({
    head(selectedData2(), n = 10)
  })
  
}
shinyApp(ui, server)

