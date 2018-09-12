//
//  ViewUtils.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 8/2/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/***
 Design specs are made based on iPhone 6 screen, on most of the screen it doesn't matter.
 But on this particular screen, it doesn't fit and we can't put that in an other ScrollView
 We can use this method to convert height value from iPhone 6 to the users screen height
 ***/
class ViewUtils {
    
    private static let iphone6HeightPoints: CGFloat = 667
    private static let iphone6WidthPoints: CGFloat = 667
    
    static var screenSize: CGSize?
    
    func setScreenSizeIfNeeded(screenSize: CGSize) {
        if ViewUtils.screenSize == nil {
            ViewUtils.screenSize = screenSize
        }
    }
    
    // return the height in point for the sizeInPoints dimension based on iPhone 6
    public static func getAdaptedHeightSize(sizeInPoints: CGFloat, smallerOnly: Bool = true) -> CGFloat {
        if let screenSize = ViewUtils.screenSize {
            let adapted = ((sizeInPoints/iphone6HeightPoints) * screenSize.height)
            if smallerOnly && adapted > sizeInPoints {
                return sizeInPoints
            }
            return adapted
        }
        return sizeInPoints
    }
    
    // return the width in point for the sizeInPoints dimension based on iPhone 6
    public static func getAdaptedWidthSize(sizeInPoints: CGFloat, smallerOnly: Bool = true) -> CGFloat {
        if let screenSize = ViewUtils.screenSize {
            let adapted = ((sizeInPoints/iphone6WidthPoints) * screenSize.width)
            if smallerOnly && adapted > sizeInPoints {
                return sizeInPoints
            }
        }
        return sizeInPoints
    }
    
    public static func addShadow(toView: UIView) {
        toView.layer.masksToBounds = false
        toView.layer.shadowColor = UIColor.black.cgColor
        toView.layer.shadowOpacity = 0.5
        toView.layer.shadowRadius = 2
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
}
