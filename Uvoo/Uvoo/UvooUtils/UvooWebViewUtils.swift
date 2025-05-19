import Foundation
import WebKit
import UIKit
import SnapKit

class UvooWebViewUtils: UIViewController {
    
    var webView: WKWebView!
    
    var webUrl: String = ""
    
    var webBack_button = UIButton(type: .custom)
    
    var containWeb = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
    }
    
    func setUI() {
        view.addSubview(webBack_button)
        view.addSubview(containWeb)
        
        webBack_button.translatesAutoresizingMaskIntoConstraints = false
        containWeb.translatesAutoresizingMaskIntoConstraints = false
        
        webBack_button.addTarget(self, action: #selector(webBack), for: .touchUpInside)
        webBack_button.tintColor = .black
        webBack_button.setImage(UIImage(named: "btnBack_black"), for: .normal)
        
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        containWeb.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let url = URL(string: self.webUrl) else { return }
        
        webView.load(URLRequest(url: url))
        
        webBack_button.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        containWeb.snp.makeConstraints { make in
            make.top.equalTo(webBack_button.snp.bottom)
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func webBack() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension UvooWebViewUtils: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {}
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {}
}
