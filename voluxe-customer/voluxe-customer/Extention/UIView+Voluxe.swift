//
//  UIView+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func animateAlpha(show: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = show ? 1 : 0
        }) { (finished) in
            if finished {
                self.isHidden = show ? false : true
            }
        }
    }
}
