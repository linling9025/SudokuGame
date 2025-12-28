//
//  SudokuService.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import Foundation

class SudokuService {
    private let size = 9
    private let boxSize = 3
    
    // MARK: - Puzzle Generation
    
    func generateSudoku(difficulty: Difficulty) -> (puzzle: [[Int]], solution: [[Int]]) {
        var board = Array(repeating: Array(repeating: 0, count: size), count: size)
        solve(&board)
        let solution = board
        
        var cellsToRemove = difficulty.cellsToRemove
        var attempts = cellsToRemove * 2
        
        while cellsToRemove > 0 && attempts > 0 {
            let row = Int.random(in: 0..<size)
            let col = Int.random(in: 0..<size)
            
            if board[row][col] != 0 {
                board[row][col] = 0
                cellsToRemove -= 1
            }
            attempts -= 1
        }
        
        return (puzzle: board, solution: solution)
    }
    
    // MARK: - Solving Algorithm
    
    private func solve(_ board: inout [[Int]]) -> Bool {
        guard let (row, col) = findEmpty(board) else {
            return true
        }
        
        let numbers = (1...9).shuffled()
        
        for num in numbers {
            if isValid(board, row: row, col: col, num: num) {
                board[row][col] = num
                if solve(&board) {
                    return true
                }
                board[row][col] = 0
            }
        }
        
        return false
    }
    
    private func findEmpty(_ board: [[Int]]) -> (row: Int, col: Int)? {
        for r in 0..<size {
            for c in 0..<size {
                if board[r][c] == 0 {
                    return (r, c)
                }
            }
        }
        return nil
    }
    
    private func isValid(_ board: [[Int]], row: Int, col: Int, num: Int) -> Bool {
        // Check row and column
        for i in 0..<size {
            if board[row][i] == num && i != col {
                return false
            }
            if board[i][col] == num && i != row {
                return false
            }
        }
        
        // Check 3x3 box
        let boxRowStart = (row / boxSize) * boxSize
        let boxColStart = (col / boxSize) * boxSize
        
        for r in 0..<boxSize {
            for c in 0..<boxSize {
                let currentRow = boxRowStart + r
                let currentCol = boxColStart + c
                if board[currentRow][currentCol] == num && (currentRow != row || currentCol != col) {
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK: - Board Validation
    
    func checkBoard(_ board: Board) -> Set<Position> {
        var errors = Set<Position>()
        
        // Check rows and columns
        for i in 0..<size {
            var rowValues: [Int: [Int]] = [:]
            var colValues: [Int: [Int]] = [:]
            
            for j in 0..<size {
                // Check row
                if let value = board[i][j].value {
                    rowValues[value, default: []].append(j)
                }
                
                // Check column
                if let value = board[j][i].value {
                    colValues[value, default: []].append(j)
                }
            }
            
            // Add errors for duplicate values in row
            for (_, cols) in rowValues where cols.count > 1 {
                for c in cols {
                    errors.insert(Position(row: i, col: c))
                }
            }
            
            // Add errors for duplicate values in column
            for (_, rows) in colValues where rows.count > 1 {
                for r in rows {
                    errors.insert(Position(row: r, col: i))
                }
            }
        }
        
        // Check 3x3 boxes
        for boxRow in 0..<boxSize {
            for boxCol in 0..<boxSize {
                var boxValues: [Int: [Position]] = [:]
                
                for i in 0..<boxSize {
                    for j in 0..<boxSize {
                        let r = boxRow * boxSize + i
                        let c = boxCol * boxSize + j
                        
                        if let value = board[r][c].value {
                            boxValues[value, default: []].append(Position(row: r, col: c))
                        }
                    }
                }
                
                // Add errors for duplicate values in box
                for (_, positions) in boxValues where positions.count > 1 {
                    for pos in positions {
                        errors.insert(pos)
                    }
                }
            }
        }
        
        return errors
    }
}
