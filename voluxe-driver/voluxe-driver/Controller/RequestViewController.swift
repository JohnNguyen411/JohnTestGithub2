//
//  RequestViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class RequestViewController: UIViewController {

    // MARK: Layout

    // TODO back button should rotate the up/down nature
    // of navigating through a request's task stack
    private let backButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.alpha = 0
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        button.titleLabel?.font = Font.Volvo.h4
        button.setTitle("\u{2039}", for: .normal)
        button.setTitleColor(UIColor.Volvo.navigationBar.button, for: .normal)
        return button
    }()

    // MARK: Lifecycle

    // TODO should not be allowed to start service unless day of
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Review Service"
        self.addActions()
    }

    // TODO present request for review
    // then if accepted capture RequestManager.requestDidChange()
    convenience init(with request: Request) {
        self.init()
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light

//        let scrollView = Layout.scrollView(in: self)
//        let contentView = Layout.verticalContentView(in: scrollView)
//        let gridView = contentView.addGridLayoutView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addBackButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.removeBackButton()
    }

    // MARK: Back button support

    // TODO utility func to add something to nav bar?
    private func addBackButton(animated: Bool = true) {

        guard let navigationBar = self.navigationController?.navigationBar else { return }
        guard self.backButton.superview == nil else { return }

        navigationBar.addSubview(self.backButton)
        self.backButton.topAnchor.constraint(equalTo: navigationBar.topAnchor).isActive = true
        self.backButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor).isActive = true
        self.backButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

        UIView.animate(withDuration: 0.2) {
            self.backButton.alpha = 1
        }
    }

    private func removeBackButton(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.2 : 0,
                       animations: { self.backButton.alpha = 0 })
        {
            finished in
            self.backButton.removeFromSuperview()
        }
    }

    // MARK: Actions

    private func addActions() {
        self.backButton.addTarget(self, action: #selector(backButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func backButtonTouchUpInside() {
        self.navigationController?.popViewController(animated: true)
        // TODO otherwise walk the task order state machine
    }
}
