//
//  UIView+SafeArea.swift
//  voluxe-customer
//
//  Created by Christoph on 10/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    // This can safely be removed when deployment is iOS 11+.
    var compatibleSafeAreaLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide
        } else {
            let guide = UILayoutGuide()
            guide.topAnchor.constraint(equalTo: topAnchor).isActive = true
            guide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            guide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            guide.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            return guide
        }
    }
}
