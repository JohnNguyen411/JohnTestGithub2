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
import RealmSwift

class WebViewLoginViewController: FTUEChildViewController, FTUEProtocol, UIWebViewDelegate {
    
    private let webview = UIWebView(frame: .zero)
    var realm : Realm?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        
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
                        
                        if let tokenObject = responseObject.data?.result {
                            if let customerId = tokenObject.customerId {
                                
                                // Get Customer object with ID
                                UserManager.sharedInstance.loginSuccess(token: tokenObject.token)
                                CustomerAPI().getCustomer(id: customerId).onSuccess { result in
                                    if let customer = result?.data?.result {
                                        if let realm = self.realm {
                                            try? realm.write {
                                                realm.deleteAll()
                                                realm.add(customer)
                                            }
                                        }
                                        UserManager.sharedInstance.setCustomer(customer: customer)
                                        
                                        // Get Customer's Vehicles based on ID
                                        CustomerAPI().getVehicles(customerId: customerId).onSuccess { result in
                                            if let cars = result?.data?.result {
                                                if let realm = self.realm {
                                                    try? realm.write {
                                                        realm.add(cars, update: true)
                                                    }
                                                }
                                                UserManager.sharedInstance.setVehicles(vehicles: cars)
                                                self.goToNext()
                                            }
                                            
                                            }.onFailure { error in
                                                // todo show error
                                        }
                                    }
                                    }.onFailure { error in
                                        // todo show error
                                }
                            }
                        }
                    }
                } catch let error {
                    Logger.print(error)
                }
                return false
            }
            Logger.print(stringUrl)
        }
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    func didSelectPage() {
    }
    
    func nextButtonTap() -> Bool {
        return true
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                Logger.print(error.localizedDescription)
            }
        }
        return nil
    }
}
