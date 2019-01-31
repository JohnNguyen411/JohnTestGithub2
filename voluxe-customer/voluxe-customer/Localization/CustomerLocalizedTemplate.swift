//
//  LocalizedTemplate.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 1/30/19.
//  Copyright © 2019 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/**
 Usage:
 Localized.loadError
 Localized.welcomeMessage.with("Dan")
 */

enum Localized: CustomStringConvertible {
    
    class Bundles {
        static let framework = Bundle(for: Localized.Bundles.self)
    }
    
    // %CASE_DECLARATIONS%
    var key : String {
        switch self {
            // %CASE_DESCRIPTIONS%
        }
    }
    
    var description: String {
        return NSLocalizedString(self.key, tableName: nil, bundle: Localized.Bundles.framework, value: self.key, comment: self.key)
    }
    
    func with(_ args: CVarArg...) -> String {
        let format = description
        return String(format: format, arguments: args)
    }
    
}

extension String {
    static func localized(_ localized: Localized) -> String {
        return localized.description
    }
}
