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

class MainViewController: BaseViewController, StateServiceManagerProtocol, ChildViewDelegate {
    
    private var serviceState = ServiceState.noninit
    
    var currentViewController: ChildViewController?
    var previousView: UIView?
    
    override func viewDidLoad() {
        StateServiceManager.sharedInstance.addDelegate(delegate: self)
        StateServiceManager.sharedInstance.updateState(state: .loading)
        super.viewDidLoad()
        setNavigationBarItem()
    }
    
    deinit {
        StateServiceManager.sharedInstance.removeDelegate(delegate: self)
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    func stateDidChange(oldState: ServiceState, newState: ServiceState) {
        updateState(state: newState)
    }
    
    func updateState(state: ServiceState) {
        if state == serviceState {
            return
        }
        
        VLAnalytics.logEventWithName(VLAnalytics.stateChangeEvent, paramName: VLAnalytics.stateParam, paramValue: "\(state.rawValue)")
        
        setTitle(title: getTitleForState(state: state))
        
        var changeView = true
        serviceState = state
        
        if serviceState == .loading || serviceState == .noninit {
            
            if currentViewController != nil && (currentViewController?.isKind(of: LoadingViewController.self))! {
                changeView = false
            } else {
                let loadingViewController = LoadingViewController()
                currentViewController = loadingViewController
            }
            
        } else if serviceState == .idle {
            
            if currentViewController != nil && (currentViewController?.isKind(of: VehiclesViewController.self))! {
                changeView = false
            } else {
                let vehiclesViewController = VehiclesViewController(state: serviceState)
                currentViewController = vehiclesViewController
            }
            
        } else if serviceState == .needService || serviceState == .enRouteForService {
            
            if currentViewController != nil && (currentViewController?.isKind(of: ServiceCarViewController.self))! {
                changeView = false
            } else {
                let serviceCarViewController = ServiceCarViewController(state: serviceState)
                currentViewController = serviceCarViewController
            }
            
        } else if serviceState == .schedulingService {
            
            if currentViewController != nil && (currentViewController?.isKind(of: SchedulingPickupViewController.self))! {
                changeView = false
            } else {
                let schedulingPickupViewController = SchedulingPickupViewController(state: serviceState)
                currentViewController = schedulingPickupViewController
            }
            
        } else if serviceState.rawValue >= ServiceState.pickupScheduled.rawValue && serviceState.rawValue <= ServiceState.arrivedForPickup.rawValue {
            if currentViewController != nil && (currentViewController?.isKind(of: ScheduledPickupViewController.self))! {
                changeView = false
            } else {
                let scheduledPickupViewController = ScheduledPickupViewController(state: serviceState)
                currentViewController = scheduledPickupViewController
            }
            
        } else if serviceState == .service || serviceState == .serviceCompleted || serviceState == .completed {
            
            if currentViewController != nil && (currentViewController?.isKind(of: ServiceCarViewController.self))! {
                changeView = false
            } else {
                let serviceCarViewController = ServiceCarViewController(state: serviceState)
                currentViewController = serviceCarViewController
            }
        } else if serviceState == .schedulingDelivery {
            
            if currentViewController != nil && (currentViewController?.isKind(of: SchedulingDropoffViewController.self))! {
                changeView = false
            } else {
                let schedulingDropoffViewController = SchedulingDropoffViewController(state : serviceState)
                currentViewController = schedulingDropoffViewController
            }
        } else if serviceState.rawValue >= ServiceState.dropoffScheduled.rawValue && serviceState.rawValue <= ServiceState.arrivedForDropoff.rawValue {
            if currentViewController != nil && (currentViewController?.isKind(of: ScheduledDropoffViewController.self))! {
                changeView = false
            } else {
                let scheduledDeliveryViewController = ScheduledDropoffViewController(state: serviceState)
                currentViewController = scheduledDeliveryViewController
            }
        }
    
        if !changeView {
            currentViewController?.stateDidChange(state: serviceState)
        }
        
        if let currentViewController = currentViewController, changeView {
            currentViewController.view.accessibilityIdentifier = "currentViewController"
            currentViewController.childViewDelegate = self
            if let view = previousView {
                view.removeFromSuperview()
            }
            
            if let view = currentViewController.view {
                previousView = view
                self.view.addSubview(view)
                
                view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    func getTitleForState(state: ServiceState) -> String? {
        
        if state.rawValue == ServiceState.idle.rawValue || state.rawValue == ServiceState.needService.rawValue {
            return .ScheduleService
        } else if state.rawValue >= ServiceState.pickupScheduled.rawValue && state.rawValue < ServiceState.enRouteForService.rawValue {
            return .ScheduledPickup
        } else if state.rawValue >= ServiceState.enRouteForService.rawValue && state.rawValue < ServiceState.serviceCompleted.rawValue {
            return .CurrentService
        } else if state.rawValue == ServiceState.serviceCompleted.rawValue {
            return .ReturnVehicle
        } else if state.rawValue > ServiceState.dropoffScheduled.rawValue {
            return .ScheduledDelivery
        }
        return nil
    }
    
    func setTitle(title: String?) {
        if let title = title {
            self.navigationController?.title = title
            self.navigationController?.navigationItem.title = title
            self.navigationController?.navigationBar.topItem?.title = title
        }
    }
    
    func setTitleFromChild(title: String) {
        setTitle(title: title)
    }
    
    func pushViewController(controller: UIViewController, animated: Bool, backLabel: String?, title: String?) {
        self.navigationController?.pushViewController(controller, animated: animated)
        let backItem = UIBarButtonItem(title: .Back, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    func popViewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func popToRootViewController(animated: Bool) {
        self.navigationController?.popToRootViewController(animated: animated)
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
