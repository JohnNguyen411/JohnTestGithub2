//
//  WebViewLoginViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class WebViewLoginViewController: FTUEChildViewController, FTUEProtocol, UIWebViewDelegate {

    private let webview = UIWebView(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        webview.delegate = self
    }
    
    func setupViews() {
        self.view.addSubview(webview)
        webview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func didSelectPage() {
        
    }
}
