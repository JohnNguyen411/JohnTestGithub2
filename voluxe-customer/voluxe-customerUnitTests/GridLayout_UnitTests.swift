//
//  GridLayout_UnitTests.swift
//  voluxe-customerUnitTests
//
//  Created by Christoph on 10/11/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import XCTest
import UIKit

class GridLayout_UnitTests: XCTestCase {

    func test_columnMath() {

        // column width = (view width - (2 x margin) - ((gutter count * gutter width))) / column count
        // leading offset = margin + ((column index - 1) * column width)
        let margin = UInt(10)
        let gutter = UInt(10)
        let count = UInt(4)

        let expectedGutterCount = 3
        let expectedColumnWidth = CGFloat((400.0 - 20.0 - (3 * 10.0)) / 4.0)
        let leadingConstant1 = CGFloat(margin) + CGFloat((0 * testColumnWidth)
        let leadingConstant2 = CGFloat(margin) + CGFloat((1 * testColumnWidth)
        let leadingConstant3 = CGFloat(margin) + CGFloat((2 * testColumnWidth)
        let leadingConstant4 = CGFloat(margin) + CGFloat((3 * testColumnWidth)

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        let grid = GridLayout.init(margin: margin, gutter: gutter, columnCount: count)
        let columnWidth = grid.columnWidth(for: view)

        // positive tests
        XCTAssertTrue(grid.gutterCount == expectedGutterCount)
        XCTAssertTrue(columnWidth == expectedColumnWidth)
        XCTAssertTrue(grid.leadingOffset(for: 1, in: view) == 10)
        XCTAssertTrue(grid.leadingOffset(for: 2, in: view) == 10 + testColumnWidth)

        // negative tests
//        XCTAssertFalse(columnWidth == 10)
//        XCTAssertFalse(grid.leadingOffset(for: 2, in: view) == 10)
    }

    func test_invalidGrids() {

    }
}
