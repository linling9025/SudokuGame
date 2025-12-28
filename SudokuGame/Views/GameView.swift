//
//  GameView.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import SwiftUI
import UIKit

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    let onGoToWelcome: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            // 基于屏幕宽度的比例计算
            let logoSize = screenWidth * 0.25  // logo占屏幕宽度的25%
            let clockSize = screenWidth * 0.09  // 时钟占屏幕宽度的9%
            let horizontalPadding = screenWidth * 0.05  // 左右边距为屏幕宽度的5%
            let headerSpacing = screenWidth * 0.025  // header内部间距
            let titleFontSize = screenWidth * 0.15  // 标题字体大小 - 增大
            let subtitleFontSize = screenWidth * 0.035  // 副标题字体大小

            ZStack {
                // 浅米色背景
                Color.lightBeige
                    .ignoresSafeArea()

                ZStack(alignment: .topTrailing) {
                    VStack(spacing: screenHeight * 0.02) {
                        // Header - 三列布局
                        HStack(spacing: headerSpacing) {
                            // 第一列：Sudoku图标
                            Image("sudoku")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: logoSize, height: logoSize)

                            // 第二列：文字区域
                            VStack(spacing: 4) {
                                Text("SUDOKU")
                                    .font(.custom("PatrickHand-Regular", size: titleFontSize))
                                    .foregroundColor(.black)

                                if let difficulty = viewModel.difficulty {
                                    Text("\(difficulty.displayName.uppercased()) LEVEL")
                                        .font(.custom("Patrick Hand", size: subtitleFontSize * 1.2))
                                        .foregroundColor(.black.opacity(0.5))
                                        .tracking(1)
                                }
                            }
                            .frame(maxWidth: .infinity)

                            // 第三列：留空占位,与闹钟图标宽度一致
                            Spacer()
                                .frame(width: clockSize)
                        }
                        .frame(height: logoSize)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.top, screenHeight * 0.015)
                
                Spacer()
                
                if viewModel.isLoading {
                        VStack(spacing: screenHeight * 0.02) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Generating puzzle...")
                                .font(.custom("Patrick Hand", size: screenWidth * 0.045))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .frame(width: screenWidth * 0.75, height: screenWidth * 0.75)
                        .background(Color.white)
                        .cornerRadius(screenWidth * 0.06)
                        .overlay(
                            RoundedRectangle(cornerRadius: screenWidth * 0.06)
                                .stroke(Color.black.opacity(0.2), lineWidth: 2.5)
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 3, y: 4)
                    } else {
                        ZStack {
                            // Sudoku Board - 卡片式设计
                            SudokuBoardView(
                                board: viewModel.board,
                                selectedCell: viewModel.selectedCell,
                                selectedValue: viewModel.selectedValue,
                                errors: viewModel.errors,
                                onCellTap: { row, col in
                                    viewModel.selectCell(row: row, col: col)
                                }
                            )
                            .padding(screenWidth * 0.05)
                            .background(Color.white)
                            .cornerRadius(screenWidth * 0.06)
                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 3, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: screenWidth * 0.06)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 2.5)
                            )
                            .padding(.horizontal, horizontalPadding)
                        
                            // Solved overlay
                            if viewModel.isSolved {
                                VStack(spacing: screenHeight * 0.03) {
                                    Text("🎉")
                                        .font(.system(size: screenWidth * 0.16))

                                    Text("SOLVED!")
                                        .font(.custom("Patrick Hand", size: screenWidth * 0.1))
                                        .foregroundColor(.black)
                                        .tracking(2)

                                    Button(action: {
                                        if let difficulty = viewModel.difficulty {
                                            viewModel.startNewGame(difficulty: difficulty)
                                        }
                                    }) {
                                        Text("NEW PUZZLE")
                                            .font(.custom("Patrick Hand", size: screenWidth * 0.045))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, screenWidth * 0.08)
                                            .padding(.vertical, screenHeight * 0.018)
                                            .background(Color.softGreen)
                                            .cornerRadius(screenWidth * 0.04)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: screenWidth * 0.04)
                                                    .stroke(Color.black.opacity(0.25), lineWidth: 2.5)
                                            )
                                            .shadow(color: Color.black.opacity(0.15), radius: 3, x: 2, y: 3)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.softGreen.opacity(0.95))
                                .cornerRadius(screenWidth * 0.06)
                                .shadow(color: Color.black.opacity(0.15), radius: 3, x: 2, y: 3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: screenWidth * 0.06)
                                        .stroke(Color.black.opacity(0.25), lineWidth: 2.5)
                                )
                                .padding(.horizontal, horizontalPadding)
                            }
                        }
                    }
                
                Spacer()
                
                        // Controls
                        if !viewModel.isLoading {
                            ControlsView(
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                onNumberInput: { num in
                                    viewModel.inputNumber(num)
                                },
                                onErase: {
                                    viewModel.erase()
                                },
                                onNewGame: {
                                    if let difficulty = viewModel.difficulty {
                                        viewModel.startNewGame(difficulty: difficulty)
                                    }
                                },
                                onGoToWelcome: onGoToWelcome,
                                isNoteMode: viewModel.isNoteMode,
                                onToggleNoteMode: {
                                    viewModel.toggleNoteMode()
                                }
                            )
                        }
                    }

                    // 时钟图标 - 独立定位在右上角
                    Image("clock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: clockSize, height: clockSize)
                        .padding(.top, screenHeight * 0.13)
                        .padding(.trailing, horizontalPadding)
                }
            }
        }
    }
}
