#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

fluidPage(

    # Application title
    titlePanel("Tic-Tac-Toebot"),
    
    tags$head(
      tags$style(HTML("
        #c1 {
          grid-column: 1;
          grid-row: 1
        }
        #c2 {
          grid-column: 2;
          grid-row: 1
        }
        #c3 {
          grid-column: 3;
          grid-row: 1
        }
        #c4 {
          grid-column: 1;
          grid-row: 2
        }
        #c5 {
          grid-column: 2;
          grid-row: 2
        }
        #c6 {
          grid-column: 3;
          grid-row: 2
        }
        #c7 {
          grid-column: 1;
          grid-row: 3
        }
        #c8 {
          grid-column: 2;
          grid-row: 3
        }
        #c9 {
          grid-column: 3;
          grid-row: 3
        }
        #aiActionText {
          border-style: solid;
          border-color: gray
        }
        .tacCell {
          border-left: 1px solid;
          border-top: 1px solid;
        }
        .lefttacCell {
          border-top: 1px solid;
        }
        .toptacCell{
          border-left: 1px solid;
        }
        .wrapper{
          padding-right: 10%;
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          grid-auto-rows: minmax(100px, auto)
        }
      "))
    ),
    
    tabsetPanel(
      tabPanel(
        "Play",
        
        sidebarLayout(
          sidebarPanel(
            actionButton(
              "newGame", 
              label = "New Game"
            ),
            br(),
            br(),
            selectInput(
              inputId = "aiType",
              label = "AI Options:",
              choices = list(
                "MiniMax AI",
                "Random AI"
              )
            ),
            selectInput(
              inputId = "aiLetter",
              label = "Which letter will the AI use?:",
              choices = list(
                "X (First)",
                "O (Second)"
              )
            ),
            uiOutput("aiAction")
          ),
          mainPanel(
            fluidRow(
              div(
                class="wrapper",
                
                div(uiOutput("b1"), id="c1"),
                div(uiOutput("b2"), id="c2", class="toptacCell"),
                div(uiOutput("b3"), id="c3", class="toptacCell"),
                div(uiOutput("b4"), id="c4", class="lefttacCell"),
                div(uiOutput("b5"), id="c5", class="tacCell"),
                div(uiOutput("b6"), id="c6", class="tacCell"),
                div(uiOutput("b7"), id="c7", class="lefttacCell"),
                div(uiOutput("b8"), id="c8", class="tacCell"),
                div(uiOutput("b9"), id="c9", class="tacCell"),
              )
            ),
            fluidRow(
              h3(uiOutput("victory"))
            )
          )
        )
      ),
      
      tabPanel(
        "MiniMax Function",
        img(src="miniMaxFunc.png")
      ),
      tabPanel(
        "Decision Tree",
        img(src="decTree.png")
      ),
      tabPanel(
        "References",
        p("References used:"),
        br(),
        p("DAha,David. (1991). Tic-Tac-Toe Endgame. UCI Machine Learning Repository. https://doi.org/10.24432/C5688J.
"),
        br(),
        p("L, A. (2022, June 13). Minimax algorithm in Game theory: Set 1 (introduction). GeeksforGeeks. https://www.geeksforgeeks.org/minimax-algorithm-in-game-theory-set-1-introduction/ ")
      )
    )
)
