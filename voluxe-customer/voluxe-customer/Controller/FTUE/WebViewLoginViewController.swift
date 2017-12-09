//
//  WebViewLoginViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class WebViewLoginViewController: FTUEChildViewController, FTUEProtocol, UIWebViewDelegate {

    private let webview = UIWebView(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        webview.delegate = self
        webview.scalesPageToFit = false
        webview.autoresizesSubviews = true
        webview.isMultipleTouchEnabled = false
        webview.scrollView.bounces = false
        
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
        if let stringUrl = (request.url?.lastPathComponent) {
            if stringUrl.contains("callback") {
                do {
                    let responseString = try String(contentsOf: request.url!, encoding: String.Encoding.utf8)
                    if let json = convertToDictionary(text: responseString) {
                        let responseObject = ResponseObject<MappableDataObject<Token>>(json: json)
                        if let token = responseObject.data?.result?.token {
                            UserManager.sharedInstance.loginSuccess(token: token)
                            goToNext()
                        }
                    }
                } catch let error {
                    print(error)
                }
                return false
            }
            print(stringUrl)
        }
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    func didSelectPage() {
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
