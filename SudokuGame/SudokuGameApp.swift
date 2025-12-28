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
        // 检查字体是否被加载
        if let fontURL = Bundle.main.url(forResource: "PatrickHand-Regular", withExtension: "ttf") {
            print("✅ Font file found in bundle: \(fontURL)")

            // 手动注册字体
            var error: Unmanaged<CFError>?
            if CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
                print("✅ Font registered successfully")
            } else {
                print("❌ Font registration failed: \(error.debugDescription)")
            }
        } else {
            print("❌ Font file NOT found in bundle")
        }

        // 列出所有可用字体
        print("📋 Available fonts containing 'Patrick':")
        UIFont.familyNames.sorted().forEach { family in
            if family.lowercased().contains("patrick") {
                print("  Family: \(family)")
                UIFont.fontNames(forFamilyName: family).forEach { font in
                    print("    - \(font)")
                }
            }
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
