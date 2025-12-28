//
//  WelcomeView.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import SwiftUI

struct WelcomeView: View {
    let onStartGame: (Difficulty) -> Void
    
    var body: some View {
        ZStack {
            // 浅米色背景
            Color.lightBeige
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack(spacing: geometry.size.height * 0.05) {
                    Spacer()

                    // Title Section
                    VStack(spacing: geometry.size.height * 0.025) {
                        // 标题 - 九宫格图标 + SUDOKU
                        HStack(spacing: geometry.size.width * 0.06) {
                            // 九宫格图标
                            Image("sudoku")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.25)

                            // SUDOKU 文字
                            Text("SUDOKU")
                                .font(.custom("Patrick Hand", size: geometry.size.width * 0.16))
                                .foregroundColor(.black)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        }

                        Text("Choose your difficulty level")
                            .font(.custom("Patrick Hand", size: geometry.size.width * 0.05))
                            .foregroundColor(.black.opacity(0.7))
                            .minimumScaleFactor(0.8)
                    }

                    // Difficulty buttons - 卡片式设计
                    VStack(spacing: geometry.size.height * 0.02) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Button(action: { onStartGame(difficulty) }) {
                                HStack(spacing: geometry.size.width * 0.04) {
                                    Text(difficulty.displayName.uppercased())
                                        .font(.custom("Patrick Hand", size: geometry.size.width * 0.06))
                                        .foregroundColor(.black)

                                    Spacer()

                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: geometry.size.width * 0.06))
                                        .foregroundColor(.black.opacity(0.6))
                                }
                                .padding(.horizontal, geometry.size.width * 0.06)
                                .padding(.vertical, geometry.size.height * 0.025)
                                .frame(maxWidth: .infinity)
                                .background(cardColorForDifficulty(difficulty))
                                .cornerRadius(geometry.size.width * 0.05)
                                .overlay(
                                    RoundedRectangle(cornerRadius: geometry.size.width * 0.05)
                                        .stroke(Color.black.opacity(0.25), lineWidth: 2.5)
                                )
                                .shadow(color: Color.black.opacity(0.15), radius: 3, x: 2, y: 3)
                            }
                        }
                    }
                    .padding(.horizontal, geometry.size.width * 0.06)

                    Spacer()
                }
                .padding(.vertical, geometry.size.height * 0.02)
            }
        }
    }
    
    private func cardColorForDifficulty(_ difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy:
            return Color.softGreen.opacity(0.3)
        case .medium:
            return Color.softYellow.opacity(0.3)
        case .hard:
            return Color.softOrange.opacity(0.3)
        }
    }
}
