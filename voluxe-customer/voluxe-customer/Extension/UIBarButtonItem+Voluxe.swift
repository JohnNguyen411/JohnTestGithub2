//
//  UIBarButtonItem+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/15/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

extension CAShapeLayer {
    
    func drawRoundedRect(rect: CGRect, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        path = UIBezierPath(roundedRect: rect, cornerRadius: 7).cgPath
    }
    
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
    
    // returns true if badge was added, false otherwise
    func addBadge() -> Bool {
        
        guard let view = self.value(forKey: "view") as? UIView else { return false}
        guard let image = self.image else { return false}

        //initialize Badge
        let badge = CAShapeLayer()
        
        let bHeight: CGFloat = 10.0
        let bWidth: CGFloat = 10.0
        
        let imgHeightInsetPadding: CGFloat = 6
        let imgWidthInsetPadding: CGFloat = 3

        let imageSize = image.size
        
        //x position is offset from right-hand side
        let x = imageSize.width + ((view.frame.width - imageSize.width) / 2) - (bWidth + imgWidthInsetPadding)
        let y = ((view.frame.height - imageSize.height) / 2) - bHeight/2 + imgHeightInsetPadding
        
        let badgeFrame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: bWidth, height: bHeight))
        
        badge.drawRoundedRect(rect: badgeFrame, andColor: UIColor.luxeOrange(), filled: true)
        view.layer.addSublayer(badge)
        
        //save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        //bring layer to front
        badge.zPosition = 1000
 
        return true
    }
    
    
}
