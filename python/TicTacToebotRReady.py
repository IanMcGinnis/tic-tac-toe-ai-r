# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 20:22:42 2023

@author: mitch
"""

import copy
import random
import sys
import time

import random
import numpy as np

ROWS = 3
COLS = 3

class Board:
    def __init__(self, boardstate):
        self.squares = np.zeros((ROWS, COLS))
        self.marked_sqrs = 0
        for i in range(len(boardstate)):
            if(boardstate[i] == "_"):
                self.squares[int(i / 3)][int(i % 3)] = 0
            elif(boardstate[i] == "x"):
                self.squares[int(i / 3)][int(i % 3)] = 1
                self.marked_sqrs += 1
            elif(boardstate[i] == "o"):
                self.squares[int(i / 3)][int(i % 3)] = 2
                self.marked_sqrs += 1

    def final_state(self):
        #vertical wins
        for col in range(COLS):
            if self.squares[0][col] == self.squares[1][col] == self.squares[2][col] != 0:
                return self.squares[0][col]
        #horizontal wins
        for row in range(ROWS):
            if self.squares[row][0] == self.squares[row][1] == self.squares[row][2] != 0:
                return self.squares[row][0]

        #diagnal wins
        if self.squares[0][0] == self.squares[1][1] == self.squares[2][2] != 0:
            return self.squares[1][1]
        if self.squares[0][2] == self.squares[1][1] == self.squares[2][0] != 0:
            return self.squares[1][1]

        #no win
        return 0
    
    def mark_sqr(self, row, col, player):
        self.squares[row][col] = player
        self.marked_sqrs += 1
        
    def empty_sqr(self, row, col):
        return self.squares[row][col] == 0

    def get_empty_sqrs(self):
        empty_sqrs = []
        for row in range(ROWS):
            for col in range(COLS):
                if self.empty_sqr(row, col):
                    empty_sqrs.append((row, col))

        return empty_sqrs

    def isfull(self):
        return  self.marked_sqrs == 9

    def isempty(self):
        return self.marked_sqrs == 0
    
    def string(self):
        return np.array_str(self.squares)

class AI:
    def __init__(self, level = 1, player = 1):
        self.level = level
        self.player = player

    def rnd(self, board):
        empty_sqrs = board.get_empty_sqrs()
        idx = random.randrange(0, len(empty_sqrs))

        return empty_sqrs[idx]

    def minimax(self, board, maximizing):

        #terminal case
        case = board.final_state()

        #player 1 wins
        if case == 1:
            #print(board.string())
            if(self.player == 1):
                return -1, None #eval, move
            else:
                return 1, None
        #player 2 wins
        if case == 2:
            #print(board.string())
            if(self.player == 2):
                return -1, None #eval, move
            else:
                return 1, None
        #draw
        elif board.isfull():
            return 0, None

        if maximizing:
            max_eval = -100
            best_move = None
            empty_sqrs = board.get_empty_sqrs()

            for (row, col) in empty_sqrs:
                temp_board = copy.deepcopy(board)
                temp_board.mark_sqr(row, col, 2 if self.player == 1 else 1)
                eval = self.minimax(temp_board, False)[0]
                if eval > max_eval:
                    max_eval = eval
                    best_move = (row, col)

            return max_eval, best_move
        elif not maximizing:
            min_eval = 100
            best_move = None
            empty_sqrs = board.get_empty_sqrs()

            for (row, col) in empty_sqrs:
                temp_board = copy.deepcopy(board)
                temp_board.mark_sqr(row, col, self.player)
                eval = self.minimax(temp_board, True)[0]
                if eval < min_eval:
                    min_eval = eval
                    best_move = (row, col)

            return min_eval, best_move

    def eval(self, main_board):
        if self.level == 0:
            #random
            eval = 'random'
            move = self.rnd(main_board)
        else:
            #minimax algorithm choice
            eval, move = self.minimax(main_board, False)
        textMove = (move[0] + 1, move[1] + 1)
        outString = f'AI has chosen to mark the square in pos {textMove} with an eval of: {eval}'
        return outString, move #row, col
  
def findMove(level, player, boardstate):
  ai = AI(level=level,player=player)
  board = Board(boardstate)
  return ai.eval(board)

#print(findMove(1, 2, "xo_x_____"))
