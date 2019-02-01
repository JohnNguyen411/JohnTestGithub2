//
//  ContentHorizontalAlignment+LTR.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension UIControl.ContentHorizontalAlignment {
    
    static func leftOrLeading() -> UIControl.ContentHorizontalAlignment {
        if #available(iOS 11.0, *) {
            return .leading
        } else {
            return .left
        }
    }
    
    static func rightOrTrailing() -> UIControl.ContentHorizontalAlignment {
        if #available(iOS 11.0, *) {
            return .trailing
        } else {
            return .right
        }
        
    }
    
}
