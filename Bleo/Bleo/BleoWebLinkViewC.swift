import Foundation
import WebKit
import UIKit
import SnapKit

class BleoWebLinkViewC: UIViewController, RoutableParameter {
    
    var backWebBt: UIButton = UIButton(type: .custom)
    
    var webView: WKWebView!
    
    var webLink: String = ProtocolLink.TERMLINK
    
    var webViewContainer: UIView = UIView()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        setWebViewUI()
    }
    
    func setWebViewUI() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.navigationDelegate = self
        
        view.addSubview(backWebBt)
        view.addSubview(webViewContainer)
        
        backWebBt.translatesAutoresizingMaskIntoConstraints = true
        webViewContainer.translatesAutoresizingMaskIntoConstraints = true
        
        backWebBt.setImage(UIImage(named: "back_b"), for: .normal)
        backWebBt.addTarget(self, action: #selector(webBack), for: .touchUpInside)
        
        backWebBt.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        webViewContainer.snp.makeConstraints { make in
            make.top.equalTo(backWebBt.snp.bottom)
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        webViewContainer.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        webView.load(URLRequest(url: URL(string: webLink)!))
    }
    
    func configure(with parameters: [String : Any]) {
        let url = parameters["url"] as? String ?? ""
        webLink = url
    }
    
    @objc func webBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension BleoWebLinkViewC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {}
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {}
}
