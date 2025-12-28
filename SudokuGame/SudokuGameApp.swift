//
//  SudokuGameApp.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import SwiftUI
import UIKit

@main
struct SudokuGameApp: App {
    @StateObject private var viewModel = GameViewModel()
    @State private var showWelcome = true

    init() {
        // 注册自定义字体
        if let fontURL = Bundle.main.url(forResource: "PatrickHand-Regular", withExtension: "ttf") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }

    var body: some Scene {
        WindowGroup {
            if showWelcome {
                WelcomeView { difficulty in
                    viewModel.startNewGame(difficulty: difficulty)
                    showWelcome = false
                }
            } else {
                GameView(viewModel: viewModel) {
                    showWelcome = true
                }
            }
        }
    }
}
