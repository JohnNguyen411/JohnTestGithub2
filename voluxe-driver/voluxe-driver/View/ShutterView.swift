//
//  ShutterView.swift
//  voluxe-driver
//
//  Created by Christoph on 1/4/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ShutterView: UIView {

    // MARK: Layout

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Volvo.grey(.darker)
        return view
    }()

    let flashButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setImage(UIImage(named: "flash"), for: .selected)
        button.setImage(UIImage(named: "flash-disabled"), for: .normal)
        button.imageView?.contentMode = .center
        return button
    }()

    let shutterButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setImage(UIImage(named: "shutter-button"), for: .normal)
        button.imageView?.contentMode = .center
        return button
    }()

    private let shutterImageView: UIImageView = {
        let image = UIImage(named: "shutter-ring")
        let imageView = UIImageView(image: image).usingAutoLayout()
        imageView.contentMode = .center
        return imageView
    }()

    // MARK: Lifecycle

    convenience init() {
        self.init(frame: CGRect.zero)
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.addSubviews()
    }

    private func addSubviews() {
        Layout.fill(view: self, with: self.backgroundView)

        self.addSubview(self.flashButton)
        self.flashButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.flashButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.flashButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.flashButton.widthAnchor.constraint(equalTo: self.flashButton.heightAnchor).isActive = true

        self.addSubview(self.shutterButton)
        self.shutterButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.shutterButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.shutterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.shutterButton.widthAnchor.constraint(equalTo: self.shutterButton.heightAnchor).isActive = true

        self.addSubview(self.shutterImageView)
        self.shutterImageView.matchConstraints(to: self.shutterButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView.layer.cornerRadius = self.bounds.size.height / 2
    }
}
