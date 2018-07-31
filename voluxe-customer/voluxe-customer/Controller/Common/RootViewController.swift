//
//  RootViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 7/23/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift
import SwiftEventBus
import UserNotifications

/// Class used in AppDelegate and should always be use as the appDelegate.rootViewController
class RootViewController: UIViewController {

    // Currently displayed UIViewController
    var current: UIViewController
    
    var slideMenuController: VLSlideMenuController?
    
    init() {
        current = LogoViewController(screen: .splash)
        super.init(nibName:  nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParentViewController: self)
    }
    
    func showLandingScreen() {
        let new = UINavigationController(rootViewController: FTUEStartViewController())
        switchTo(uiViewController: new)
    }
    
    func switchToLoadingView() {
        let loadingViewController = LoadingViewController()
        animateFadeTransition(to: loadingViewController)
    }
    
    func switchToMainScreen() {
        createMenuView()
        if let slideMenuController = self.slideMenuController {
            animateFadeTransition(to: slideMenuController)
        }
    }
    
    func switchTo(uiViewController: UIViewController) {
        if current == uiViewController { return }
        
        addChildViewController(uiViewController)
        uiViewController.view.frame = view.bounds
        view.addSubview(uiViewController.view)
        uiViewController.didMove(toParentViewController: self)
        
        current.willMove(toParentViewController: nil)
        current.view.removeFromSuperview()
        current.removeFromParentViewController()
        
        current = uiViewController
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        if current == new { return }
        
        current.willMove(toParentViewController: nil)
        addChildViewController(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            
        }) { completed in
            self.current.removeFromParentViewController()
            new.didMove(toParentViewController: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        if current == new { return }
        
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParentViewController: nil)
        addChildViewController(new)
        new.view.frame = initialFrame
        
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParentViewController()
            new.didMove(toParentViewController: self)
            self.current = new
            completion?()
        }
    }
    
    func startApp() {
        if !UserManager.sharedInstance.isLoggedIn() {
            showLandingScreen()
        } else {
            switchToLoadingView()
        }
    }
    
    
    /// Init SlideMenuController
    fileprivate func createMenuView() {
        
        let mainViewController = VehiclesViewController(state: .idle)
        mainViewController.view.accessibilityIdentifier = "mainViewController"
        
        let uiNavigationController = VLNavigationController(rootViewController: mainViewController)
        uiNavigationController.view.accessibilityIdentifier = "uiNavigationController"
        
        styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
        
        uiNavigationController.setTitle(title: .PickupAndDelivery)
        
        if let leftVC = self.slideMenuController?.leftViewController as? LeftViewController {
            leftVC.mainNavigationViewController = uiNavigationController
            self.slideMenuController?.leftViewController = leftVC
            leftVC.changeMainViewController(uiNavigationController: uiNavigationController, title: uiNavigationController.title, animated: true)
        } else {
            let leftViewController = LeftViewController()
            leftViewController.view.accessibilityIdentifier = "leftViewController"
            leftViewController.mainNavigationViewController = uiNavigationController
            
            let menuController = VLSlideMenuController(mainViewController: uiNavigationController, leftMenuViewController: leftViewController)
            menuController.automaticallyAdjustsScrollViewInsets = true
            menuController.view.accessibilityIdentifier = "slideMenuController"
            self.slideMenuController = menuController
        }
    }
    
    
    //MARK: - RootVC Navigation

    func phoneVerificationScreen() {
        let uiNavigationController = VLNavigationController(rootViewController: FTUEPhoneVerificationViewController())
        styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
        switchTo(uiViewController: uiNavigationController)
    }
    
    func showAddVehicleScreen() {
        let uiNavigationController = VLNavigationController(rootViewController: FTUEAddVehicleViewController())
        styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
        switchTo(uiViewController: uiNavigationController)
    }
    
    
    private func styleNavigationBar(navigationBar: UINavigationBar) {
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .luxeCobaltBlue()
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    
    
    //MARK: - SlideMenuController Navigation
    
    // showVehiclesView: show VehiclesView if no active services, current service if any
    func showVehiclesView(animated: Bool) {
        switchToMainScreen()
        
        self.displayActiveBooking()
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .notDetermined else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                if UserManager.sharedInstance.getBookings().count > 0 {
                    var requestPermission = false
                    for booking in UserManager.sharedInstance.getBookings() {
                        if booking.isInvalidated || booking.getState() == .canceled || booking.getState() == .completed { continue }
                        if UserDefaults.standard.shouldShowNotifPermissionForBooking(booking: booking) {
                            UserDefaults.standard.showNotifPermissionForBooking(booking: booking, shouldShow: true)
                            requestPermission = true
                            break
                        }
                    }
                    if requestPermission {
                        SwiftEventBus.post("requestNotifPermission")
                    }
                }
            })
        }
    }
    
    private func displayActiveBooking() {
        if UserManager.sharedInstance.getActiveBookings().count > 0 {
            let booking = UserManager.sharedInstance.getActiveBookings()[0]
            if let vehicle = booking.vehicle {
                let state = StateServiceManager.sharedInstance.getState(vehicleId: vehicle.id)
                if state != .idle {
                    self.loadViewForVehicle(vehicle: vehicle, state: state)
                }
            }
        }
    }
    
    func loadViewForVehicle(vehicle: Vehicle, state: ServiceState) {

        if let slideMenu = slideMenuController {
            if let leftVC = slideMenu.leftViewController as? LeftViewController {
                var vehicleViewController: BaseViewController?
                if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle), booking.needsRating(), state == .completed {
                    vehicleViewController = BookingRatingViewController(booking: booking)
                } else {
                    vehicleViewController = MainViewController(vehicle: vehicle, state: state)
                }
                let uiNavigationController = VLNavigationController(rootViewController: vehicleViewController!)
                styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
                leftVC.changeMainViewController(uiNavigationController: uiNavigationController, title: nil, animated: true)
            }
        }
    }
    
    func loadBookingFeedback(bookingFeedback: BookingFeedback) {
        createMenuView()
        if let slideMenu = self.slideMenuController {
            if let leftVC = slideMenu.leftViewController as? LeftViewController {
                let uiNavigationController = VLNavigationController(rootViewController: BookingRatingViewController(bookingFeedback: bookingFeedback))
                self.styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
                leftVC.changeMainViewController(uiNavigationController: uiNavigationController, title: nil, animated: true)
            }
        }
    }
    
    func settingsScreen() {
        if let slideMenu = slideMenuController {
            if let leftVC = slideMenu.leftViewController as? LeftViewController {
                let uiNavigationController = VLNavigationController(rootViewController: SettingsViewController())
                styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
                leftVC.changeMainViewController(uiNavigationController: uiNavigationController, title: .Settings, animated: true)
            }
        }
    }
    
    func helpScreen() {
        if let slideMenu = slideMenuController {
            if let leftVC = slideMenu.leftViewController as? LeftViewController {
                let uiNavigationController = VLNavigationController(rootViewController: HelpViewController())
                styleNavigationBar(navigationBar: uiNavigationController.navigationBar)
                leftVC.changeMainViewController(uiNavigationController: uiNavigationController, title: .Help, animated: true)
            }
        }
    }
    
}
