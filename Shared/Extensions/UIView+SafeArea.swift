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

    // Note that this may not work as expected for landscape orientations.
    // Windows rotate when the device rotates, so the top insets will report
    // different values depending the orientation.
    var hasTopNotch: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
