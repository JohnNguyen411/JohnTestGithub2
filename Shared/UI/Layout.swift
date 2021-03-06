//
//  Layout.swift
//  voluxe-customer
//
//  Created by Christoph on 9/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Subview pin utilities

struct Layout {

    // requires both views to have same superview
    static func pin(topOf view: UIView, toBottomOf peerView: UIView, spacing: CGFloat = 0) {
        guard let superview = view.superview, superview == peerView.superview else { return }
        view.topAnchor.constraint(equalTo: peerView.bottomAnchor, constant: spacing).isActive = true
    }
    
    // requires both views to have same superview
    static func pin(bottomOf view: UIView, bottomOf peerView: UIView, spacing: CGFloat = 0) {
        guard let superview = view.superview, superview == peerView.superview else { return }
        view.bottomAnchor.constraint(equalTo: peerView.bottomAnchor, constant: spacing).isActive = true
    }
    
    static func pin(bottomOf view: UIView, topOf peerView: UIView, spacing: CGFloat = 0) {
        guard let superview = view.superview, superview == peerView.superview else { return }
        view.bottomAnchor.constraint(equalTo: peerView.topAnchor, constant: spacing).isActive = true
    }

    static func pinToSuperviewTop(view: UIView, spacing: CGFloat = 0, useSafeArea: Bool = true) {
        guard let superview = view.superview else { return }
        let anchor = useSafeArea ? superview.compatibleSafeAreaLayoutGuide.topAnchor : superview.topAnchor
        view.topAnchor.constraint(equalTo: anchor, constant: spacing).isActive = true
    }

    static func pinToSuperviewBottom(view: UIView, spacing: CGFloat = 0, useSafeArea: Bool = true) {
        guard let superview = view.superview else { return }
        let anchor = useSafeArea ? superview.compatibleSafeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
        view.bottomAnchor.constraint(equalTo: anchor, constant: spacing).isActive = true
    }
}

// MARK:- Add subview and pin utilities

extension Layout {

    static func fill(view: UIView, with subview: UIView, useSafeArea: Bool = true) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        let topAnchor = useSafeArea ? view.compatibleSafeAreaLayoutGuide.topAnchor : view.topAnchor
        let bottomAnchor = useSafeArea ? view.compatibleSafeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    static func add(subview: UIView, pinnedToTopOf view: UIView, useSafeArea: Bool = true) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        Layout.pinToSuperviewTop(view: subview)
        subview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    static func add(subview: UIView, pinnedToBottomOf view: UIView, useSafeArea: Bool = true) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        Layout.pinToSuperviewBottom(view: subview)
        subview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    static func add(view: UIView, pinTopToBottomOf peerView: UIView) {
        guard let superview = peerView.superview else { return }
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        Layout.pin(topOf: view, toBottomOf: peerView)
        view.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
}

// MARK:- Spacer view factories

extension Layout {

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

        if pinToSuperviewBottom {
            view.bottomAnchor.constraint(equalTo: superview.compatibleSafeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }

    /// Pins an empty, stretchable spacer view to the bottom
    /// of the last added view and the bottom of the content view.
    /// This effectively "closes" the subview array and allows
    /// Autolayout to calculate the superview's content size
    /// correctly (including scroll views).
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

    static func addSpacerViewToBottomOfPreviousSubview(pinToSuperviewBottom: Bool = false) {}
}

// MARK:- Scroll and content view factories

extension Layout {

    static func scrollView(in viewController: UIViewController) -> UIScrollView {
        let scrollView = UIScrollView.forAutoLayout()
        scrollView.clipsToBounds = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
        }
        self.fill(view: viewController.view, with: scrollView)
        return scrollView
    }

    static func verticalContentView(in scrollView: UIScrollView) -> UIView {
        let contentView = UIView.forAutoLayout()
        Layout.fill(scrollView: scrollView, with: contentView)
        return contentView
    }

    static func fill(scrollView: UIScrollView, with contentView: UIView) {
        Layout.fill(view: scrollView, with: contentView, useSafeArea: false)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true
    }
}
