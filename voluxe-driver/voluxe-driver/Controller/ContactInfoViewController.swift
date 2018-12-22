//
//  ContactInfoViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/20/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ContactInfoViewController: StepViewController {

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

    // MARK: Lifecycle

    // TODO localize
    convenience init() {
        self.init(title: "Contact Information")
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
    }

    // MARK: Actions

    private func addActions() {
        self.nextButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func nextButtonTouchUpInside() {
        let controller = ConfirmPhoneViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func cancelButtonTouchUpInside() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
