//
//  LandingViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/10/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class LandingViewController: UIViewController {

    // MARK:- Layout

    private let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // TODO localize
    let loginButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setTitleColor(UIColor.Volvo.heather, for: .normal)
        button.setTitle("SIGN-IN", for: .normal)
        button.titleLabel?.font = Font.Volvo.button
        return button
    }()

    // MARK:- Lifecycle

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.loginButton.addTarget(self, action: #selector(loginButtonTouchUpInside), for: .touchUpInside)
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light

        let gridView = self.view.addGridLayoutView(with: GridLayout.volvoAgent())

        gridView.add(subview: self.logoImageView, from: 2, to: 5)
        self.logoImageView.pinToSuperviewTop(spacing: 96)
        self.logoImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true

        gridView.add(subview: self.loginButton, from:3, to: 4)
        self.loginButton.pinBottomToSuperviewBottom(spacing: -153)
    }

    // TODO remove, this is temporary during development
#if DEBUG
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        guard defaults.loginOnLaunch else { return }
        guard let email = defaults.driverEmail else { return }
        guard let password = defaults.driverPassword else { return }
        DriverManager.shared.login(email: email, password: password) {
            [weak self] driver in
            if driver != nil { self?.loginButtonTouchUpInside() }
        }
    }
#endif

    // MARK:- Actions

    @objc func loginButtonTouchUpInside() {
        let controller = LoginViewController()
        AppController.shared.showMain(animated: true, rootViewController: controller, showProfileButton: false)
    }
}
