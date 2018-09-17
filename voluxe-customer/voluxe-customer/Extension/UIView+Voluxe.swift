//
//  UIView+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    
    func animateAlpha(show: Bool) {
        if show && isHidden {
            self.alpha = 0
            self.isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = show ? 1 : 0
        }) { (finished) in
            if finished {
                self.isHidden = show ? false : true
            }
        }
    }
    
    // Be careful with this API.  Actively changing the height constraint will
    // affect how UILabel determine's its height with autolayout.  In general,
    // you'll want Autolayout to determine height from intrinsic content and
    // in the case of UILabel, this is the number of lines of text.
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
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
    
    
    
    var hasSafeAreaCapability: Bool {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return true
            }
        #endif
        return false
    }
    
    var safeArea: ConstraintBasicAttributesDSL {
        
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.snp
            }
            return self.snp
        #else
            return self.snp
        #endif
    }
    
    var safeAreaBottomHeight: CGFloat {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return self.safeAreaInsets.bottom
            }
            return 0
        #else
            return 0
        #endif
    }
    
}
