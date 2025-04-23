//
//  ErigoItem.swift
//  Erigo
//
//  Created by 北川 on 2025/4/18.
//

import SwiftUI
@preconcurrency import WebKit

// MARK: Text添加link链接&下划线
struct LinkTextView: View {
    
    var firstText: String
    
    var secondTxt: String
    
    var tarText: String
    
    var customFont: Font
    
    var tartColor: Color
    
    var higlitColor: Color
    
    var firstLink: URL
    
    var secondLink: URL
    
    @State var showWebView: Bool = false
    
    @State var selectPro: URL?
    
    var body: some View {
        VStack {
            RichComponent(
                tartText: tarText,
                links: [
                    (text: firstText, url: firstLink),
                    (text: secondTxt, url: secondLink)
                ],
                baseFont: customFont,
                baseColor: tartColor,
                linkColor: higlitColor
            )
            .environment(\.openURL, OpenURLAction { url in
                selectPro = url
                showWebView = true
                return .handled
            })
        }
        .fullScreenCover(isPresented: $showWebView) {
            NavigationStack {
                WebViewContainer(url: selectPro)
                    .frame(width: ERIGOSCREEN.WIDTH,
                           height: ERIGOSCREEN.HEIGHT)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: { showWebView = false }) {
                                Image("web_back")
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - 富文本组件
struct RichComponent: View {
    
    let tartText: String
    
    let links: [(text: String, url: URL)]
    
    let baseFont: Font
    
    let baseColor: Color
    
    let linkColor: Color
    
    var body: some View {
        Text(attributedString)
    }
    
    var attributedString: AttributedString {
        
        var attributedString = AttributedString(tartText)
        
        attributedString.font = baseFont
        
        attributedString.foregroundColor = baseColor
        
        for link in links {
            if let range = attributedString.range(of: link.text) {
                
                attributedString[range].underlineStyle = .single
                
                attributedString[range].foregroundColor = linkColor
                
                attributedString[range].link = link.url
            }
        }
        
        return attributedString
    }
}

// MARK: WebViewContainer
struct WebViewContainer: UIViewRepresentable {
    
    var url: URL?
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var parent: WebViewContainer
        
        init(_ parent: WebViewContainer) {
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


// MARK: 自定义输入框
struct ChatInputMes: UIViewRepresentable {
    
    @Binding var text: String
    
    var placeholder: String
    
    var leftPadding: CGFloat
    
    var textColor: UIColor = .white

    var placeholderColor: UIColor = .gray
    
    var textFont: UIFont = UIFont()
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.addLeftPadding(leftPadding)
        textField.delegate = context.coordinator
        textField.textColor = textColor
        textField.font = textFont
        textField.layer.cornerRadius = textField.frame.height / 2
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
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
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
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: 隐藏返回按钮
struct HideNavBack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
    }
}

// MARK: 消除按钮点击效果
struct ReButtonEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
           .foregroundStyle(.primary)
           .background(Color.clear)
    }
}
