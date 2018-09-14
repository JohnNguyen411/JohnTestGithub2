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
    
    static let volvoSansProLight = "VolvoSansPro-Light"
    static let volvoSansProRegular = "VolvoSansPro-Regular"
    static let volvoSansProMedium = "VolvoSansPro-Medium"
    static let volvoSansProBold = "VolvoSansPro-Bold"
    static let volvoSansProSuper = "VolvoSansPro-Super"

    static let volvoNovumLight = "VolvoNovum-Light"
    static let volvoNovumSemiLight = "VolvoNovum-SemiLight"
    static let volvoNovumRegular = "VolvoNovum-Regular"
    static let volvoNovumMedium = "VolvoNovum-Medium"
    static let volvoNovumBold = "VolvoNovum-Bold"
    
    static let volvoNovumLightItalic = "VolvoNovum-LightItalic"
    static let volvoNovumSemiLightItalic = "VolvoNovum-SemiLightItalic"
    static let volvoNovumRegularItalic = "VolvoNovum-Italic"
    static let volvoNovumMediumItalic = "VolvoNovum-MediumItalic"
    static let volvoNovumBoldItalic = "VolvoNovum-BoldItalic"

    public class func volvoSansProLight(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoSansProLight, size: size) }
    public class func volvoSansProRegular(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoSansProRegular, size: size) }
    public class func volvoSansProMedium(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoSansProMedium, size: size) }
    public class func volvoSansProBold(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoSansProBold, size: size) }

    // TODO not used
    @available(*, deprecated)
    public class func volvoSansProSuper(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoSansProSuper, size: size) }

    public class func volvoNovumLight(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumLight, size: size) }
    public class func volvoNovumSemiLight(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumSemiLight, size: size) }
    public class func volvoNovumRegular(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumRegular, size: size) }
    public class func volvoNovumMedium(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumMedium, size: size) }
    public class func volvoNovumBold(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumBold, size: size) }
    
    public class func volvoNovumLightItalic(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumLightItalic, size: size) }
    public class func volvoNovumSemiLightItalic(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumSemiLightItalic, size: size) }
    public class func volvoNovumRegularItalic(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumRegularItalic, size: size) }
    public class func volvoNovumMediumItalic(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumMediumItalic, size: size) }
    public class func volvoNovumBoldItalic(size: CGFloat) -> UIFont   { return UIFont.customFont(fontName: UIFont.volvoNovumBoldItalic, size: size) }

    
    public class func customFont(fontName: String, size: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize:size)
    }
}
