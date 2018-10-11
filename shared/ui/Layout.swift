//
//  Layout.swift
//  voluxe-customer
//
//  Created by Christoph on 9/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

// MARK:- Subview pin utilities

struct Layout {

    // requires both views to have same superview
    static func pin(topOf view: UIView, toBottomOf peerView: UIView) {
        guard let superview = view.superview, superview == peerView.superview else { return }
        view.topAnchor.constraint(equalTo: peerView.bottomAnchor).isActive = true
    }

    static func pinToSuperviewTop(view: UIView, useSafeArea: Bool = true) {
        guard let superview = view.superview else { return }
        let anchor = useSafeArea ? superview.compatibleSafeAreaLayoutGuide.topAnchor : superview.topAnchor
        view.topAnchor.constraint(equalTo: anchor).isActive = true
    }

    static func pinToSuperviewBottom(view: UIView, useSafeArea: Bool = true) {
        guard let superview = view.superview else { return }
        let anchor = useSafeArea ? superview.compatibleSafeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
        view.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}

// MARK:- Add subview and pin utilities

extension Layout {

    // TODO top safe are implied?
    static func fill(view: UIView, with subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subview.topAnchor.constraint(equalTo: view.compatibleSafeAreaLayoutGuide.topAnchor),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // top safe area is implied
    static func add(subview: UIView, pinnedToTopOf view: UIView, useSafeArea: Bool = true) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        Layout.pinToSuperviewTop(view: subview)
        subview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    // TODO need to assert if no superview
    // TODO is vertical margin optional or changeable?
    static func add(view: UIView, pinTopToBottomOf peerView: UIView) {
        guard let superview = peerView.superview else { return }
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        Layout.pin(topOf: view, toBottomOf: peerView)
        view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
    }

    // TODO extension to modify height constraints using constraint.identifier
    //https://stackoverflow.com/questions/42669554/how-to-update-the-constant-height-constraint-of-a-uiview-programatically
}

// MARK:- Spacer view factories

extension Layout {

    // TODO need to assert if no superview
    static func addSpacerView(pinToBottomOf peerView: UIView, pinToSuperviewBottom: Bool = true) {
        guard let superview = peerView.superview else { return }
        let view = UIView.forAutoLayout()
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.topAnchor.constraint(equalTo: peerView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])

        // TODO how to get this into activate()
        if pinToSuperviewBottom {
            view.bottomAnchor.constraint(equalTo: superview.compatibleSafeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }

    /// Pins an empty, stretchable spacer view to the bottom
    /// of the last added view and the bottom of the content view.
    /// This effectively "closes" the subview array and allows
    /// Autolayout to calculate the scroll view's content size
    /// correctly.
    // TODO what to return if guard fails?
    @discardableResult
    static func addSpacerView(toBottomOf contentView: UIView) -> UIView {
        let view = UIView.forAutoLayout()
        guard let peerview = contentView.subviews.last else { return view }
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.topAnchor.constraint(equalTo: peerview.compatibleSafeAreaLayoutGuide.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.compatibleSafeAreaLayoutGuide.bottomAnchor)
        ])
        return view
    }
}

// MARK:- Scroll and content view factories

extension Layout {

    static func scrollView(in viewController: UIViewController) -> UIScrollView {
        viewController.automaticallyAdjustsScrollViewInsets = true
        let view = UIScrollView.forAutoLayout()
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .scrollableAxes
        }
        self.fill(view: viewController.view, with: view)
        return view
    }

    static func verticalContentView(in scrollView: UIScrollView) -> UIView {
        let view = UIView.forAutoLayout()
        Layout.fill(view: scrollView, with: view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            view.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        return view
    }

    static func scrollViewWithContentView() -> (UIScrollView, UIView) {
        let scrollView = UIScrollView.forAutoLayout()
        let contentView = Layout.verticalContentView(in: scrollView)
        return (scrollView, contentView)
    }
}
