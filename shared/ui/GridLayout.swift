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
        return GridLayout(margin: 40, gutter: 40, columnCount: 2)
    }

    static func detailed() -> GridLayout {
        return GridLayout(margin: 10, gutter: 10, columnCount: 8)
    }
}

// highest order parent view with grid
// setting grid layout a second time will require rebuilding all constraints
class GridLayoutView: UIView {

    // TODO should this create and return constraints for a particular column?
    var gridLayout: GridLayout

    // guides represent the margins and inter-column gutters
    // the first and last guide are the margins
    // any guides in between are for the gutters
    var guides: [UILayoutGuide] = []

    private func guides(from layout: GridLayout) -> [UILayoutGuide] {
        var guides: [UILayoutGuide] = []

        // leading margin guide
        var guide = UILayoutGuide()
        guide.identifier = "leadingGuide"
        self.addLayoutGuide(guide)
        guide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        guide.widthAnchor.constraint(equalToConstant: CGFloat(layout.margin)).isActive = true
        guides += [guide]

        // TODO this only works because there is a single centered gutter in between two columns
        // there is no to know the offsets for other columns without knowing the view width
        // force a gutter to simulate two columns, need to use actual column width
        guide = UILayoutGuide()
        guide.identifier = "gutterGuide"
        self.addLayoutGuide(guide)
        guide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        guide.widthAnchor.constraint(equalToConstant: CGFloat(layout.gutter)).isActive = true
        guides += [guide]

        // trailing margin guide
        guide = UILayoutGuide()
        guide.identifier = "trailingGuide"
        self.addLayoutGuide(guide)
        guide.widthAnchor.constraint(equalToConstant: CGFloat(layout.margin)).isActive = true
        guide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        guides += [guide]

        return guides
    }

    // TODO
    // private func guideFor(leading, trailing)

    private func addDebugSubviewsForGuides() {

        let debugView = UIView.forAutoLayout()
        Layout.fill(view: self, with: debugView)

        for guide in self.guides {
            let view = UIView.forAutoLayout()
            view.backgroundColor = Colors.debug
            debugView.addSubview(view)
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        }
    }

    // TODO assert if column count == 0?
    init(layout: GridLayout) {
        self.gridLayout = layout
        super.init(frame: .zero)
        self.guides = self.guides(from: layout)
        self.addDebugSubviewsForGuides()
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
        var parent: UIView? = self
        while parent != nil {
            if parent is GridLayoutView { return parent as? GridLayoutView }
            else { parent = parent?.superview }
        }
        return nil
    }

    // TODO rename to superview?
    // TODO need a pinTopToPeerBottom?
    // TODO should this throw if no parent grid layout?
    // TODO throw if column > layout.columnCount?
    func add(subview: UIView, to column: UInt) {
        guard let parent = self.findParentGridLayoutView() else { return }
        guard column > 0, column <= parent.gridLayout.columnCount else { return }

        subview.translatesAutoresizingMaskIntoConstraints = false
//        subview.backgroundColor = Colors.debug
        self.addSubview(subview)

        let leadingGuide = parent.guides[Int(column - 1)]
        let trailingGuide = parent.guides[Int(column)]

        subview.leadingAnchor.constraint(equalTo: leadingGuide.trailingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingGuide.leadingAnchor).isActive = true

        subview.setContentHuggingPriority(.required, for: .horizontal)
//        subview.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func add(subview: UIView, from leadingColumn: UInt, to trailingColumn: UInt) {}
}

// TODO this may not be necessary
// MARK:- Possible grid layout by width and position concepts

extension UIView {

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

    // can there be conceptual layouts like wide = all columns, narrow = single column?
    func add(subview: UIView, position: GridLayoutPosition, width: GridLayoutWidth) {}
}
