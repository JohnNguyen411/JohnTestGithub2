//
//  GridLayout.swift
//  voluxe-customer
//
//  Created by Christoph on 10/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

// grid discussion with Brian
// margin, gutter, number of columns
// what happens if the column count is changed, do add() calls need to be updated?
// how does this relate to UIView.safeAreaGuide?
// how does a subview use the same grid as the parent view?  look up view hierarchy until a grid is found?
// how is a grid assigned to a view?  associated value?  subclass?
// can grid columns be negative?
// what happens if column index is out of range?
// can columns be narrower than gutter or margin?

// units are whole points, no fractional
struct GridLayout {

    typealias ColumnIndex = UInt

    // leading/trailing margin
    let margin: UInt

    // inter-column gutter
    let gutter: UInt

    // number of columns
    let columnCount: UInt

    // how to ensure all columns + gutters + margins equal width?
    // column width (depends on the view installed on)
    func columnWidth(for view: UIView) -> UInt { return 0 }
    func columnWidth(for column: UInt, in view: UIView) -> UInt { return 0 }
}

extension GridLayout {

    static func common() -> GridLayout {
        return GridLayout(margin: 10, gutter: 10, columnCount: 4)
    }

    static func chunky() -> GridLayout {
        return GridLayout(margin: 10, gutter: 20, columnCount: 2)
    }

    static func detailed() -> GridLayout {
        return GridLayout(margin: 10, gutter: 10, columnCount: 8)
    }
}

enum GridLayoutWidth {
    case wide       // all columns
    case medium     // approxiamtely half the number of columns
    case narrow     // single columm
}

enum GridLayoutPosition {
    case leading
    case center     // how does this work for even number of columns?
    case trailing
}

// highest order parent view with grid
// setting grid layout a second time will require rebuilding all constraints
class GridLayoutView: UIView {

    // TODO should this create and return constraints for a particular column?
    var gridLayout: GridLayout
    var columnsToAnchors: [(leading: NSLayoutAnchor, trailing: NSLayoutAnchor)] = []

    init(layout: GridLayout) {
        self.gridLayout = layout
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// extension that allows child views to align to a parent grid layout
extension UIView {

    // TODO rename to superview?
    private func findParentGridLayoutView() -> GridLayoutView? {
        var parent = self.superview
        while parent != nil {
            if parent is GridLayoutView { return parent }
            else { parent = parent.superview }
        }
        return nil
    }

    // TODO rename to superview?
    // TODO need a pinTopToPeerBottom?
    // TODO should this throw if no parent grid view?
    func add(subview: UIView, to column: UInt) {
        guard let superview = self.findParentGridLayoutView() else { return }
    }

    func add(subview: UIView, from leadingColumn: UInt, to trailingColumn: UInt) {}

    // can there be conceptual layouts like wide = all columns, narrow = single column?
    func add(subview: UIView, position: GridLayoutPosition, width: GridLayoutWidth) {}
}
