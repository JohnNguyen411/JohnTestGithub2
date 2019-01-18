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

    private let cancelButton = UIButton.Volvo.secondary(title: Localized.cancel)
    private let nextButton = UIButton.Volvo.primary(title: Localized.next)
    private let forgotButton = UIButton.Volvo.text(title: Localized.forgotPassword)

    // MARK: Lifecycle

    convenience init() {
        self.init(title: Localized.signIn)
        self.addActions()
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())

        gridView.add(subview: self.cancelButton, from: 1, to: 2)
        self.cancelButton.pinToSuperviewTop(spacing: 20)

        gridView.add(subview: self.nextButton, from: 3, to: 4)
        self.nextButton.pinToSuperviewTop(spacing: 20)

        gridView.add(subview: self.forgotButton, from: 4, to: 6)
        self.forgotButton.pinTopToBottomOf(view: self.nextButton, spacing: 20)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.waitForRequestsDidChange()
    }

    // MARK: Animations

    /// This relies upon the RequestManager returning results, plus
    /// the association that AppController.associateManagers() does
    /// to pass the logged in driver to the RequestManager to start
    /// generating results.  If that association is broken, this
    /// will not work.
    private func waitForRequestsDidChange() {
        RequestManager.shared.requestsDidChangeClosure = {
            requests in
            AppController.shared.lookNotBusy()
            guard requests.count > 0 else { return }
            let controller = MyScheduleViewController()
            AppController.shared.mainController(push: controller,
                                                asRootViewController: true,
                                                prefersProfileButton: true)
        }
    }

    // MARK: Actions

    private func addActions() {
        self.nextButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside), for: .touchUpInside)
        self.forgotButton.addTarget(self, action: #selector(forgotButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func nextButtonTouchUpInside() {
        #if DEBUG
            guard let email = UserDefaults.standard.driverEmail else { return }
            guard let password = UserDefaults.standard.driverPassword else { return }
            AppController.shared.lookBusy()
            DriverManager.shared.login(email: email, password: password) { _ in }
        #endif
    }

    @objc func cancelButtonTouchUpInside() {
        AppController.shared.showLanding()
    }

    @objc func forgotButtonTouchUpInside() {
        let controller = ForgotPasswordViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
