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
    
    static func stringByReplacingFirstOccurrenceOfString(string: String, target: String, withString replaceString: String) -> String {
        if let range = string.range(of: target) {
            return string.replacingOccurrences(of: target, with: replaceString, options: CompareOptions.literal, range: range)
        }
        return string
    }

}
