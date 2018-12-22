//
//  LoginViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/22/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: StepViewController {

    // MARK: Layout

    private let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(UIColor.Volvo.brightBlue, for: .normal)
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("CANCEL", for: .normal)
        button.setTitleColor(UIColor.Volvo.cloudBerry, for: .normal)
        return button
    }()

    private let forgotButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("FORGOT PASSWORD", for: .normal)
        button.setTitleColor(UIColor.Volvo.volvoBlue, for: .normal)
        return button
    }()

    // MARK: Lifecycle

    // TODO localize
    convenience init() {
        self.init(title: "Sign-In")
        self.addActions()
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())

        gridView.add(subview: self.cancelButton, from: 2, to: 3)
        self.cancelButton.pinToSuperviewTop(spacing: 20)

        gridView.add(subview: self.nextButton, from: 4, to: 5)
        self.nextButton.pinToSuperviewTop(spacing: 20)

        gridView.add(subview: self.forgotButton, from: 2, to: 5)
        self.forgotButton.pinTopToBottomOf(view: self.nextButton, spacing: 20)
    }

    // MARK: Actions

    private func addActions() {
        self.nextButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside), for: .touchUpInside)
        self.forgotButton.addTarget(self, action: #selector(forgotButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func nextButtonTouchUpInside() {
        let controller = MyScheduleViewController()
        self.navigationController?.setViewControllers([controller], animated: true)
    }

    @objc func cancelButtonTouchUpInside() {
        AppController.shared.showLanding()
    }

    @objc func forgotButtonTouchUpInside() {
        let controller = ForgotPasswordViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
