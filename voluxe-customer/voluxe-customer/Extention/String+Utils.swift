//
//  String+Utils.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 12/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension String {
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
}
