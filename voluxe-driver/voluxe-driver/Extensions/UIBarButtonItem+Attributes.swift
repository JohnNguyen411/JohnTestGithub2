//
//  UIBarButtonItem+Attributes.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/28/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    static func styleBarButtonItem(barButton: UIBarButtonItem) {
        barButton.setTitleTextAttributes([
            NSAttributedString.Key.font : Font.Medium.medium,
            NSAttributedString.Key.foregroundColor : UIColor.Volvo.brightBlue],
                                         for: UIControl.State.normal)
        
        barButton.setTitleTextAttributes([
            NSAttributedString.Key.font : Font.Medium.medium,
            NSAttributedString.Key.foregroundColor : UIColor.Volvo.granite],
                                         for: UIControl.State.selected)
        
        barButton.setTitleTextAttributes([
            NSAttributedString.Key.font : Font.Medium.medium,
            NSAttributedString.Key.foregroundColor : UIColor.Volvo.grey1],
                                         for: UIControl.State.disabled)
    }
    
}
