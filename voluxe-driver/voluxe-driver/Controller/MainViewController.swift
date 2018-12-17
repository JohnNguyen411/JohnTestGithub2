//
//  MainViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/11/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UINavigationController {

    // MARK:- Layout

    private let profileButton: UIButton = {
        let button = ProfileButton().usingAutoLayout()
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 4, bottom: 5, right: 10)
        return button
    }()

    // MARK:- Lifecycle

    // TODO need flavor to support launching with another view controller
    // TODO button will not be visible for all root controllers
    convenience init() {
        self.init(rootViewController: MyScheduleViewController())
        self.configureNavigationBar()
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBar.appearance()
        appearance.backgroundColor = Color.NavigationBar.background
        appearance.titleTextAttributes = [NSAttributedString.Key.font: Font.Volvo.h6,
                                          NSAttributedString.Key.foregroundColor: Color.NavigationBar.title]
        self.navigationBar.isTranslucent = false
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = Color.Background.light

        // this puts the button ABOVE the navigation, not as the right item
        // this is necessary to avoid every controller pushed onto it
        // needing to have the same button as the navigationItem.rightBarButtonItem
        self.view.addSubview(self.profileButton)
        self.profileButton.topAnchor.constraint(equalTo: self.navigationBar.topAnchor,
                                                constant: 0).isActive = true
        self.profileButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.profileButton.trailingAnchor.constraint(equalTo: self.navigationBar.trailingAnchor,
                                                     constant: 0).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DriverManager.shared.imageForDriver() {
            [weak self] image in
            self?.profileButton.setImage(image, for: .normal)
        }
    }
}
