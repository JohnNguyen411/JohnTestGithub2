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
import SwiftEventBus

class MainViewController: BaseViewController, ChildViewDelegate {
    
    private var serviceState = ServiceState.noninit
    
    private let vehicle: Vehicle
    let vehicleId: Int
    
    var currentViewController: ChildViewController?
    var previousView: UIView?
    
    init(vehicle: Vehicle, state: ServiceState) {
        self.vehicle = vehicle
        self.vehicleId = vehicle.id
        self.serviceState = state
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        SwiftEventBus.onMainThread(self, name:"stateDidChange") { result in
            let stateChange: StateChangeObject = result.object as! StateChangeObject
            self.stateDidChange(vehicleId: stateChange.vehicleId, oldState: stateChange.oldState, newState: stateChange.newState)
        }
        updateState(state: self.serviceState)
        super.viewDidLoad()
        setNavigationBarItem()
    }
    
    deinit {
        SwiftEventBus.unregister(self)
    }
    
    override func setupViews() {
        super.setupViews()
    }
    
    func stateDidChange(vehicleId: Int, oldState: ServiceState?, newState: ServiceState) {
        if vehicleId != vehicle.id {
            return
        }
        if serviceState == newState {
            return
        }
        updateState(state: newState)
    }
    
    func updateState(state: ServiceState) {
                
        setTitle(title: getTitleForState(state: state))
        
        var changeView = true
        serviceState = state
        
        if serviceState == .enRouteForService || serviceState == .service || serviceState == .serviceCompleted || serviceState == .completed {
            
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle), serviceState == .completed, booking.bookingFeedbackId > -1 {
                appDelegate?.loadViewForVehicle(vehicle: vehicle, state: .completed)
                return
            }
            if currentViewController != nil && (currentViewController?.isKind(of: ServiceCarViewController.self))! {
                changeView = false
            } else {
                let serviceCarViewController = ServiceCarViewController(vehicle: vehicle, state: serviceState)
                currentViewController = serviceCarViewController
            }
            
        } else if serviceState.rawValue >= ServiceState.pickupScheduled.rawValue && serviceState.rawValue <= ServiceState.arrivedForPickup.rawValue {
            if currentViewController != nil && (currentViewController?.isKind(of: ScheduledPickupViewController.self))! {
                changeView = false
            } else {
                let scheduledPickupViewController = ScheduledPickupViewController(vehicle: vehicle, state: serviceState)
                currentViewController = scheduledPickupViewController
            }
            
        } else if serviceState.rawValue >= ServiceState.dropoffScheduled.rawValue && serviceState.rawValue <= ServiceState.arrivedForDropoff.rawValue {
            if currentViewController != nil && (currentViewController?.isKind(of: ScheduledDropoffViewController.self))! {
                changeView = false
            } else {
                let scheduledDeliveryViewController = ScheduledDropoffViewController(vehicle: vehicle, state: serviceState)
                currentViewController = scheduledDeliveryViewController
            }
        } else if serviceState == .idle {
            self.appDelegate?.showVehiclesView(animated: true)
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
                    make.edgesEqualsToView(view: self.view)
                }
            }
            // TODO this has a bug where the current view controller never fires
            // viewDidAppear() so the analytics fail, find the correct way to do this
            // using the child view controller stuff
            currentViewController.viewDidAppear(false)
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
        } else if state.rawValue >= ServiceState.dropoffScheduled.rawValue {
            return .ScheduledDelivery
        }
        return nil
    }
    
    func setTitleFromChild(title: String) {
        setTitle(title: title)
    }

    // TODO https://github.com/volvo-cars/ios/issues/314
    // clarify the intent of this, it's deprecated but doesn't seem to be called
    @available(*, deprecated)
    func pushViewController(controller: UIViewController, animated: Bool, backLabel: String?, title: String?) {
        self.navigationController?.pushViewController(controller, animated: animated)
        if let backLabel = backLabel {
            let backItem = UIBarButtonItem(title: backLabel, style: .plain, target: self, action: #selector(onBackClicked))
            navigationItem.backBarButtonItem = backItem
        }
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
