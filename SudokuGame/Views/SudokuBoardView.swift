//
//  SudokuBoardView.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import SwiftUI

struct SudokuBoardView: View {
    let board: Board
    let selectedCell: Position?
    let errors: Set<Position>
    let onCellTap: (Int, Int) -> Void
    
    private let gridSize = 9
    private let boxSize = 3
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = min(geometry.size.width, geometry.size.height) / CGFloat(gridSize)
            
            ZStack {
                // Background - 浅米色
                Rectangle()
                    .fill(Color.lightBeige)
                
                // Cells
                VStack(spacing: 0) {
                    ForEach(0..<gridSize, id: \.self) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<gridSize, id: \.self) { col in
                                CellView(
                                    cell: board[row][col],
                                    position: Position(row: row, col: col),
                                    isSelected: isSelected(row: row, col: col),
                                    isHighlighted: isHighlighted(row: row, col: col),
                                    hasError: errors.contains(Position(row: row, col: col)),
                                    onTap: { onCellTap(row, col) }
                                )
                                .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
                
                // 3x3 box borders - 更粗的边框
                VStack(spacing: 0) {
                    ForEach(0..<boxSize, id: \.self) { boxRow in
                        HStack(spacing: 0) {
                            ForEach(0..<boxSize, id: \.self) { boxCol in
                                Rectangle()
                                    .stroke(Color.black.opacity(0.3), lineWidth: 3)
                                    .frame(
                                        width: cellSize * CGFloat(boxSize),
                                        height: cellSize * CGFloat(boxSize)
                                    )
                            }
                        }
                    }
                }
            }
            .frame(width: cellSize * CGFloat(gridSize), height: cellSize * CGFloat(gridSize))
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func isSelected(row: Int, col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        return selected.row == row && selected.col == col
    }
    
    private func isHighlighted(row: Int, col: Int) -> Bool {
        guard let selected = selectedCell else { return false }
        return selected.row == row || selected.col == col ||
            (selected.row / boxSize == row / boxSize && selected.col / boxSize == col / boxSize)
    }
}
