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
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    
    static func intToStringDecimal(largeNumber: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedString = numberFormatter.string(from: NSNumber(value:largeNumber)) {
            return formattedString
        }
        return "\(largeNumber)"
    }
    
    static func addLeftRightPadding(string: String) -> String {
        return " \(string) "
    }
}
