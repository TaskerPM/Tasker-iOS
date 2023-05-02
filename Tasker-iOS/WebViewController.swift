//
//  WebViewController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/02.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView = WKWebView(frame: .zero)
    var indicator = UIActivityIndicatorView()
    var linkString: String
    
    init(linkString: String) {
        self.linkString = linkString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        configureUI()
        loadWebView()
    }
    
    private func configureUI() {
        [webView, indicator].forEach(view.addSubview)
        
        let safeArea = view.safeAreaLayoutGuide
        
        webView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
        
        indicator.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    private func loadWebView() {
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: self?.linkString ?? "") else {
                print("😏😏😏")
                return
                
            }
            let request = URLRequest(url: url)
            
            DispatchQueue.main.async {
                self?.webView.load(request)
            }
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
