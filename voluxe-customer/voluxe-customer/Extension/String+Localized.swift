//
//  String+Localized.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

func NSLocalizedStringCommon(_ key: String) -> String {
    return NSLocalizedString(key, tableName: "CommonLocalizable", bundle: Bundle.main, value: key, comment: "")
}
