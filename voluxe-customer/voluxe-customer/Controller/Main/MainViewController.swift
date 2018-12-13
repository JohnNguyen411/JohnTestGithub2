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

class MainViewController: BaseVehicleViewController {
    
    var currentViewController: BaseViewController?
    var previousView: UIView?
   
    override func viewDidLoad() {
        stateDidChange(state: self.serviceState)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationBarItem()
        super.viewDidAppear(animated)
    }

    override func stateDidChange(state: ServiceState) {
        
        var newViewController: BaseViewController?
        setTitle(title: getTitleForState(state: state))
        
        var changeView = true
        serviceState = state
        
        if serviceState == .enRouteForService || serviceState == .service || serviceState == .serviceCompleted || serviceState == .completed {
            
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle), serviceState == .completed, booking.getBookingFeedbackId() > 0 {
                AppController.sharedInstance.loadViewForVehicle(vehicle: vehicle, state: .completed)
                return
            }
            if currentViewController != nil && (currentViewController?.isKind(of: ServiceCarViewController.self))! {
                changeView = false
            } else {
                let serviceCarViewController = ServiceCarViewController(vehicle: vehicle, state: serviceState)
                newViewController = serviceCarViewController
            }
            
        } else if serviceState.rawValue >= ServiceState.pickupScheduled.rawValue && serviceState.rawValue <= ServiceState.arrivedForPickup.rawValue {
            
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                if booking.isSelfIB() {
                    if currentViewController != nil && (currentViewController?.isKind(of: ScheduledSelfPickup.self))! {
                        changeView = false
                    } else {
                        let scheduledPickupViewController = ScheduledSelfPickup(vehicle: vehicle, state: state, screen: .dropoffSelfActive)
                        newViewController = scheduledPickupViewController
                    }
                    setTitle(title: .viewScheduleServiceStatusSelfAdvisorPickup)
                } else {
                    if booking.isActive() {
                        if currentViewController != nil && (currentViewController?.isKind(of: ScheduledPickupViewController.self))! {
                            changeView = false
                        } else {
                            let scheduledPickupViewController = ScheduledPickupViewController(vehicle: vehicle, state: serviceState)
                            newViewController = scheduledPickupViewController
                        }
                    } else {
                        AppController.sharedInstance.showVehiclesView(animated: true)
                    }
                }
            }
            
        } else if serviceState.rawValue >= ServiceState.dropoffScheduled.rawValue && serviceState.rawValue <= ServiceState.arrivedForDropoff.rawValue {
            
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                if booking.isSelfOB() {
                    if currentViewController != nil && (currentViewController?.isKind(of: ScheduledSelfDropoff.self))! {
                        changeView = false
                    } else {
                        let scheduledDeliveryViewController = ScheduledSelfDropoff(vehicle: vehicle, state: state, screen: .dropoffSelfActive)
                        newViewController = scheduledDeliveryViewController
                    }
                    setTitle(title: .viewScheduleServiceStatusSelfAdvisorDropoff)
                } else {
                    if booking.isActive() {
                        if currentViewController != nil && (currentViewController?.isKind(of: ScheduledDropoffViewController.self))! {
                            changeView = false
                        } else {
                            let scheduledDeliveryViewController = ScheduledDropoffViewController(vehicle: vehicle, state: serviceState)
                            newViewController = scheduledDeliveryViewController
                        }
                    } else {
                        AppController.sharedInstance.showVehiclesView(animated: true)
                    }
                }
            }
        } else if serviceState == .idle {
            AppController.sharedInstance.showVehiclesView(animated: true)
        }
        
        if !changeView {
            currentViewController?.stateDidChange(state: serviceState)
        }

        if let newViewController = newViewController, changeView {
           self.updateChildViewController(uiViewController: newViewController)
        }
    }
    
    private func updateChildViewController(uiViewController: BaseViewController) {
        uiViewController.view.accessibilityIdentifier = "currentViewController"
        addChild(uiViewController)
        uiViewController.view.frame = view.bounds
        view.addSubview(uiViewController.view)
        uiViewController.didMove(toParent: self)
        
        if let currentViewController = self.currentViewController {
            currentViewController.willMove(toParent: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParent()
        }
        
        currentViewController = uiViewController
    }
    
    func getTitleForState(state: ServiceState) -> String? {
        
        if state.rawValue == ServiceState.idle.rawValue || state.rawValue == ServiceState.needService.rawValue {
            return .scheduleService
        } else if state.rawValue >= ServiceState.pickupScheduled.rawValue && state.rawValue < ServiceState.enRouteForService.rawValue {
            return .scheduledPickup
        } else if state.rawValue >= ServiceState.enRouteForService.rawValue && state.rawValue < ServiceState.serviceCompleted.rawValue {
            return .currentService
        } else if state.rawValue == ServiceState.serviceCompleted.rawValue {
            return .viewScheduleServiceOptionDropoff
        } else if state.rawValue >= ServiceState.dropoffScheduled.rawValue {
            return .scheduledDelivery
        }
        return nil
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
        Logger.print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        Logger.print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        Logger.print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        Logger.print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        Logger.print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        Logger.print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        Logger.print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        Logger.print("SlideMenuControllerDelegate: rightDidClose")
    }
}
