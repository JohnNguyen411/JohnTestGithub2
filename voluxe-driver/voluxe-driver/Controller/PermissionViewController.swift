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

    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.numberOfLines = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsButtonTouchUpInside), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    // MARK:- Lifecycle

    init(permission: Permission) {
        self.permission = permission
        super.init(nibName: nil, bundle: nil)
        let title = "\(permission.rawValue) Disabled\nOpen Settings"
        self.button.setTitle(title, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.view.addSubview(self.button)
        self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    // MARK:- Actions

    @objc func settingsButtonTouchUpInside() {
        let string = UIApplication.openSettingsURLString
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
