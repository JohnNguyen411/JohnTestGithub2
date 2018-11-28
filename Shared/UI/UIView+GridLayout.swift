//
//  UIView+GridLayout.swift
//  voluxe-driver
//
//  Created by Christoph on 11/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func addGridLayoutView(with layout: GridLayout = GridLayout.sixColumns()) -> GridLayoutView {
        let view = GridLayoutView(layout: layout)
        Layout.fill(view: self, with: view)
        return view
    }
}
