//
//  String+Validation.swift
//  voluxe-customer
//
//  Created by Christoph on 8/23/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

// MARK:- Email

extension String {

    static func isValid(email string: String?) -> Bool {
        guard let string = string else { return false }
        if string.isEmpty { return false }
        guard string.count >= 2, string.count <= 64 else { return false }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        let result = test.evaluate(with: string)
        return result
    }

    func isValidEmail() -> Bool {
        return String.isValid(email: self)
    }
}

// MARK:- Password

extension String {

    static func isValid(password string: String?) -> Bool {
        guard let string = string else { return false }
        return string.isMinimumPasswordLength() &&
               string.isLessThanMaximumPasswordLength() &&
               string.hasRequiredPasswordCharacters() &&
               !string.hasIllegalPasswordCharacters()
    }

    func isValidPassword() -> Bool {
        return String.isValid(password: self)
    }

    func isMinimumPasswordLength() -> Bool {
        return self.count >= 8
    }

    func isLessThanMaximumPasswordLength() -> Bool {
        return self.count <= 60
    }

    func hasRequiredPasswordCharacters() -> Bool {
        return self.containsLetter() && self.containsNumber()
    }

    func hasIllegalPasswordCharacters() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}")
        let range = NSMakeRange(0, self.utf16.count)
        let matchRange = regex.rangeOfFirstMatch(in: self, options: .reportProgress, range: range)
        let valid = matchRange == range
        return !valid
    }
}
