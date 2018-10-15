//
//  UIView+Layout.swift
//  voluxe-customer
//
//  Created by Christoph on 10/15/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension UIView {

    func pinToSuperviewTop(useSafeArea: Bool = true) {
        Layout.pinToSuperviewTop(view: self, useSafeArea: useSafeArea)
    }

    func pinTopToBottomOf(view: UIView, spacing: CGFloat = 0) {
        Layout.pin(topOf: self, toBottomOf: view, spacing: spacing)
    }

    func pinToBottomOfPreviousSubview() {}

    func pinToTopOfSuperview() {}

    func pinToTopOf(peerView: UIView) {}

    // TODO is this useful?
    //    func pinTopToBottomOfPreviouslyAddedSubview(spacing: CGFloat = 0) {
    //    }
}

// MARK:- Subview height constraining

extension UIView {

    func constrain(height constant: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func constrain(height peerView: UIView) {
        self.heightAnchor.constraint(equalTo: peerView.heightAnchor)
    }
}
