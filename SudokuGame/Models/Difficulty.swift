//
//  Difficulty.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import Foundation

enum Difficulty: String, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    var cellsToRemove: Int {
        switch self {
        case .easy: return 30
        case .medium: return 40
        case .hard: return 50
        }
    }
    
    var displayName: String {
        return rawValue.capitalized
    }
}
