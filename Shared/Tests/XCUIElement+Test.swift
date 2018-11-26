//
//  XCUIElement+Test.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/22/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {

    func clearText() {
        guard let text = self.value as? String else { return }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: text.count)
        self.typeText(deleteString)
    }

    func clear(andType text: String) {
        self.tapAndClearText()
        self.typeText(text)
    }

    func tapAndClearText() {
        self.tap()
        self.clearText()
    }

    func tap(andType text: String) {
        self.tap()
        self.typeText(text)
    }
}
