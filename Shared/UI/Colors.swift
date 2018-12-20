//
//  Colors.swift
//  voluxe-driver
//
//  Created by Christoph on 12/17/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

/// Colors is an umbrella protocol that combines colors by family
/// and by use.  This allows clients to make a complete color
/// implementation and write UI code against it, then swap out later
/// with a different implementation and not have to update a bunch
/// of code.  It also, hopefully, allows designers to come up with
/// a creatively named palette that can be represented in code.
///
/// HOW TO USE
/// 1.  Add Colors.swift and ColorsImplementation.swift to project
/// 2.  Subclass ColorsImplementation
/// 3.  Provide implementations for the desired colors and shades
/// 4.  Provide an extension for "designer" colors by name
/// 5.  Subclass BackgroundColors, NavigationBarColors, etc
///
/// ColorsImplementation is an abstract class, so your project will
/// not run if only using that as an implementation.  By default
/// it will assert for DEBUG targets, but that can be changed to
/// return a default color instead.
///
/// You are free to ignore that class and implementation the Colors
/// protocols yourself, or use VolvoColors as a base class if you
/// only want to change a couple colors.

enum ColorsShade {
    case darkest
    case darker
    case dark
    case normal
    case light
    case lighter
    case lightest
}

// MARK:- Colors by family

protocol BaseColors {

    // MARK: Monochrome

    var black: UIColor { get }
    var white: UIColor { get }

    // MARK: Primary

    var red: UIColor { get }
    var green: UIColor { get }
    var blue: UIColor { get }

    func red(_ shade: ColorsShade) -> UIColor
    func green(_ shade: ColorsShade) -> UIColor
    func blue(_ shade: ColorsShade) -> UIColor

    // MARK: Secondary

    var brown: UIColor { get }
    var grey: UIColor { get }
    var orange: UIColor { get }
    var purple: UIColor { get }
    var yellow: UIColor { get }

    func brown(_ shade: ColorsShade) -> UIColor
    func grey(_ shade: ColorsShade) -> UIColor
    func orange(_ shade: ColorsShade) -> UIColor
    func purple(_ shade: ColorsShade) -> UIColor
    func yellow(_ shade: ColorsShade) -> UIColor
}

// MARK:- Colors by use

protocol BackgroundColors {
    var light: UIColor { get }
    var dark: UIColor { get }
}

protocol NavigationBarColors {
    var background: UIColor { get }
    var button: UIColor { get }
    var title: UIColor { get }
}

protocol TableColors {
    var separator: UIColor { get }
}

protocol ButtonColors {
    var primary: UIColor { get }
    var secondary: UIColor { get }
}

// MARK:- Umbrella color protocol

protocol Colors: BaseColors {
    var background: BackgroundColors { get }
    var navigationBar: NavigationBarColors { get }
    var table: TableColors { get }
}
