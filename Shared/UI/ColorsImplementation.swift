//
//  ColorsImplementation.swift
//  voluxe-driver
//
//  Created by Christoph on 12/17/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

/// An abstract implementation of the Colors protocol.  This
/// is intended to be used as a base class for a specific
/// Colors implementation without clients needing to write
/// the class from scratch.  Clients are encouraged to subclass
/// and override var and func implementations as necessary.  See
/// Colors+Volvo for an example.
class ColorsImplementation: Colors {

    // MARK: Monochrome

    var black: UIColor      { assertionFailure("Color not implemented"); return .clear }
    var white: UIColor      { assertionFailure("Color not implemented"); return .clear }

    // MARK: Primary

    var red: UIColor { return self.red() }
    var green: UIColor { return self.green() }
    var blue: UIColor { return self.blue() }

    func red(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            default: assertionFailure("Color not implemented"); return .clear
        }
    }

    func blue(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            default: assertionFailure("Color not implemented"); return .clear
        }
    }

    func green(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            default: assertionFailure("Color not implemented"); return .clear
        }
    }

    // MARK: Secondary

    var brown: UIColor { return self.brown() }
    var grey: UIColor { return self.grey() }
    var orange: UIColor { return self.orange() }
    var purple: UIColor { return self.purple() }
    var yellow: UIColor { return self.yellow() }

    func brown(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            default: assertionFailure("Color not implemented"); return .clear
        }
    }

    func grey(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            default: assertionFailure("Color not implemented"); return .clear
        }
    }

    func orange(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            default: assertionFailure("Color not implemented"); return .clear
        }
    }

    func purple(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            default: assertionFailure("Color not implemented"); return .clear
        }
    }

    func yellow(_ shade: ColorsShade = .normal) -> UIColor {
        switch shade {
            default: assertionFailure("Color not implemented"); return .clear
        }
    }

    // MARK:- Colors by use

    var background: BackgroundColors = BackgroundColorsImplementation()
    var navigationBar: NavigationBarColors = NavigationBarColorsImplementation()
    var table: TableColors = TableColorsImplementation()
}

class BackgroundColorsImplementation: BackgroundColors {
    var light: UIColor      { assertionFailure("Color not implemented"); return .clear }
    var dark: UIColor       { assertionFailure("Color not implemented"); return .clear }
}

class NavigationBarColorsImplementation: NavigationBarColors {
    var background: UIColor { assertionFailure("Color not implemented"); return .clear }
    var title: UIColor      { assertionFailure("Color not implemented"); return .clear }
}

class TableColorsImplementation: TableColors {
    var separator: UIColor  { assertionFailure("Color not implemented"); return .clear }
}

// TODO UIAppearance extension?
