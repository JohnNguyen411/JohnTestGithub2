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

    // MARK: Layout

    private let profileButton: UIButton = {
        let button = ProfileButton().usingAutoLayout()
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 4, bottom: 5, right: 10)
        return button
    }()

    // MARK: Lifecycle

    convenience init(with controller: UIViewController? = nil,
                     showProfileButton: Bool = true)
    {
        let controller = controller ?? MyScheduleViewController()
        self.init(rootViewController: controller)
        self.profileButton.isHidden = !showProfileButton
        self.profileButton.addTarget(self, action: #selector(buttonTouchUpInside), for: .touchUpInside)
//        self.configureNavigationBar()
    }

//    private func configureNavigationBar() {
//        let appearance = UINavigationBar.appearance()
//        appearance.backgroundColor = UIColor.Volvo.navigationBar.background
//        appearance.titleTextAttributes = [NSAttributedString.Key.font: Font.Volvo.h6,
//                                          NSAttributedString.Key.foregroundColor: UIColor.Volvo.navigationBar.title]
//        self.navigationBar.isTranslucent = false
////        self.addCustomBackButton()
//
////        UIImage *backButtonImage = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
//        let image = UIImage(named: "back_chevron")
////        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        UIBarButtonItem.appearance().setBackButtonBackgroundImage(image, for: .normal, barMetrics: .default)
//    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light

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

    // MARK: Actions

    @objc func buttonTouchUpInside() {
        AppController.shared.showProfile()
    }

    // MARK: Animations

    func showProfileButton(animated: Bool = true) {
        self.profileButton.isHidden = false
        UIView.animate(withDuration: animated ? 0.2 : 0) {
            self.profileButton.alpha = 1
        }
    }

    func hideProfileButton(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.2 : 0) {
            self.profileButton.alpha = 0
        }
    }

    override func pushViewController(_ viewController: UIViewController,animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        guard self.children.count > 1 else { return }
        self.hideProfileButton(animated: animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        if self.children.count <= 2 { self.showProfileButton(animated: animated) }
        return super.popViewController(animated: animated)
    }

    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        self.showProfileButton(animated: animated)
        return super.popToRootViewController(animated: animated)
    }
}
