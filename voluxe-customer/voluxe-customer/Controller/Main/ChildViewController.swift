//
//  ChildViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/20/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class ChildViewController: BaseViewController {
    
    var childViewDelegate: ChildViewDelegate?
    
    func setTitle(title: String) {
        if let childViewDelegate = childViewDelegate {
            childViewDelegate.setTitleFromChild(title: title)
        }
    }
    
    
}

// MARK: protocol PickupDealershipDelegate
protocol ChildViewDelegate: class {
    func setTitleFromChild(title: String)
    func pushViewController(controller: UIViewController, animated: Bool, backLabel: String?, title: String?)
}
