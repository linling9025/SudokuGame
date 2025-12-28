//
//  CellView.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import SwiftUI

struct CellView: View {
    let cell: CellData
    let position: Position
    let isSelected: Bool
    let isHighlighted: Bool
    let hasError: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                    .border(Color.black.opacity(0.2), width: 1)
                
                if let value = cell.value {
                    Text("\(value)")
                        .font(.custom("Patrick Hand", size: 28))
                        .foregroundColor(cell.isGiven ? .black : Color.softBlue)
                } else if !cell.notes.isEmpty {
                    NotesGridView(notes: cell.notes)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var backgroundColor: Color {
        if hasError {
            return Color.softRed.opacity(0.4)
        } else if isSelected {
            return Color.softSelected
        } else if isHighlighted {
            return Color.softHighlight
        } else {
            return Color.white
        }
    }
}

struct NotesGridView: View {
    let notes: Set<Int>
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = min(geometry.size.width, geometry.size.height) / 3
            let fontSize = max(8, min(10, cellSize * 0.35))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                ForEach(1...9, id: \.self) { num in
                    Text(notes.contains(num) ? "\(num)" : "")
                        .font(.custom("Patrick Hand", size: fontSize * 1.2))
                        .foregroundColor(.black.opacity(0.5))
                        .frame(width: cellSize, height: cellSize)
                        .minimumScaleFactor(0.3)
                        .lineLimit(1)
                }
            }
            .padding(2)
        }
    }
}
