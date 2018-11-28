//
//  PushRequiredViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 10/31/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class PushRequiredViewController: UIViewController {

    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.numberOfLines = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingsButtonTouchUpInside), for: .touchUpInside)
        button.setTitle("Push Notifications Disabled\nOpen Settings", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.view.addSubview(self.button)
        self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    @objc func settingsButtonTouchUpInside() {
        let string = UIApplication.openSettingsURLString
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
