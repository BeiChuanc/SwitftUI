//
//  PeppyWebViewPage.swift
//  Peppy
//
//  Created by 北川 on 2025/4/12.
//

import SwiftUI
import WebKit

// MARK: WebView容器
struct PeppyWebViewPage: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
