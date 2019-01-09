//
//  Label.swift
//  voluxe-customer
//
//  Created by Christoph on 9/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

struct Label {

    static func dark(with text: String? = nil) -> UILabel {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .darkGray
        label.text = text
        return label
    }
}

extension UILabel {

    // TODO make suitable for table header view
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}
