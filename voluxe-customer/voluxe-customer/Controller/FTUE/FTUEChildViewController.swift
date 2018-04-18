//
//  FTUEChildViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/22/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEChildViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nextButton = UIBarButtonItem(title: rightButtonTitle(), style: .plain, target: self, action: #selector(self.nextButtonTap))
        self.navigationItem.rightBarButtonItem = nextButton
    }
    
    
    func rightButtonTitle() -> String {
        return .Next
    }
    
    func canGoBack(backEnabled: Bool) {
        if !backEnabled {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        
    }
    
    func canGoNext(nextEnabled: Bool) {
        // disable/enable rightbar button
        self.navigationItem.rightBarButtonItem?.isEnabled = nextEnabled
    }
    
    func goToNext() {
    }
    
    @objc func nextButtonTap() {
        
    }
    
    @objc func backButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadMainScreen() {
        appDelegate?.loadMainScreen()
    }
    
    func loadLandingPage() {
        appDelegate?.startApp()
    }
    
    func checkTextFieldsValidity() -> Bool {
        return false
    }
}
