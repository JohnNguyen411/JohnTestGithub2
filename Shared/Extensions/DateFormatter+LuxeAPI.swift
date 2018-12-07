//
//  DateFormatter+LuxeAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 11/13/18.
//  Copyright © 2018 Volvo Valet. All rights reserved.
//

import Foundation

extension DateFormatter {

    public convenience init(withFormat format : String, locale : String) {
        self.init()
        self.locale = Locale(identifier: locale)
        dateFormat = format
    }

    static let iso8601 = DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", locale: "en_US_POSIX")
}
