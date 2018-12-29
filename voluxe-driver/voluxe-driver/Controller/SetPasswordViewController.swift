//
//  SetPasswordViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/23/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class SetPasswordViewController: StepViewController {

    // MARK: Layout

    private let cancelButton = UIButton.Volvo.secondary(title: Localized.cancel)
    private let nextButton = UIButton.Volvo.primary(title: Localized.next)

    // MARK: Lifecycle

    convenience init() {
        self.init(title: Localized.createYourPassword)
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
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func cancelButtonTouchUpInside() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
