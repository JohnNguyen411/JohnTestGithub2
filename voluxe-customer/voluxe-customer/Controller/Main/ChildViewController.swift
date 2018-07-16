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
    
    weak var childViewDelegate: ChildViewDelegate?
    
    func setTitle(title: String) {
        if let childViewDelegate = childViewDelegate {
            childViewDelegate.setTitleFromChild(title: title)
        } else {
            super.setTitle(title: title)
        }
    }
    
    
}

// MARK: protocol PickupDealershipDelegate

// TODO https://github.com/volvo-cars/ios/issues/314
// clarify the intent and use of this
protocol ChildViewDelegate: class {
    func setTitleFromChild(title: String)
    func pushViewController(controller: UIViewController, animated: Bool, backLabel: String?, title: String?)
}
