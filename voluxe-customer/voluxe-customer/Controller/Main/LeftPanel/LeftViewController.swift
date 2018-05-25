//
//  LeftViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/1/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import SnapKit
import SwiftEventBus

enum LeftMenu: Int {
    case main = 0
    case settings = 1
    case logout = 2
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu, indexPath: IndexPath)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    private static let headerHeight: CGFloat = 40
    private static let maxActiveBookingHeight = 2
    private static let maxTableViewBookingHeight: CGFloat = CGFloat(LeftViewController.maxActiveBookingHeight) * LeftPanelVehicleCell.height + LeftViewController.headerHeight

    private let activeBookingsTableView = UITableView(frame: .zero)
    private let menuTableView = UITableView(frame: .zero)
    private let menus = [UserManager.sharedInstance.yourVolvoStringTitle(), String.Settings, String.Signout]
    
    private let closeButton = UIButton(type: UIButtonType.custom)

    private var activeBookings: [Booking] = []
    private var notificationDict: [Int: Bool] = [:] // use to know if we should display a red dot notification for a vehicle

    var mainNavigationViewController: UINavigationController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    deinit {
        SwiftEventBus.unregister(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseClicked), for: .touchUpInside)
        
        self.view.backgroundColor = .white
        
        self.menuTableView.isScrollEnabled = false
        self.menuTableView.separatorColor = UIColor.luxeLightGray()
        self.menuTableView.register(LeftPanelTableViewCell.self, forCellReuseIdentifier: LeftPanelTableViewCell.identifier)
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        
        self.activeBookingsTableView.isScrollEnabled = true
        self.activeBookingsTableView.separatorColor = UIColor.luxeLightGray()
        self.activeBookingsTableView.register(LeftPanelVehicleCell.self, forCellReuseIdentifier: LeftPanelVehicleCell.identifier)
        self.activeBookingsTableView.delegate = self
        self.activeBookingsTableView.dataSource = self
        
        setupViews()
        
        self.setActiveBooking(bookings: UserManager.sharedInstance.getActiveBookings())
        
        SwiftEventBus.onMainThread(self, name: "setActiveBooking") { result in
            // UI thread
            self.setActiveBooking(bookings: UserManager.sharedInstance.getActiveBookings())
        }
        
        
        SwiftEventBus.onMainThread(self, name:"stateDidChange") { result in
            let vehicle: Vehicle = result.object as! Vehicle
            self.stateDidChange(vehicleId: vehicle.id)
        }
        
    }
    
    func setupViews() {
        self.view.addSubview(closeButton)
        self.view.addSubview(menuTableView)
        self.view.addSubview(activeBookingsTableView)
        
        var bookingsH = CGFloat(activeBookings.count) * LeftPanelVehicleCell.height + LeftViewController.headerHeight
        if bookingsH > LeftViewController.maxTableViewBookingHeight {
            bookingsH = LeftViewController.maxTableViewBookingHeight
        }
        activeBookingsTableView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.equalsToTop(view: self.view, offset: 80)
            make.height.equalTo(bookingsH)
        }
        
        let tableH = CGFloat(menus.count) * LeftPanelTableViewCell.height()
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .luxeLightGray()
        self.view.addSubview(separator)
        
        menuTableView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(30)
            make.height.equalTo(tableH)
        }
        
        separator.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(menuTableView.snp.top)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        closeButton.snp.makeConstraints { make in
            make.equalsToTop(view: self.view)
            make.left.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    
    func changeViewController(_ menu: LeftMenu, indexPath: IndexPath) {
        switch menu {
        case .main:
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickLeftPanelMenuYourVolvos)
            self.changeMainViewController(uiNavigationController: self.mainNavigationViewController, title: nil, animated: true)
            self.updateNotificationBadge()
        case .settings:
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickLeftPanelMenuSettings)
            weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.settingsScreen()
        case .logout:
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickLeftPanelMenuLogout)
            UserManager.sharedInstance.logout()
            weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.startApp()
        }
    }
    
    func changeMainViewController(uiNavigationController: UINavigationController, title: String?, animated: Bool) {
        if let slideMenuController = self.slideMenuController() as? VLSlideMenuController {
            slideMenuController.changeMainViewController(uiNavigationController, close: true, animated: animated)
        } else {
            self.slideMenuController()?.changeMainViewController(uiNavigationController, close: true)
        }
        
        self.updateNotificationBadge()
        uiNavigationController.setTitle(title: title)
    }
    
    private func setActiveBooking(bookings: [Booking]) {
        activeBookings = bookings
        if activeBookings.count == 0 {
            activeBookingsTableView.isHidden = true
        } else {
            if activeBookings.count > LeftViewController.maxActiveBookingHeight {
                self.activeBookingsTableView.isScrollEnabled = true
            } else {
                self.activeBookingsTableView.isScrollEnabled = false
            }
            activeBookingsTableView.isHidden = false
            var bookingsH = CGFloat(activeBookings.count) * LeftPanelVehicleCell.height + LeftViewController.headerHeight
            if bookingsH > LeftViewController.maxTableViewBookingHeight {
                bookingsH = LeftViewController.maxTableViewBookingHeight
            }
            activeBookingsTableView.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(bookingsH)
            }
        }
        activeBookingsTableView.reloadData()
    }
    
    private func generateBookingLabel(_ booking: Booking) -> LeftPanelActiveBooking {
        
        let tapGesture = BookingTapGesture(target: self, action: #selector(bookingTapped(sender:)))
        tapGesture.booking = booking
        
        let label = LeftPanelActiveBooking(booking: booking)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
        
    }
    
    // show red dot update if needed
    func stateDidChange(vehicleId: Int) {
        if let viewController = self.slideMenuController()?.mainViewController {
            if let mainController = viewController as? MainViewController {
                if mainController.vehicleId == vehicleId {
                    // controller already on screen don't show update
                    return
                }
            }
        }
        showRedDot(vehicleId: vehicleId, show: true)
    }
    
    private func isShowingScreenForVehicle(vehicleId: Int) -> Bool {
        var showingScreen = false
        if let viewController = self.slideMenuController()?.mainViewController {
            if let baseController = viewController as? BaseViewController {
                if baseController is VehiclesViewController || baseController is MainViewController || baseController is SettingsViewController {
                    if let mainVc = baseController as? MainViewController, mainVc.vehicleId == vehicleId {
                        // screen showing car info, don't show notif
                        showingScreen = true
                    } else {
                        showingScreen = false
                    }
                }
            } else if let navController = viewController as? UINavigationController, navController.childViewControllers.count > 0 {
                for controller in navController.childViewControllers {
                    if controller is VehiclesViewController || controller is MainViewController || controller is SettingsViewController {
                        // screen showing car info, don't show notif
                        if let mainVc = controller as? MainViewController, mainVc.vehicleId == vehicleId {
                            showingScreen = true
                        } else {
                            showingScreen = false
                        }
                    }
                }
            }
        }
        return showingScreen
    }
    
    func showRedDot(vehicleId: Int, show: Bool) {
        notificationDict[vehicleId] = show
        updateNotificationBadge()
    }
    
    
    private func updateNotificationBadge() {
        var isShowingNotif = false
        
        for dictValue in notificationDict {
            
            if !isShowingNotif && dictValue.value {
                isShowingNotif = true
            }
        }
        if let viewController = self.slideMenuController()?.mainViewController {
            if let baseController = viewController as? BaseViewController {
                if baseController is VehiclesViewController || baseController is MainViewController || baseController is SettingsViewController {
                    baseController.setNavigationBarItem()
                    baseController.showNotifBadge(isShowingNotif)
                }
            } else if let navController = viewController as? UINavigationController, navController.childViewControllers.count > 0 {
                for controller in navController.childViewControllers {
                    if controller is VehiclesViewController || controller is MainViewController || controller is SettingsViewController {
                        controller.setNavigationBarItem()
                        if let baseController = controller as? BaseViewController {
                            baseController.showNotifBadge(isShowingNotif)
                        }
                    }
                }
            }
        }
    }
    
    @objc func bookingTapped(sender : BookingTapGesture) {
        if let booking = sender.booking, let vehicle = booking.vehicle, let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.loadViewForVehicle(vehicle: vehicle, state: Booking.getStateForBooking(booking: booking))
            showRedDot(vehicleId: vehicle.id, show: false)
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickLeftPanelMenuActiveBookings)
        }
    }
    
    @objc func onCloseClicked() {
        self.slideMenuController()?.closeLeft()
    }
}

