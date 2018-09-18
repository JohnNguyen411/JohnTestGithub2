//
//  UITextField+Voluxe.swift
//  voluxe-customer
//
//  Created by Christoph on 8/20/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    /// Removes leading and trailing whitespace from the current
    /// text content of the textfield.  Uses String.trim().
    func trimText() {
        self.text = self.text?.trim()
    }
}
