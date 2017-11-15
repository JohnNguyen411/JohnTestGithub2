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
    
    public enum ServiceState: Int {
        case noninit = -999
        case idle = 0
        case scheduled = 10
    }
    
    private var serviceState = ServiceState.noninit
    
    static var navigationBarHeight: CGFloat = 0
    var currentViewController: BaseViewController?

    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
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

        if serviceState == .idle {
            let schedulePickupViewController = SchedulePickupViewController()
            currentViewController = schedulePickupViewController
            
        } else if serviceState == .scheduled {
            let scheduledPickupViewController = ScheduledPickupViewController()
            currentViewController = scheduledPickupViewController
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
