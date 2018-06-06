//
//  UIFont+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/2/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    public class func volvoSansProMedium(size: CGFloat) -> UIFont   { return UIFont(name: "VolvoSansPro-Medium", size: size) ?? UIFont.systemFont(ofSize:size) }
    public class func volvoSansProBold(size: CGFloat) -> UIFont   { return UIFont(name: "VolvoSansPro-Bold", size: size) ?? UIFont.systemFont(ofSize:size) }
    public class func volvoSansProRegular(size: CGFloat) -> UIFont   { return UIFont(name: "VolvoSansPro-Regular", size: size) ?? UIFont.systemFont(ofSize:size) }
    public class func volvoSansProLight(size: CGFloat) -> UIFont   { return UIFont(name: "VolvoSansPro-Light", size: size) ?? UIFont.systemFont(ofSize:size) }
    
    
}
