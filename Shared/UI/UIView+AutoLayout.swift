//
//  UIView+AutoLayout.swift
//  voluxe-customer
//
//  Created by Christoph on 10/2/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    static func forAutoLayout() -> Self {
        let view = self.init()
        return view.usingAutoLayout()
    }

    func usingAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
