//
//  Layout.swift
//  voluxe-customer
//
//  Created by Christoph on 9/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

// grid discussion with Brian
// margin, gutter, number of columns
// what happens if the column count is changed, do add() calls need to be updated?

struct Layout {

    // TODO can this be separated down to a protocol and implementation?
    // TODO fill(superview, with view)
    static func fill(superview: UIView, with view: UIView) {
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: superview.leftAnchor),
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.rightAnchor.constraint(equalTo: superview.rightAnchor),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }

    // TODO need to include compatibleSafeAreaLayoutGuide
    static func add(view: UIView, toTopOf superview: UIView) {
        superview.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: superview.leftAnchor),
            view.topAnchor.constraint(equalTo: superview.compatibleSafeAreaLayoutGuide.topAnchor),
            view.rightAnchor.constraint(equalTo: superview.rightAnchor)
        ])
    }

    // TODO need to assert if no superview
    // TODO is margin optional or changeable?
    // TODO improve name to mention pinTopToBottomOf
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

    // TODO need to include compatibleSafeAreaLayoutGuide
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
    // TODO need to include compatibleSafeAreaLayoutGuide
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
        let view = UIScrollView.forAutoLayout()
        self.fill(superview: view, with: viewController.view)
        return view
    }

    static func scrollViewWithContentView() -> (UIScrollView, UIView) {
        let scrollView = UIScrollView.forAutoLayout()
        let contentView = Layout.verticalContentView(in: scrollView)
        return (scrollView, contentView)
    }

    static func verticalContentView(in scrollView: UIScrollView) -> UIView {
        let view = UIView(frame: .zero)
        Layout.fill(superview: view, with: scrollView)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            view.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        return view
    }
}
