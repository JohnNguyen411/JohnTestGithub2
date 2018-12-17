//
//  ProfileButton.swift
//  voluxe-driver
//
//  Created by Christoph on 12/11/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

/// Convenience class to produce a stylized profile image.
/// The design requires a drop shadow behind the rounded
/// image, but using the layer cornerRadius will also trim
/// the layer shadow.  The solution then is to insert a
/// view between the button background and the image view
/// with a shadow layer, then sync the frame on layout.
class ProfileButton: UIButton {

    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 1
        return view
    }()

    convenience init() {
        self.init(type: .custom)
        guard let imageView = self.imageView else { return }
        self.insertSubview(self.shadowView, belowSubview: imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.configure()
    }

    private func configure() {

        guard let imageView = self.imageView else { return }
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        let height = self.frame.size.height - self.imageEdgeInsets.top - self.imageEdgeInsets.bottom
        imageView.layer.cornerRadius = height / 2

        self.shadowView.frame = imageView.frame
        self.shadowView.layer.cornerRadius = imageView.layer.cornerRadius
    }
}