class BookingTapGesture: UITapGestureRecognizer {
    var booking: Booking?
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == menuTableView {
            return LeftPanelTableViewCell.height()
        } else {
            return SettingsCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == menuTableView {
            if let menu = LeftMenu(rawValue: indexPath.row) {
                self.changeViewController(menu, indexPath: indexPath)
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)

            let booking = activeBookings[indexPath.row]
            if let vehicle = booking.vehicle, let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.loadViewForVehicle(vehicle: vehicle, state: Booking.getStateForBooking(booking: booking))
                showRedDot(vehicleId: vehicle.id, show: false)
                VLAnalytics.logEventWithName(AnalyticsConstants.eventClickLeftPanelMenuActiveBookings)
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == activeBookingsTableView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: LeftViewController.headerHeight))
            view.backgroundColor = UIColor.clear
            
            let separator = UIView(frame: CGRect(x: 15, y: LeftViewController.headerHeight - 1, width: tableView.bounds.width, height: 0.5))
            separator.backgroundColor = .luxeLightGray()
            view.addSubview(separator)
            
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width, height: LeftViewController.headerHeight))
            label.font = UIFont.volvoSansProMedium(size: 13)
            label.textColor = UIColor.luxeGray()
            label.text = String.ActiveBookings.uppercased()
            label.addUppercasedCharacterSpacing()
            view.addSubview(label)
            return view
        } else {
            return nil
        }
    }
    
    
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == menuTableView {
            return menus.count
        } else {
            return activeBookings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == menuTableView {
            let cell = LeftPanelTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: LeftPanelTableViewCell.identifier)
            if indexPath.row == menus.count - 1 {
                cell.setData(menus[indexPath.row], isButton: true)
            } else {
                cell.setData(menus[indexPath.row], isButton: false)
            }
            
            return cell
        } else {
            let cell = LeftPanelVehicleCell(style: UITableViewCellStyle.value1, reuseIdentifier: LeftPanelVehicleCell.identifier)
            if let vehicle = activeBookings[indexPath.row].vehicle {
                cell.setText(text: vehicle.vehicleDescription())
                if let showNotif = notificationDict[vehicle.id] {
                    cell.showNotification(show: showNotif)
                } else {
                    cell.showNotification(show: false)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == menuTableView {
            return 0
        } else {
            return LeftViewController.headerHeight
        }
    }
    
    
}
