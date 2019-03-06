//
//  GridLayout.swift
//  voluxe-customer
//
//  Created by Christoph on 10/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

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

    // number of gutters
    var gutterCount: UInt {
        return self.columnCount == 0 ? 0 : self.columnCount - 1
    }

    // how to ensure all columns + gutters + margins equal width?
    // column width (depends on the view installed on)
    func columnWidth(for view: UIView) -> CGFloat {
        var width = view.frame.size.width
        if width == 0 { return 0.0 }
        width -= CGFloat(2 * self.margin)
        width -= CGFloat(self.gutterCount * self.gutter)
        width /= CGFloat(self.columnCount)
        return width
    }

    func leadingOffset(for column: UInt, in view: UIView) -> CGFloat {
        var offset = CGFloat(self.margin)
        offset += CGFloat(column - 1) * self.columnWidth(for: view)
        offset += CGFloat(column - 1) * CGFloat(self.gutter)
        return offset
    }
}

extension GridLayout {

    static func fourColumns() -> GridLayout {
        return GridLayout(margin: 20, gutter: 10, columnCount: 4)
    }

    static func sixColumns() -> GridLayout {
        return GridLayout(margin: 20, gutter: 10, columnCount: 6)
    }

    static func chunky() -> GridLayout {
        return GridLayout(margin: 40, gutter: 40, columnCount: 2)
    }

    static func detailed() -> GridLayout {
        return GridLayout(margin: 10, gutter: 10, columnCount: 8)
    }
}

// highest order parent view with grid
// setting grid layout a second time will require rebuilding all constraints
class GridLayoutView: UIView {

    let gridLayout: GridLayout

    // guides represent the margins and inter-column gutters
    // the first and last guide are the margins
    // any guides in between are for the gutters
    var guides: [UILayoutGuide] = []

    private func guides(from layout: GridLayout) -> [UILayoutGuide] {
        var guides: [UILayoutGuide] = []

        // leading margin guide
        var guide = UILayoutGuide()
        guide.identifier = "grid.leading"
        self.addLayoutGuide(guide)
        guides += [guide]

        // gutter guides
        for i in 0 ..< self.gridLayout.gutterCount {
            guide = UILayoutGuide()
            guide.identifier = "grid.gutter.\(i)"
            self.addLayoutGuide(guide)
            guides += [guide]
        }

        // trailing margin guide
        guide = UILayoutGuide()
        guide.identifier = "grid.trailing"
        self.addLayoutGuide(guide)
        guides += [guide]

        return guides
    }

    init(layout: GridLayout) {
        self.gridLayout = layout
        super.init(frame: .zero)
        self.guides = self.guides(from: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.updateGuides()
        super.layoutSubviews()
    }

    // Required to calculate guide leading constants based on view width.
    private func updateGuides() {

        let grid = self.gridLayout
        let columnWidth = grid.columnWidth(for: self)
        let columnStride = CGFloat(grid.gutter) + columnWidth
        var gutterLeadingConstant = CGFloat(grid.margin) + columnWidth

        for guide in self.guides {
            if guide == self.guides.first {
                guide.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                guide.widthAnchor.constraint(equalToConstant: CGFloat(grid.margin)).isActive = true
            }
            else if guide == self.guides.last {
                guide.widthAnchor.constraint(equalToConstant: CGFloat(grid.margin)).isActive = true
                guide.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            }
            else {
                guide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: gutterLeadingConstant).isActive = true
                guide.widthAnchor.constraint(equalToConstant: CGFloat(grid.gutter)).isActive = true
                gutterLeadingConstant += columnStride
            }
        }
    }

    func leadingAnchor(for column: UInt) -> NSLayoutXAxisAnchor {
        assert(column >= 1 && column <= self.gridLayout.columnCount)
        return self.guides[Int(column)].leadingAnchor
    }

    func trailingAnchor(for column: UInt) -> NSLayoutXAxisAnchor {
        assert(column >= 1 && column <= self.gridLayout.columnCount)
        return self.guides[Int(column)].trailingAnchor
    }
}

// extension that allows child views to align to a parent grid layout
extension UIView {

    private func findParentGridLayoutView() -> GridLayoutView? {
        var parent: UIView? = self
        while parent != nil {
            if parent is GridLayoutView { return parent as? GridLayoutView }
            else { parent = parent?.superview }
        }
        return nil
    }

    private func parentGridLayout() -> GridLayout? {
        return self.findParentGridLayoutView()?.gridLayout
    }

    @discardableResult
    func add(subview: UIView) -> UIView {
        guard let layout = self.parentGridLayout() else { return subview }
        return self.add(subview: subview, from: 1, to: layout.columnCount)
    }

    @discardableResult
    func add(subview: UIView, to column: UInt) -> UIView {
        return self.add(subview: subview, from: column, to: column)
    }

    @discardableResult
    func add(subview: UIView, from leadingColumn: UInt, to trailingColumn: UInt) -> UIView {

        guard let parent = self.findParentGridLayoutView() else { return subview }
        guard leadingColumn >= 0,trailingColumn <= parent.gridLayout.columnCount else { return subview }
        guard leadingColumn <= trailingColumn else { return subview }

        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)

        let leadingGuide = parent.guides[Int(leadingColumn - 1)]
        let trailingGuide = parent.guides[Int(trailingColumn)]

        subview.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subview.leadingAnchor.constraint(equalTo: leadingGuide.trailingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingGuide.leadingAnchor).isActive = true

        return subview
    }
}
