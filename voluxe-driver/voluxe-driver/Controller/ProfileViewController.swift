//
//  LoginViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/18/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {

    // MARK: Layout

    // Panel view that will have rounded corners on iPhone X style screens.
    private let panelView: UIView = {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.Volvo.background.light
        view.layer.cornerRadius = view.hasTopNotch ? 40 : 0
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 7
        return view
    }()

    // Button that fills the entire screen behind the rounded panel view.
    private let dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.Volvo.black.withAlphaComponent(0.67)
        return button
    }()

    private let changeInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Change Information", for: .normal)
        button.setTitleColor(UIColor.Volvo.brightBlue, for: .normal)
        return button
    }()

    private let changePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(UIColor.Volvo.brightBlue, for: .normal)
        return button
    }()

    private let logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sign-Out", for: .normal)
        button.setTitleColor(UIColor.Volvo.brightBlue, for: .normal)
        return button
    }()

    // MARK: Lifecycle

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.addActions()
        self.modalPresentationStyle = .overCurrentContext
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // this is necessary to allow transparent black background
        self.view.isOpaque = false

        // grid view fills entire screen
        let gridView = GridLayoutView(layout: GridLayout.volvoAgent())
        Layout.fill(view: self.view, with: gridView, useSafeArea: false)

        // dismiss fills entire view underneath panel view
        Layout.fill(view: gridView, with: self.dismissButton, useSafeArea: false)

        // TODO need to extend to be concentric to screen edge
        gridView.addSubview(self.panelView)
        let topConstant: CGFloat = gridView.hasTopNotch ? 0 : -20
        let trailingAnchor = gridView.trailingAnchor(for: 5)
        self.panelView.leadingAnchor.constraint(equalTo: gridView.leadingAnchor).isActive = true
        self.panelView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.panelView.pinToSuperviewTop(spacing: topConstant)
        self.panelView.pinBottomToSuperviewBottom()

        panelView.add(subview: self.changeInfoButton, from: 1, to: 3)
        self.changeInfoButton.pinToSuperviewTop(spacing: 100)

        panelView.add(subview: self.changePasswordButton, from: 1, to: 3)
        self.changePasswordButton.pinTopToBottomOf(view: self.changeInfoButton, spacing: 20)

        panelView.add(subview: self.logoutButton, from: 1, to: 3)
        self.logoutButton.pinTopToBottomOf(view: self.changePasswordButton, spacing: 20)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: Actions

    private func addActions() {
        self.dismissButton.addTarget(self, action: #selector(dismissButtonTouchUpInside), for: .touchUpInside)
        self.changeInfoButton.addTarget(self, action: #selector(changeInfoButtonTouchUpInside), for: .touchUpInside)
        self.changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTouchUpInside), for: .touchUpInside)
        self.logoutButton.addTarget(self, action: #selector(logoutButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func dismissButtonTouchUpInside() {
        AppController.shared.hideProfile()
    }

    @objc func changeInfoButtonTouchUpInside() {
        let controller = StepViewController(title: "Contact Information")
        AppController.shared.mainController(push: controller, hideProfileButton: true)
        AppController.shared.hideProfile(animated: true)
    }

    @objc func changePasswordButtonTouchUpInside() {
        let controller = StepViewController(title: "Create a Password")
        AppController.shared.mainController(push: controller, hideProfileButton: true)
        AppController.shared.hideProfile()
    }

    @objc func logoutButtonTouchUpInside() {
        DriverManager.shared.logout()
        AppController.shared.hideProfile()
    }

    // MARK: Animations

    func preparePresentAnimation() {
        self.view.isHidden = true
    }

    func playPresentAnimation(completion: (() -> ())? = nil) {

        self.view.isHidden = false
        self.dismissButton.alpha = 0
        self.panelView.layer.shadowOpacity = 0
        let x = -self.panelView.bounds.size.width
        self.panelView.transform = CGAffineTransform(translationX: x, y: 0)

        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [UIView.AnimationOptions.curveEaseOut],
                       animations:
            {
                self.dismissButton.alpha = 1
                self.panelView.layer.shadowOpacity = 0.7
                self.panelView.transform = CGAffineTransform.identity
            },
                       completion:
            {
                finish in
                completion?()
            })
    }

    func playDismissAnimation(completion: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [UIView.AnimationOptions.curveEaseIn],
                       animations:
            {
                self.dismissButton.alpha = 0
                self.panelView.layer.shadowOpacity = 0
                let x = -self.panelView.bounds.size.width
                self.panelView.transform = CGAffineTransform(translationX: x, y: 0)
            },
                       completion:
            {
                    finish in
                    completion?()
            })
    }
}

// TODO create a private view for the menu
// TODO embed the buttons from above in it
