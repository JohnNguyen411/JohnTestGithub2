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
    
    
    func changeVisibility(show: Bool, alpha: Bool, animated: Bool, height: CGFloat) {
        if animated {
            if show {
                self.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    if alpha {
                        self.alpha = show ? 1 : 0
                    }
                    self.snp.updateConstraints { make in
                        make.height.equalTo(height)
                    }
                    self.superview?.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    if alpha {
                        self.alpha = show ? 1 : 0
                    }
                    self.snp.updateConstraints { make in
                        make.height.equalTo(0)
                    }
                    self.superview?.layoutIfNeeded()
                }){ (finished) in
                    if finished {
                        self.isHidden = true
                    }
                }
            }
            
        } else {
            self.snp.updateConstraints { make in
                make.height.equalTo(show ? height : 0)
            }
            if alpha {
                self.alpha = show ? 1 : 0
            }
        }
    }
}
