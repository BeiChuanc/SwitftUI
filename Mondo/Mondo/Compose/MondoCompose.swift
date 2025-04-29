//
//  MondoComposeIterm.swift
//  Mondo
//
//  Created by 北川 on 2025/4/27.
//

import SwiftUI
@preconcurrency import WebKit

// MARK: 举报组件
struct MondoReportItem: View {
    
    @Binding var isReport: Bool
    
    let confirm: () -> Void

    var body: some View {
        VStack {}
       .actionSheet(isPresented: $isReport) {
            ActionSheet(
                title: Text("More"),
                message: nil,
                buttons: [
                   .default(Text("Report Sexually Explicit Material")) {
                        confirm()
                        isReport = false
                    },
                   .default(Text("Report spam")) {
                        confirm()
                        isReport = false
                    },
                   .default(Text("Report something else")) {
                        confirm()
                        isReport = false
                    },
                   .default(Text("Block")) {
                        confirm()
                        isReport = false
                    },
                   .cancel {
                        isReport = false
                    }
                ]
            )
        }
    }
}

// MARK: LinkText
struct CombinedLinkTextItem: View {
    
    var placeholderOne: String
    
    var placeholderTwo: String
    
    var tarText: String
    
    var customFont: Font
    
    var tartColor: Color
    
    var higlitColor: Color
    
    var firstLink: URL
    
    var secondLink: URL
    
    @State var selectPro: URL?
    
    @State var showWebView: Bool = false
    
    var body: some View {
        VStack {
            Text(attributedString)
                .environment(\.openURL, OpenURLAction { url in
                    selectPro = url
                    showWebView = true
                    return .handled
                })
        }
        .fullScreenCover(isPresented: $showWebView) {
            NavigationStack {
                MondoWebItem(url: selectPro)
                    .frame(width: MONDOSCREEN.WIDTH,
                           height: MONDOSCREEN.HEIGHT)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: { showWebView = false }) {
                                Image("guide_back")
                            }
                        }
                    }
            }
        }
    }
    
    var attributedString: AttributedString {
        var attributedString = AttributedString(tarText)
        attributedString.font = customFont
        attributedString.foregroundColor = tartColor
        
        for link in [(text: placeholderOne, url: firstLink), (text: placeholderTwo, url: secondLink)] {
            if let range = attributedString.range(of: link.text) {
                attributedString[range].underlineStyle = .single
                attributedString[range].foregroundColor = higlitColor
                attributedString[range].link = link.url
            }
        }
        
        return attributedString
    }
}

// MARK: Web容器
struct MondoWebItem: UIViewRepresentable {
    
    var url: URL?
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var parent: MondoWebItem
        
        init(_ parent: MondoWebItem) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = url {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = url, uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
}

// MARK: 输入框Item
struct MondoTextFielfItem: UIViewRepresentable {
    
    @Binding var textInput: String
    
    var placeholder: String
    
    var interval: CGFloat
    
    var backgroundColor: UIColor = .gray
    
    var textColor: UIColor = .white

    var placeholderColor: UIColor = .gray
    
    var bordColor: UIColor = .clear
    
    var font: UIFont = UIFont()
    
    var radius: CGFloat = 0.0
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.leftPadding(interval)
        textField.delegate = context.coordinator
        textField.textColor = textColor
        textField.font = font
        textField.backgroundColor = backgroundColor
        textField.layer.borderWidth = 1
        textField.layer.borderColor = bordColor.cgColor
        textField.layer.cornerRadius = radius
        textField.layer.masksToBounds = true
        
        if let placeholder = textField.placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
        
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = textInput
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $textInput)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

// MARK: 自定义圆角
struct MondoRoundItem: Shape {
    
    var radius: CGFloat = .infinity
    
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: 隐藏返回按钮
struct MondoHidBack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
    }
}

// MARK: 消除按钮点击效果
struct MondoReEffort: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
           .foregroundStyle(.primary)
           .background(Color.clear)
    }
}

// MARK: 底部导航Item
struct MondoTabBarItem: View {
    
    var normalImage: String
    
    var selectImage: String
    
    var isSelected: Bool
    
    var isComplete: () -> Void
    
    var body: some View {
        Button(action: isComplete) { Image(isSelected ? selectImage : normalImage) }
            .frame(width: 28, height: 28)
            .buttonStyle(MondoReEffort())
    }
}

// MARK: 指示器
struct MondoIndicator: View {
    
    @Binding var currentGuide: Int
    
    let totalGuide: Int
    
    var currentColor: Color
    
    var unselectColor: Color
    
    var currentW: CGFloat
    
    var unselectW: CGFloat
    
    var normalH: CGFloat
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalGuide, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(index == currentGuide ? currentColor : unselectColor)
                    .frame(width: index == currentGuide ? currentW : unselectW, height: normalH)
            }
        }
    }
}
