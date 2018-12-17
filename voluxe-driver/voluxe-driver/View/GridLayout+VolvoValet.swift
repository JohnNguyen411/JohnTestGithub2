//
//  GridLayout+VolvoValet.swift
//  voluxe-driver
//
//  Created by Christoph on 12/10/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension GridLayout {

    // TODO rename volvo agent
    static func volvoValet() -> GridLayout {
        return GridLayout(margin: 13, gutter: 8, columnCount: 6)
    }
}
