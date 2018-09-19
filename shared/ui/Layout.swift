//
//  Layout.swift
//  voluxe-customer
//
//  Created by Christoph on 9/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

// grid discussion with Brian
//

struct Layout {

    // TODO can this be separated down to a protocol and implementation?
    // TODO fill(superview, with view)
    static func fill(view: UIView, in superview: UIView) {
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: superview.leftAnchor),
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.rightAnchor.constraint(equalTo: superview.rightAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }

    // TODO use autolayout calls instead of SnapKit
    // TODO is margin flexible?
    static func add(view: UIView, toTopOf superview: UIView) {
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: superview.leftAnchor),
            view.topAnchor.constraint(equalTo: superview.compatibleSafeAreaLayoutGuide.topAnchor),
            view.rightAnchor.constraint(equalTo: superview.rightAnchor)
        ])
    }

    // TODO use autolayout calls instead of SnapKit
    // TODO need to assert if no superview
    // TODO is margin optional or changeable?
    static func add(view: UIView, below peerView: UIView) {
        guard let superview = peerView.superview else { return }
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: superview.leftAnchor),
            view.topAnchor.constraint(equalTo: peerView.bottomAnchor, constant: 20),
            view.rightAnchor.constraint(equalTo: superview.rightAnchor)
        ])
    }

    // TODO use autolayout calls instead of SnapKit
    // TODO need to assert if no superview
    static func addSpacerView(below peerView: UIView, pinToSuperviewBottom: Bool = true) {
        guard let superview = peerView.superview else { return }
        let view = UIView(frame: .zero)
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: superview.leftAnchor),
            view.topAnchor.constraint(equalTo: peerView.bottomAnchor),
            view.rightAnchor.constraint(equalTo: superview.rightAnchor)
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
    // TODO find a better name
    // TODO what to return if guard fails?
    @discardableResult
    static func addSpacerView(toBottomOf contentView: UIView) -> UIView {
        let view = UIView(frame: .zero)
        guard let peerview = contentView.subviews.last else { return view }
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            view.topAnchor.constraint(equalTo: peerview.compatibleSafeAreaLayoutGuide.bottomAnchor),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.compatibleSafeAreaLayoutGuide.bottomAnchor)
        ])
        return view
    }

    static func scrollView(in viewController: UIViewController) -> UIScrollView {
        viewController.automaticallyAdjustsScrollViewInsets = true
        let view = UIScrollView(frame: .zero)
        self.fill(view: view, in: viewController.view)
        return view
    }

    // TODO use autolayout calls instead of SnapKit
    static func verticalContentView(in scrollView: UIScrollView) -> UIView {
        let view = UIView(frame: .zero)
        guard let superview = scrollView.superview else { assertionFailure(); return view }
        Layout.fill(view: view, in: scrollView)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: superview.widthAnchor),
            view.heightAnchor.constraint(greaterThanOrEqualTo: superview.heightAnchor)
        ])
        return view
    }
}
