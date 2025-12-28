//
//  GameViewModel.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var board: Board = []
    @Published var solution: [[Int]] = []
    @Published var selectedCell: Position?
    @Published var selectedValue: Int?
    @Published var isNoteMode = false
    @Published var isSolved = false
    @Published var errors: Set<Position> = []
    @Published var difficulty: Difficulty?
    @Published var isLoading = false
    
    private let sudokuService = SudokuService()
    
    func startNewGame(difficulty: Difficulty) {
        self.difficulty = difficulty
        isLoading = true
        isSolved = false
        selectedCell = nil
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let result = self.sudokuService.generateSudoku(difficulty: difficulty)
            let initialBoard = result.puzzle.map { row in
                row.map { cellValue in
                    CellData(
                        value: cellValue == 0 ? nil : cellValue,
                        isGiven: cellValue != 0,
                        notes: []
                    )
                }
            }
            
            DispatchQueue.main.async {
                self.board = initialBoard
                self.solution = result.solution
                self.errors = self.sudokuService.checkBoard(initialBoard)
                self.isLoading = false
            }
        }
    }
    
    func selectCell(row: Int, col: Int) {
        let position = Position(row: row, col: col)
        let cellValue = board[row][col].value

        // 如果点击的是同一个单元格，取消选择
        if selectedCell == position {
            selectedCell = nil
            selectedValue = nil
        } else {
            selectedCell = position
            selectedValue = cellValue
        }
    }
    
    func inputNumber(_ num: Int) {
        guard let selected = selectedCell else { return }
        guard !board[selected.row][selected.col].isGiven else { return }

        var newBoard = board

        if isNoteMode {
            if newBoard[selected.row][selected.col].notes.contains(num) {
                newBoard[selected.row][selected.col].notes.remove(num)
            } else {
                newBoard[selected.row][selected.col].notes.insert(num)
            }
            newBoard[selected.row][selected.col].value = nil
            selectedValue = nil
        } else {
            newBoard[selected.row][selected.col].value = num
            newBoard[selected.row][selected.col].notes = []
            selectedValue = num
        }

        board = newBoard
        errors = sudokuService.checkBoard(board)

        checkIfSolved()
    }
    
    func erase() {
        guard let selected = selectedCell else { return }
        guard !board[selected.row][selected.col].isGiven else { return }

        var newBoard = board
        newBoard[selected.row][selected.col].value = nil
        newBoard[selected.row][selected.col].notes = []

        board = newBoard
        selectedValue = nil
        errors = sudokuService.checkBoard(board)
        isSolved = false
    }
    
    func toggleNoteMode() {
        isNoteMode.toggle()
    }
    
    private func checkIfSolved() {
        let isFull = board.allSatisfy { row in
            row.allSatisfy { $0.value != nil }
        }
        
        if isFull && errors.isEmpty {
            isSolved = true
        } else {
            isSolved = false
        }
    }
}
