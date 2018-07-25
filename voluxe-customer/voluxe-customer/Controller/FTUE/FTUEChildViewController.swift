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
        self.navigationItem.rightBarButtonItem?.title = .Next
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
    
    
    func loadMainScreen() {
        AppController.sharedInstance.showLoadingView()
    }
    
    func loadLandingPage() {
        AppController.sharedInstance.startApp()
    }
    
    func checkTextFieldsValidity() -> Bool {
        return false
    }
}
