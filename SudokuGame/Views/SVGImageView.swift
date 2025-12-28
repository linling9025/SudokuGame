//
//  SVGImageView.swift
//  SudokuGame
//
//  Created on 2025-12-26.
//

import SwiftUI
import WebKit

struct SVGImageView: View {
    let fileName: String
    let height: CGFloat
    let maxWidth: CGFloat?
    let isBackground: Bool
    
    init(fileName: String, height: CGFloat, maxWidth: CGFloat? = nil, isBackground: Bool = false) {
        self.fileName = fileName
        self.height = height
        self.maxWidth = maxWidth
        self.isBackground = isBackground
    }
    
    var body: some View {
        Group {
            if Bundle.main.url(forResource: fileName, withExtension: "svg") != nil {
                SVGWebView(fileName: fileName, height: height, maxWidth: maxWidth)
                    .frame(height: height)
                    .frame(maxWidth: maxWidth)
                    .opacity(isBackground ? 0.15 : 1.0)
            } else {
                // 后备方案：如果 SVG 文件不存在，显示文字标题
                Text("SUDOKU")
                    .font(.custom("Aeonik Mono", size: height * 0.8))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .tracking(3)
                    .opacity(isBackground ? 0.15 : 1.0)
            }
        }
    }
}

struct SVGWebView: UIViewRepresentable {
    let fileName: String
    let height: CGFloat
    let maxWidth: CGFloat?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        // 尝试从 bundle 加载 SVG
        if let url = Bundle.main.url(forResource: fileName, withExtension: "svg"),
           let svgContent = try? String(contentsOf: url, encoding: .utf8) {
            // 创建 HTML 包装 SVG，确保正确缩放
            let widthConstraint = maxWidth != nil ? "max-width: \(maxWidth!)px;" : ""
            let html = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }
                    html, body {
                        width: 100%;
                        height: 100%;
                        overflow: hidden;
                        background: transparent;
                    }
                    body {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                    }
                    svg {
                        width: 100%;
                        height: auto;
                        max-height: 100%;
                        \(widthConstraint)
                        display: block;
                    }
                </style>
            </head>
            <body>
                \(svgContent)
            </body>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // No updates needed
    }
}

