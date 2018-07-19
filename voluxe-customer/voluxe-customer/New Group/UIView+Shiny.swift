//
//  UIView+Shiny.swift
//  voluxe-customer
//
//  Created by Christoph on 7/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension VLShinyView {

    // this is the first 8 bytes of "shinyview" converted to hex
    // useful for tagging the shiny view in a superview hierarchy
    static let shinyViewTag = 0x7368696e
}

extension UIView {

    // TODO rename after other properties are removed
    var shinyViewX: VLShinyView? {
        return self.viewWithTag(VLShinyView.shinyViewTag) as? VLShinyView
    }

    func add(shinyView view: VLShinyView) {
        guard self.shinyViewX == nil else { return }
        self.addSubview(view)
        view.tag = VLShinyView.shinyViewTag
        self.constrainShinyView()
    }

    func insert(shinyView view: VLShinyView, belowSubview subview: UIView) {
        guard self.shinyViewX == nil else { return }
        self.insertSubview(view, belowSubview: subview)
        view.tag = VLShinyView.shinyViewTag
        self.constrainShinyView()
    }

    private func constrainShinyView() {
        self.shinyViewX?.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
        }
    }

    /// Removes a tagged shiny view from this view's subviews.
    /// Note that this will not remove a shiny view in this
    /// view's superview subviews.
    func removeShinyView() {
        self.shinyViewX?.removeFromSuperview()
    }
}

// TODO this works but is a bit awkward
extension UIButton {

    func insertBelowTitleLabel(shinyView view: VLShinyView) {
        if let label = self.titleLabel {
            self.insert(shinyView: view, belowSubview: label)
        } else {
            self.add(shinyView: view)
        }
    }
}

extension VLShinyView {

    func add(to view: UIView, mask: UIImage? = nil) {
        view.add(shinyView: self)
        self.setMask(image: mask)
    }
}
