//
//  PermissionViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 10/31/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

enum Permission: String {
    case location = "Location Updates"
    case push = "Push Notifications"
    case camera = "Camera"
}

class PermissionViewController: UIViewController {

    // the type of permission this controller is prompting for
    // currently the controller shows the same label for any permission
    let permission: Permission

    // MARK:- Layout

    private let lockImageView: UIImageView = {
        let image = UIImage(named: "lock_icon")
        let imageView = UIImageView(image: image).usingAutoLayout()
        imageView.backgroundColor = UIColor.Volvo.error
        imageView.contentMode = .center
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = Font.Volvo.body1
        label.numberOfLines = 0
        label.text = Unlocalized.permissionRequiredText
        label.textColor = UIColor.Volvo.granite
        return label
    }()

    private let button = UIButton.Volvo.primary(title: Unlocalized.goToSettings)

    // MARK:- Lifecycle

    init(permission: Permission) {
        self.permission = permission
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = Unlocalized.permissionRequired.capitalized
        self.addActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        if permission == .camera {
            label.text = .localized(.permissionsCameraDeniedMessage)
        }

        let gridView = GridLayoutView(layout: GridLayout.volvoAgent())
        Layout.fill(view: self.view, with: gridView)

        Layout.add(subview: self.lockImageView, pinnedToTopOf: self.view)
        self.lockImageView.leadingAnchor.constraint(equalTo: gridView.leadingAnchor).isActive = true
        self.lockImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.lockImageView.trailingAnchor.constraint(equalTo: gridView.trailingAnchor).isActive = true

        gridView.add(subview: self.label, from: 1, to: 6)
        self.label.pinToSuperviewTop(spacing: 67)

        gridView.add(subview: self.button, from: 1, to: 6)
        self.button.pinBottomToSuperviewBottom(spacing: -18)
        self.button.heightAnchor.constraint(equalToConstant: 36)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.button.layoutShadowView()
    }

    // MARK:- Actions

    private func addActions() {
        self.button.addTarget(self, action: #selector(settingsButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func settingsButtonTouchUpInside() {
        let string = UIApplication.openSettingsURLString
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
