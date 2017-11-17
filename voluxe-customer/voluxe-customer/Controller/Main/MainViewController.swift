//
//  MainViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/1/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

class MainViewController: BaseViewController {
    
    
    
    private var serviceState = ServiceState.noninit
    
    static var navigationBarHeight: CGFloat = 0
    var currentViewController: BaseViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        if let navigationController = self.navigationController {
            MainViewController.navigationBarHeight = navigationController.navigationBar.frame.size.height
        }
    }
    
    override func setupViews() {
        super.setupViews()
        updateState(state: ServiceState.idle)
    }
    
    func updateState(state: ServiceState) {
        if state == serviceState {
            return
        }
        serviceState = state
        
        if let view = currentViewController?.view {
            view.removeFromSuperview()
        }

        if serviceState == .idle || serviceState == .needService {
            let schedulingPickupViewController = SchedulingPickupViewController(state: serviceState)
            currentViewController = schedulingPickupViewController
        } else if serviceState == .pickupScheduled {
            let scheduledPickupViewController = ScheduledPickupViewController()
            currentViewController = scheduledPickupViewController
        } else if serviceState == .servicing || serviceState == .serviceCompleted {
            let schedulingDropoffViewController = SchedulingDropoffViewController(state : serviceState)
            currentViewController = schedulingDropoffViewController
        }
        
        if let view = currentViewController?.view {
            self.view.addSubview(view)
            
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    static func getNavigationBarHeight() -> CGFloat {
        return MainViewController.navigationBarHeight
    }
    
    override func keyboardWillAppear(_ notification: Notification) {
        super.keyboardWillAppear(notification)
        if let currentViewController = currentViewController {
            currentViewController.keyboardWillAppear(notification)
        }
    }
    
    override func keyboardWillDisappear(_ notification: Notification) {
        super.keyboardWillDisappear(notification)
        if let currentViewController = currentViewController {
            currentViewController.keyboardWillDisappear(notification)
        }
    }
}

extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
