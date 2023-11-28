#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(reticulate)

source_python("python/TicTacToebotRReady.py")

function(input, output, session) {
  
  winPos = c(
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    1, 4, 7,
    2, 5, 8,
    3, 6, 9,
    1, 5, 9,
    3, 5, 7
  )
  
  rv <- reactiveValues(
    board = c('','','','','','','','',''), #The current board state
    aiAction = "Waiting...",
    winner = "None"
  )
  currTurn = 'x' #Represents which player has the current turn
  playerCanGo = FALSE
  aiPlayer = 1
  aiLevel = 1
  
  #Check if the player defined by 'letter' has won the game
  checkVictory <- function(letter){
    
    #Check every winning position
    for (i in seq(1, length(winPos), 3)) {
      #Check every slot within that position to ensure it is true
      if(all(rv$board[winPos[i:(i+2)]] == letter)){
        return(TRUE)
      }
    }
    return(FALSE)
  }
  
  switchCurrentTurn <- function() {
    if(currTurn == 'x'){currTurn <<- 'o'}
    else if (currTurn=='o'){currTurn <<- 'x'}
  }
  
  endGame <- function() {
    if(currTurn == 'x'){
      if(aiPlayer == 1){
        rv$winner = "AI"
      }
      else {
        rv$winner = "Player"
      }
    }
    else{
      if(aiPlayer == 2){
        rv$winner = "AI"
      }
      else {
        rv$winner = "Player"
      }
    }
    playerCanGo <<- FALSE
  }
  
  #Update the board. Returns:
  # 0 if nothing happened, 
  # 1 if the turn should be switched,
  # 2 if the game ended
  updateBoard <- function(position) {
    
    #Make sure this spot wasn't already played in
    if(rv$board[position] != '_'){
      return(0)
    }
    
    #Set that position on the board
    rv$board[position] <- currTurn
    
    #If there was a victor, end the game
    if(checkVictory(currTurn)){
      endGame()
      return(2)
    }
    
    #If all spaces are full, its a draw
    if(all(rv$board != "_")) {
      rv$winner = "Draw"
      playerCanGo <<- FALSE
      return(2)
    }
    
    switchCurrentTurn()
    return(1)
  }
  
  #Have the ai take a turn
  aiTurn <- function(){
    results <- findMove(aiLevel, aiPlayer, rv$board)
    rv$aiAction <- results[[1]]
    playerCanGo <<- TRUE
    updateBoard(results[[2]][[1]] * 3 + results[[2]][[2]] + 1)
  }
  
  #The player takes their turn (called when a button is pressed)
  playerTurn <- function(position){
    if(playerCanGo){
      if(updateBoard(position) == 1){
        playerCanGo <<- FALSE
        rv$aiAction <- "Thinking..."
        aiTurn()
      }
    }
  }
  
  #Create a button for a specific cell on the board
  buttonCell <- function(position) {
    actionButton(
      paste("c", position, sep=""), 
      label = rv$board[position], 
      style="width:100%;height:100px;"
    )
  }
  
  #Following 2 functions display text describing the ai's thoughts
  output$aiActionText <- renderText({
    return(rv$aiAction)
  })
  output$aiAction <- renderUI({
    return(div(
      h4("AI's actions:"),
      textOutput("aiActionText")
    ))
  })
  
  #Display text for if there is a winner
  output$victoryText <- renderText({
    return(paste("Winner:", rv$winner))
  })
  output$victory <- renderUI({textOutput("victoryText")})
  
  #Functions that make the buttons
  output$b1 <- renderUI({buttonCell(1)})
  output$b2 <- renderUI({buttonCell(2)})
  output$b3 <- renderUI({buttonCell(3)})
  output$b4 <- renderUI({buttonCell(4)})
  output$b5 <- renderUI({buttonCell(5)})
  output$b6 <- renderUI({buttonCell(6)})
  output$b7 <- renderUI({buttonCell(7)})
  output$b8 <- renderUI({buttonCell(8)})
  output$b9 <- renderUI({buttonCell(9)})
  
  #Event handlers for the buttons
  observeEvent(input$c1, {playerTurn(1)})
  observeEvent(input$c2, {playerTurn(2)})
  observeEvent(input$c3, {playerTurn(3)})
  observeEvent(input$c4, {playerTurn(4)})
  observeEvent(input$c5, {playerTurn(5)})
  observeEvent(input$c6, {playerTurn(6)})
  observeEvent(input$c7, {playerTurn(7)})
  observeEvent(input$c8, {playerTurn(8)})
  observeEvent(input$c9, {playerTurn(9)})
  
  #Function to start a new game
  observeEvent(input$newGame, {
    rv$board <- c('_','_','_','_','_','_','_','_','_')
    rv$winner <- "None"
    currTurn <<- 'x'
    
    if(input$aiType == "MiniMax AI"){
      aiLevel <<- 1
    }
    else {
      aiLevel <<- 0
    }
    
    if(input$aiLetter == "X (First)"){
      aiPlayer <<- 1
      rv$aiAction <- "Thinking..."
      playerCanGo <<- FALSE
      aiTurn()
    }
    else {
      aiPlayer <<- 2
      rv$aiAction <- "Waiting for you"
      playerCanGo <<- TRUE
    }
  })

}
