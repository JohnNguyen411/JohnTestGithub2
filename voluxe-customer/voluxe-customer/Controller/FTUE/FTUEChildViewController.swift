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

    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nextButton = UIBarButtonItem(title: rightButtonTitle(), style: .plain, target: self, action: #selector(self.nextButtonTap))
        self.navigationItem.rightBarButtonItem = nextButton
    }
    
    func rightButtonTitle() -> String {
        return .Next
    }
    
    func canGoNext(nextEnabled: Bool) {
        // disable/enable rightbar button
        self.navigationItem.rightBarButtonItem?.isEnabled = nextEnabled
    }
    
    func goToNext() {
    }
    
    @objc func nextButtonTap() {
        
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
