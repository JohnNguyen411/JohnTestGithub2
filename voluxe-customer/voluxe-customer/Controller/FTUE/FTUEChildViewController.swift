//
//  FTUEChildViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/22/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEChildViewController: UIViewController {

    var delegate: FTUEChildProtocol?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(delegate: FTUEChildProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func canGoNext(nextEnabled: Bool) {
        if let delegate = delegate {
            delegate.canGoNext(nextEnabled: nextEnabled)
        }
    }
    
    func goToNext() {
        if let delegate = delegate {
            delegate.goToNext()
        }
    }
    
    func checkTextFieldsValidity() -> Bool {
        return false
    }
}
