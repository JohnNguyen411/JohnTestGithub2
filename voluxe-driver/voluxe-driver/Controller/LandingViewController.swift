//
//  LandingViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/10/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class LandingViewController: UIViewController {
    
    // MARK:- Layout
    
    private let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let loginButton = UIButton.Volvo.text(title: Localized.signIn)
    
    // MARK:- Lifecycle
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.loginButton.addTarget(self, action: #selector(loginButtonTouchUpInside), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        
        UserDefaults.standard.enableAlamoFireLogging = true
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        let gridView = self.view.addGridLayoutView(with: GridLayout.volvoAgent())
        
        gridView.add(subview: self.logoImageView, from: 2, to: 5)
        self.logoImageView.pinToSuperviewTop(spacing: 96)
        self.logoImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        gridView.add(subview: self.loginButton, from:3, to: 4)
        self.loginButton.pinBottomToSuperviewBottom(spacing: -153)
        
        if let token = KeychainManager.shared.getToken() {
            self.loginButton.alpha = 0
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            DriverAPI.loadToken(token: token)
            DriverManager.shared.me(completion: { [weak self] driver, error in
                
                if let view = self?.view {
                    MBProgressHUD.hide(for: view, animated: true)
                }
                
                if let driver = driver {
                    let steps = FlowViewController.loginSteps(for: driver)
                    
                    if steps.count == 0 {
                        self?.openMainController()
                    } else {
                        AppController.shared.showMain(animated: true,
                                                      rootViewController: FlowViewController(steps: steps, direction: .horizontal),
                                                      showProfileButton: false)
                    }
                } else {
                    KeychainManager.shared.setToken(token: nil)
                    UIView.animate(withDuration: 0.25, animations: {
                        self?.loginButton.alpha = 1
                    })
                }
            })
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackView(screen: .landing)
    }
    
    private func openMainController() {
        let controller = MyScheduleViewController()
        AppController.shared.showMain(animated: true, rootViewController: controller, showProfileButton: true)
    }
    
    // MARK:- Actions
    
    @objc func loginButtonTouchUpInside() {
        let controller = LoginViewController()
        AppController.shared.showMain(animated: true, rootViewController: controller, showProfileButton: false)
    }
}
