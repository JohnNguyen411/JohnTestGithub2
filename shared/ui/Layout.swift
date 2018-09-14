//
//  Layout.swift
//  voluxe-customer
//
//  Created by Christoph on 9/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

// TODO move and formalize this
struct Layout {

    // TODO use autolayout calls instead of SnapKit
    // TODO can this be separated down to a protocol and implementation?
    // to avoid being tied a single layout framework?
    // might as well just use Autolayout directly then
    static func fill(view: UIView, in superview: UIView) {
        superview.addSubview(view)
        view.snp.makeConstraints {
            make in
            make.edgesEqualsToView(view: superview)
        }
    }

    // TODO use autolayout calls instead of SnapKit
    // TODO is margin flexible?
    static func add(view: UIView, toTopOf superview: UIView) {
        superview.addSubview(view)
        view.snp.makeConstraints {
            make in
            make.left.equalToSuperview()
            make.top.equalTo(superview.safeArea.top).offset(20)
            make.right.equalToSuperview()
        }
    }

    // TODO use autolayout calls instead of SnapKit
    // TODO need to assert if no superview
    // TODO is margin optional or changeable?
    static func add(view: UIView, below peerView: UIView) {
        guard let superview = peerView.superview else { return }
        superview.addSubview(view)
        view.snp.makeConstraints {
            make in
            make.left.equalToSuperview()
            make.top.equalTo(peerView.snp.bottom).offset(20)
            make.right.equalToSuperview()
        }
    }

    // TODO use autolayout calls instead of SnapKit
    // TODO need to assert if no superview
    static func addSpacerView(below peerView: UIView, pinToSuperviewBottom: Bool = true) {
        guard let superview = peerView.superview else { return }
        let view = UIView(frame: .zero)
        superview.addSubview(view)
        view.snp.makeConstraints {
            make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            if pinToSuperviewBottom { make.bottom.equalTo(superview.safeArea.bottom) }
        }
    }

    /// Pins an empty, stretchable spacer view to the bottom
    /// of the last added view and the bottom of the content view.
    /// This effectively "closes" the subview array and allows
    /// Autolayout to calculate the scroll view's content size
    /// correctly.
    // TODO find a better name
    // TODO use autolayout calls instead of SnapKit
    // TODO what to return if guard fails?
    static func addSpacerView(toBottomOf contentView: UIView) -> UIView {
        let view = UIView(frame: .zero)
        guard let peerview = contentView.subviews.last else { return view }
        contentView.addSubview(view)
        view.snp.makeConstraints {
            make in
            make.left.equalToSuperview()
            make.top.equalTo(peerview.safeArea.bottom)
            make.right.equalToSuperview()
            make.bottom.equalTo(contentView.safeArea.bottom)
        }
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
        guard let superview = scrollView.superview else { assertionFailure(); return UIView() }
        let view = UIView(frame: .zero)
        scrollView.addSubview(view)
        view.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
            make.width.equalTo(superview.snp.width)
            make.height.greaterThanOrEqualToSuperview()
        }
        return view
    }
}
