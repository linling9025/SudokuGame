//
//  GameModels.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import Foundation

struct Position: Equatable, Hashable {
    let row: Int
    let col: Int
}

struct CellData: Equatable {
    var value: Int?
    var isGiven: Bool
    var notes: Set<Int>
    
    init(value: Int? = nil, isGiven: Bool = false, notes: Set<Int> = []) {
        self.value = value
        self.isGiven = isGiven
        self.notes = notes
    }
}

typealias Board = [[CellData]]
