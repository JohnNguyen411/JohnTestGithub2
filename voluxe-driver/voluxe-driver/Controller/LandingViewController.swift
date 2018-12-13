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

    private let buttonsView: ButtonsView = {
        let view = ButtonsView()
        view.createButton.addTarget(self, action: #selector(createButtonTouchUpInside), for: .touchUpInside)
        view.loginButton.addTarget(self, action: #selector(loginButtonTouchUpInside), for: .touchUpInside)
        return view
    }()

    // MARK:- Lifecycle

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = .white

        let gridView = self.view.addGridLayoutView(with: GridLayout.volvoValet())

        gridView.add(subview: self.logoImageView, from: 2, to: 5)
        self.logoImageView.pinToSuperviewTop(spacing: 96)
        self.logoImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true

        gridView.add(subview: self.buttonsView, from:2, to: 5)
        self.buttonsView.pinToSuperviewTop(spacing: 425)
    }

    // MARK:- Actions

    @objc func loginButtonTouchUpInside() {

    }

    @objc func createButtonTouchUpInside() {

    }
}

fileprivate class ButtonsView: UIView {

    let loginButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setTitleColor(Color.purple, for: .normal)
        button.setTitle("SIGN-IN", for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = Font.Volvo.button
        return button
    }()

    let seperaterLabel: UILabel = {
        let label = UILabel().usingAutoLayout()
        label.text = "|"
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()

    let createButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.contentHorizontalAlignment = .left
        button.setTitleColor(Color.purple, for: .normal)
        button.setTitle("CREATE ACCOUNT", for: .normal)
        button.titleLabel?.font = Font.Volvo.button
        return button
    }()

    convenience init() {

        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.addSubview(self.loginButton)
        self.addSubview(self.seperaterLabel)
        self.addSubview(self.createButton)

        self.loginButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.loginButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.loginButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2.8/8.0).isActive = true

        self.seperaterLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.seperaterLabel.leadingAnchor.constraint(equalTo: self.loginButton.trailingAnchor).isActive = true
        self.seperaterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.seperaterLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true

        self.createButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.createButton.leadingAnchor.constraint(equalTo: self.seperaterLabel.trailingAnchor).isActive = true
        self.createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.createButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
