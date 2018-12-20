//
//  TemplateViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

// IMPORTANT!
// DO NOT USE THIS CLASS DIRECTLY
// This is a temporary service to copy and paste a new controller class.
class TemplateViewController: UIViewController {

    // MARK: Layout

    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("CLOSE", for: .normal)
        button.setTitleColor(UIColor.Volvo.brightBlue, for: .normal)
        return button
    }()

    // MARK: Lifecycle

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.addActions()
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView()

        gridView.add(subview: self.button, from: 1, to: 2)
        self.button.pinToSuperviewTop(spacing: 20)
    }

    // MARK: Actions

    private func addActions() {
        self.button.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
    }

    @objc func buttonTouchUpInside() {
        // nothing yet
    }
}
