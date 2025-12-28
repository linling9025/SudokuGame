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
    let selectedValue: Int?
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
                                    isValueHighlighted: isValueHighlighted(row: row, col: col),
                                    hasError: errors.contains(Position(row: row, col: col)),
                                    onTap: { onCellTap(row, col) }
                                )
                                .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
                
                // 3x3 box borders - 手绘风格粗边框
                VStack(spacing: 0) {
                    ForEach(0..<boxSize, id: \.self) { boxRow in
                        HStack(spacing: 0) {
                            ForEach(0..<boxSize, id: \.self) { boxCol in
                                Rectangle()
                                    .stroke(Color.black.opacity(0.4), lineWidth: 3.5)
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
        return selected.row == row || selected.col == col
    }

    private func isValueHighlighted(row: Int, col: Int) -> Bool {
        // 如果选中的单元格有值，高亮所有相同值所在单元格的行和列
        guard let value = selectedValue,
              let cellValue = board[row][col].value,
              cellValue == value else {
            return false
        }

        // 找到所有具有相同值的单元格位置
        var positions: [Position] = []
        for r in 0..<gridSize {
            for c in 0..<gridSize {
                if board[r][c].value == value {
                    positions.append(Position(row: r, col: c))
                }
            }
        }

        // 检查当前单元格是否在任何相同值单元格的行或列上
        for pos in positions {
            if row == pos.row || col == pos.col {
                return true
            }
        }

        return false
    }
}
