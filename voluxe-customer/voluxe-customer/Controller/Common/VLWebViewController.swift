//
//  VLWebViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class VLWebViewController: UIViewController, UIWebViewDelegate {
    
    private var webView: UIWebView = UIWebView()
    private var urlAddress: String
    
    init(urlAddress: String, title: String, showReloadButton: Bool) {
        self.urlAddress = urlAddress
        
        super.init(nibName: nil, bundle: nil)
        
        webView = UIWebView(frame: self.view.bounds)
        webView.delegate = self
        webView.scalesPageToFit = true
        view.addSubview(webView)
        
        self.title = title
        
        if showReloadButton {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(VLWebViewController.reloadCurrentPage))
        }
        
        if self.urlAddress == FTUESignupEmailPhoneViewController.tosURL {
            Analytics.trackView(screen: .termsOfService)
        } else if self.urlAddress == FTUESignupEmailPhoneViewController.privacyURL {
            Analytics.trackView(screen: .privacyPolicy)
        }
        
        
        loadURLAddress()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

internal extension VLWebViewController {
    @objc func reloadCurrentPage() {
        webView.reload()
    }
    
    func dismissSelf() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadURLAddress() {
        let url = URL(string: urlAddress)
        
        if let url = url {
            webView.loadRequest(URLRequest(url:url))
        }
    }
    
    func finishLoad() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: UIWebViewDelegate
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        finishLoad()
        
        if navigationItem.title == nil {
            webView.stringByEvaluatingJavaScript(from: "document.title")
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        finishLoad()
    }
}
