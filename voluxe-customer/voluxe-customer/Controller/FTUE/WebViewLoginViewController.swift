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
        webview.scalesPageToFit = true
        webview.autoresizesSubviews = true
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // final redirect: /v1/customers/login/callback
    }
    
    func setupViews() {
        self.view.addSubview(webview)
        webview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL(string: "\(Config.sharedInstance.apiEndpoint())/v1/customers/login")!
        webview.loadRequest(URLRequest(url: url))
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func didSelectPage() {
    }
}
