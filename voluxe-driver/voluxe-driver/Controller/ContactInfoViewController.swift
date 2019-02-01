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

    private let cancelButton = UIButton.Volvo.secondary(title: Unlocalized.cancel)
    private let nextButton = UIButton.Volvo.primary(title: Unlocalized.next)

    // MARK: Lifecycle

    convenience init() {
        self.init(title: Unlocalized.contactInformation)
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
