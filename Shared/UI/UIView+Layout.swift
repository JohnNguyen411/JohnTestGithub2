//
//  UIView+Layout.swift
//  voluxe-customer
//
//  Created by Christoph on 10/15/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

// TODO add Layout struct for namespacing?
extension UIView {

    func pinToSuperviewTop(spacing: CGFloat = 0, useSafeArea: Bool = true) {
        Layout.pinToSuperviewTop(view: self, spacing: spacing, useSafeArea: useSafeArea)
    }

    func pinTopToSuperview(spacing: CGFloat = 0, useSafeArea: Bool = true) {
        Layout.pinToSuperviewTop(view: self, spacing: spacing, useSafeArea: useSafeArea)
    }

    func pinBottomToSuperviewBottom(spacing: CGFloat = 0, useSafeArea: Bool = true) {
        Layout.pinToSuperviewBottom(view: self, spacing: spacing, useSafeArea: useSafeArea)
    }

    func pinBottomToSuperview(spacing: CGFloat = 0, useSafeArea: Bool = true) {
        Layout.pinToSuperviewBottom(view: self, spacing: spacing, useSafeArea: useSafeArea)
    }

    func pinTopToBottomOf(view: UIView, spacing: CGFloat = 0) {
        Layout.pin(topOf: self, toBottomOf: view, spacing: spacing)
    }

    func pinToBottomOfPreviousSubview() {}

    func pinToTopOf(peerView: UIView) {}

    func matchConstraints(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    func pinLeftToSuperview(constant: CGFloat = 0) {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant).isActive = true
    }

    func pinRightToSuperview(constant: CGFloat = 0) {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: constant).isActive = true
    }
}

// MARK:- Subview dimension constraining

extension UIView {

    func constrain(height constant: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func constrain(height peerView: UIView) {
        self.heightAnchor.constraint(equalTo: peerView.heightAnchor).isActive = true
    }

    func constrainAsSquare(size: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
