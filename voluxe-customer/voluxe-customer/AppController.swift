//
//  AppController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 7/24/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class AppController {
    
    init() {
    }
    
    static let sharedInstance: AppController = {
        let instance = AppController()
        instance.appDelegate = UIApplication.shared.delegate as? AppDelegate
        return instance
    }()
    
    
    private var appDelegate: AppDelegate?
    
    // MARK:- Navigation
    
    var currentViewController: RootViewController? {
        return appDelegate?.rootViewController
    }
    
    var slideMenuController: VLSlideMenuController? {
        return appDelegate?.rootViewController?.slideMenuController
    }
    
    func startApp() {
        currentViewController?.startApp()
    }
    
    func phoneVerificationScreen() {
        currentViewController?.phoneVerificationScreen()
    }
    
    func showAddVehicleScreen() {
        currentViewController?.showAddVehicleScreen()
    }
    
    func showVehiclesView(animated: Bool) {
        currentViewController?.showVehiclesView(animated: animated)
    }
    
    func settingsScreen() {
        currentViewController?.settingsScreen()
    }
    
    func helpScreen() {
        currentViewController?.helpScreen()
    }
    
    func loadViewForVehicle(vehicle: Vehicle, state: ServiceState) {
        currentViewController?.loadViewForVehicle(vehicle: vehicle, state: state)
    }
    
    func showLoadingView() {
        currentViewController?.switchToLoadingView()
    }
    
    func loadBookingFeedback(bookingFeedback: BookingFeedback) {
        currentViewController?.loadBookingFeedback(bookingFeedback: bookingFeedback)
    }
    
    // MARK:- Dialogs

    func showForceUpgradeDialog() {
        if let rootViewController = currentViewController {
            // check if already added
            if let _ = rootViewController.presentedViewController as? VLAlertViewController {
                return
            }
            let alert = VLAlertViewController(title: String.ForceUpgradeTitle, message: String.ForceUpgradeMessage, cancelButtonTitle: nil, okButtonTitle: String.Ok.uppercased())
            alert.delegate = appDelegate
            alert.dismissOnTap = false
            
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func showSoftUpgradeDialog(version: String) {
        if let rootViewController = currentViewController {
            // don't show on LoadingViewController as it autodismiss
            if rootViewController.current is LoadingViewController {
                return
            }
            // check if already added
            if let _ = rootViewController.presentedViewController as? VLAlertViewController {
                return
            }
            
            let alert = VLAlertViewController(title: String.SoftUpgradeTitle, message: String.SoftUpgradeMessage, cancelButtonTitle: String.NotNow, okButtonTitle: String.Ok.uppercased())
            alert.delegate = appDelegate
            alert.dismissOnTap = true
            
            rootViewController.present(alert, animated: true, completion: {
                UserDefaults.standard.latestCheckedVersion = version
            })
        }
    }
    
}
