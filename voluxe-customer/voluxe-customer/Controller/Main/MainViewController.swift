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

class MainViewController: BaseViewController, StateServiceManagerProtocol {
    
    private var serviceState = ServiceState.noninit
    
    static var navigationBarHeight: CGFloat = 0
    var currentViewController: BaseViewController?

    override func viewDidLoad() {
        StateServiceManager.sharedInstance.addDelegate(delegate: self)
        super.viewDidLoad()
        setNavigationBarItem()
        if let navigationController = self.navigationController {
            MainViewController.navigationBarHeight = navigationController.navigationBar.frame.size.height
        }
    }
    
    deinit {
        StateServiceManager.sharedInstance.removeDelegate(delegate: self)
    }
    
    override func setupViews() {
        super.setupViews()
        StateServiceManager.sharedInstance.updateState(state: ServiceState.idle)
    }
    
    func stateDidChange(oldState: ServiceState, newState: ServiceState) {
        updateState(state: newState)
    }
    
    func updateState(state: ServiceState) {
        if state == serviceState {
            return
        }
        
        var changeView = true
        serviceState = state
        
        if serviceState == .idle || serviceState == .needService ||
            serviceState == .pickupDriverDrivingToDealership || serviceState == .pickupDriverAtDealership {
            
            if currentViewController != nil && (currentViewController?.isKind(of: SchedulingPickupViewController.self))! {
                currentViewController?.stateDidChange(state: serviceState)
                changeView = false
            } else {
                let schedulingPickupViewController = SchedulingPickupViewController(state: serviceState)
                currentViewController = schedulingPickupViewController
            }
            
            
        } else if serviceState == .pickupScheduled {
            let scheduledPickupViewController = ScheduledPickupViewController()
            currentViewController = scheduledPickupViewController
        } else if serviceState == .servicing || serviceState == .serviceCompleted {
            
            if currentViewController != nil && (currentViewController?.isKind(of: SchedulingDropoffViewController.self))! {
                currentViewController?.stateDidChange(state: serviceState)
                changeView = false
            } else {
                let schedulingDropoffViewController = SchedulingDropoffViewController(state : serviceState)
                currentViewController = schedulingDropoffViewController
            }
        } else if serviceState == .deliveryScheduled {
            let scheduledDeliveryViewController = ScheduledDropoffViewController()
            currentViewController = scheduledDeliveryViewController
        }
        
        if changeView {
            if let view = currentViewController?.view {
                view.removeFromSuperview()
            }
            
            if let view = currentViewController?.view {
                self.view.addSubview(view)
                
                view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
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
