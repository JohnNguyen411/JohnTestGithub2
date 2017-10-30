//
//  BaseViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/30/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import  UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleViews()
        setupViews()
    }
    
    func styleViews() {
        self.view.backgroundColor = UIColor.black
    }
    
    func setupViews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

