//
//  ControlsView.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import SwiftUI

struct ControlsView: View {
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let onNumberInput: (Int) -> Void
    let onErase: () -> Void
    let onNewGame: () -> Void
    let onGoToWelcome: () -> Void
    let isNoteMode: Bool
    let onToggleNoteMode: () -> Void

    var body: some View {
        let buttonSpacing = screenWidth * 0.02
        let numberButtonHeight = screenHeight * 0.06
        let numberFontSize = screenWidth * 0.05
        let controlButtonHeight = screenHeight * 0.08
        let controlIconSize = screenWidth * 0.055
        let controlTextSize = screenWidth * 0.028
        let cornerRadius = screenWidth * 0.03
        let horizontalPadding = screenWidth * 0.05

        VStack(spacing: screenHeight * 0.02) {
            // Number buttons - 卡片式设计
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: buttonSpacing), count: 9), spacing: buttonSpacing) {
                ForEach(1...9, id: \.self) { num in
                    Button(action: { onNumberInput(num) }) {
                        Text("\(num)")
                            .font(.system(size: numberFontSize, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .frame(height: numberButtonHeight)
                            .background(Color.softBlue)
                            .foregroundColor(.white)
                            .cornerRadius(cornerRadius)
                            .shadow(color: Color.softBlue.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                }
            }
            
            // Control buttons - 卡片式设计
            HStack(spacing: buttonSpacing * 1.5) {
                // Erase button
                Button(action: onErase) {
                    VStack(spacing: screenHeight * 0.008) {
                        Image(systemName: "delete.left.fill")
                            .font(.system(size: controlIconSize))
                        Text("ERASE")
                            .font(.system(size: controlTextSize, weight: .semibold, design: .rounded))
                            .tracking(0.5)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: controlButtonHeight)
                    .background(Color.softOrange)
                    .foregroundColor(.white)
                    .cornerRadius(cornerRadius * 1.2)
                    .shadow(color: Color.softOrange.opacity(0.3), radius: 4, x: 0, y: 2)
                }

                // Note mode toggle
                Button(action: onToggleNoteMode) {
                    VStack(spacing: screenHeight * 0.008) {
                        Image(systemName: isNoteMode ? "pencil.circle.fill" : "pencil.circle")
                            .font(.system(size: controlIconSize))
                        Text("NOTES")
                            .font(.system(size: controlTextSize, weight: .semibold, design: .rounded))
                            .tracking(0.5)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: controlButtonHeight)
                    .background(isNoteMode ? Color.softGreen : Color.lightGray)
                    .foregroundColor(isNoteMode ? .white : .black.opacity(0.7))
                    .cornerRadius(cornerRadius * 1.2)
                    .shadow(color: (isNoteMode ? Color.softGreen : Color.lightGray).opacity(0.3), radius: 4, x: 0, y: 2)
                }

                // New game button
                Button(action: onNewGame) {
                    VStack(spacing: screenHeight * 0.008) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: controlIconSize))
                        Text("NEW")
                            .font(.system(size: controlTextSize, weight: .semibold, design: .rounded))
                            .tracking(0.5)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: controlButtonHeight)
                    .background(Color.softPurple)
                    .foregroundColor(.white)
                    .cornerRadius(cornerRadius * 1.2)
                    .shadow(color: Color.softPurple.opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
            
            // Back to menu button - 卡片式设计
            Button(action: onGoToWelcome) {
                Text("BACK TO MENU")
                    .font(.system(size: screenWidth * 0.035, weight: .semibold, design: .rounded))
                    .tracking(1)
                    .frame(maxWidth: .infinity)
                    .frame(height: screenHeight * 0.06)
                    .background(Color.white)
                    .foregroundColor(.black.opacity(0.7))
                    .cornerRadius(cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.bottom, screenHeight * 0.025)
        .background(Color.lightBeige)
    }
}
