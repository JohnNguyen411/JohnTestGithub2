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
}

class PermissionViewController: UIViewController {

    // the type of permission this controller is prompting for
    let permission: Permission

    // MARK:- Layout

    private let lockImageView: UIImageView = {
        let image = UIImage(named: "lock_icon")
        let imageView = UIImageView(image: image).usingAutoLayout()
        imageView.backgroundColor = UIColor.Volvo.error
        imageView.contentMode = .center
        return imageView
    }()

    // TODO localize
    private let label: UILabel = {
        let label = UILabel()
        label.font = Font.Volvo.body1
        label.numberOfLines = 0
        label.text = "For Volvo Valet to work correctly, you must enable Push Notifications and Location Tracking. You can enable these permissions in Settings. Tap the button below to proceed."
        label.textColor = UIColor.Volvo.granite
        return label
    }()

    // TODO localize
    // TODO this is the foundation for a primary button factory
    // TODO needs both rounded corners AND shadow
    private let button: UIButton = {
        let button = UIButton(color: UIColor.Volvo.volvoBlue,
                              disabledColor: UIColor.Volvo.fog,
                              cornerRadius: 2)
        button.layer.cornerRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("GO TO SETTINGS", for: .normal)
        button.titleLabel?.font = Font.Volvo.button
        return button
    }()

    // MARK:- Lifecycle

    // TODO localize
    init(permission: Permission) {
        self.permission = permission
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Permission Required"
        self.addActions()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light

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
