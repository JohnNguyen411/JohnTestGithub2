//
//  Color.swift
//  voluxe-customer
//
//  Created by Christoph on 9/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Convenience funcs

extension UIColor {

    // TODO is there a good way to do this?
//    convenience init(hex: String) {}
}

// MARK:- Base colors

// TODO decouple from UIColor_Hex_Swift pod
struct Colors {

    struct Debug {
        static let red = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.1)
        static let gray = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }

    struct Gray {
        static let light = UIColor("#BBBBBB")
        static let dark = UIColor("#222222")
        static let medium = UIColor("#666666")
        static let charcoal = UIColor("#363b41")
        static let lightest = UIColor("#ECECEC")
    }

    struct Blue {
        static let dark = UIColor("#1d50b1")
        static let medium = UIColor("#243986")
        static let light = UIColor("#3f82d9")
    }

    struct Red {
        static let light = UIColor("#eb2853")
        static let medium = UIColor("#DA3731")
    }

    static let orange = UIColor("#FBEEE9")

    struct White {
        static let pure = UIColor.white
        static let off = UIColor("#F0FBFF")
    }
}

// MARK:- Colors by use

extension Colors {

    struct Background {
        // dark
        static let light = Colors.White.off
    }

    struct Button {
        // primary
        // secondary
    }
}

// MARK:- Random colors

extension Colors {

    static let blurTint = UIColor(hex6: 0xf1f1e0, alpha: 0.3)
}

// MARK:- Colors for asset catalog

// MARK:- Colors for UIAppearance

extension Colors {

    // TODO how to initialize without calling this func?
    static func initializeForUIAppearance() {
        // TODO what needs to be set?
        UINavigationBar.appearance().tintColor = .red
    }
}
