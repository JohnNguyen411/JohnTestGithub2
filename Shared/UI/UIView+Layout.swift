//
//  UIView+Layout.swift
//  voluxe-customer
//
//  Created by Christoph on 10/15/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

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
    
    func pinBottomToBottomOf(view: UIView, spacing: CGFloat = 0) {
        Layout.pin(bottomOf: self, bottomOf: view, spacing: spacing)
    }

    func pinTopToBottomOf(view: UIView, spacing: CGFloat = 0) {
        Layout.pin(topOf: self, toBottomOf: view, spacing: spacing)
    }
    

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
    
    func pinLeftToView(peerView: UIView, constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo: peerView.leftAnchor, constant: constant).isActive = true
    }
    
    func pinLeadingToView(peerView: UIView, constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: peerView.leadingAnchor, constant: constant).isActive = true
    }
    
    func pinLeadingToSuperView(constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
    }
    
    func pinTrailingToView(peerView: UIView, constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: peerView.trailingAnchor, constant: constant).isActive = true
    }
    
    func pinTrailingToSuperView(constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = self.superview else { return }
        let constraint = self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant)
        constraint.priority = UILayoutPriority(rawValue: 999)
        constraint.isActive = true
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
    
    func constrain(width constant: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func constrain(height peerView: UIView) {
        self.heightAnchor.constraint(equalTo: peerView.heightAnchor).isActive = true
    }

    func constrainAsSquare(size: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
