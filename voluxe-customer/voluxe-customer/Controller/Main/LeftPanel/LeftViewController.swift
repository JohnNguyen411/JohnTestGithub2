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
    case settings = 0
    case help = 1
    case logout = 2
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu, indexPath: IndexPath)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    private static let headerHeight: CGFloat = 40
    private static let maxActiveVehicleHeight = 3
    private static let maxTableViewVehicleHeight: CGFloat = CGFloat(LeftViewController.maxActiveVehicleHeight) * LeftPanelVehicleCell.height + LeftViewController.headerHeight

    private let vehicleTableView = UITableView(frame: .zero)
    private let menuTableView = UITableView(frame: .zero)
    private let menus = [String.localized(.settings), String.localized(.help), String.localized(.signout)]
    
    private let closeButton = UIButton(type: UIButton.ButtonType.custom)

    private var activeBookings: [Booking] = []
    private var vehicles: [Vehicle] = []

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
        
        self.vehicleTableView.isScrollEnabled = true
        self.vehicleTableView.separatorColor = UIColor.luxeLightGray()
        self.vehicleTableView.register(LeftPanelVehicleCell.self, forCellReuseIdentifier: LeftPanelVehicleCell.identifier)
        self.vehicleTableView.delegate = self
        self.vehicleTableView.dataSource = self
        
        setupViews()
        
        self.updateVehicles(vehicles: UserManager.sharedInstance.getVehicles())
        self.setActiveBooking(bookings: UserManager.sharedInstance.getActiveBookings())
        
        SwiftEventBus.onMainThread(self, name: "setUserVehicles") { result in
            // UI thread
            self.updateVehicles(vehicles: UserManager.sharedInstance.getVehicles())
        }
        
        SwiftEventBus.onMainThread(self, name: "setActiveBooking") { result in
            // UI thread
            self.setActiveBooking(bookings: UserManager.sharedInstance.getActiveBookings())
        }
        
        
        SwiftEventBus.onMainThread(self, name:"stateDidChange") {
            result in
            guard let stateChange: StateChangeObject = result?.object as? StateChangeObject else { return }
            self.stateDidChange(vehicleId: stateChange.vehicleId)
        }
        
    }
    
    func setupViews() {
        self.view.addSubview(closeButton)
        self.view.addSubview(menuTableView)
        self.view.addSubview(vehicleTableView)
        
        var vehiclesH = CGFloat(vehicles.count) * LeftPanelVehicleCell.height + LeftViewController.headerHeight
        if vehicles.count > 0 {
            if vehiclesH > LeftViewController.maxTableViewVehicleHeight {
                vehiclesH = LeftViewController.maxTableViewVehicleHeight
            }
        } else {
            vehiclesH = 0
        }
        vehicleTableView.snp.makeConstraints { (make) -> Void in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.equalsToTop(view: self.view, offset: 80)
            make.height.equalTo(vehiclesH)
        }
        
        let tableH = CGFloat(menus.count) * LeftPanelTableViewCell.height()
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .luxeLightGray()
        self.view.addSubview(separator)
        
        menuTableView.snp.makeConstraints { (make) -> Void in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(vehicleTableView.snp.bottom).offset(100)
            make.height.equalTo(tableH)
        }
        
        separator.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().offset(25)
            make.bottom.equalTo(menuTableView.snp.top)
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        closeButton.snp.makeConstraints { make in
            make.equalsToTop(view: self.view, offset: !self.view.hasSafeAreaCapability ? 15 : 0)
            make.leading.equalToSuperview().offset(3)
            make.width.height.equalTo(50)
        }
    }
    
    
    func changeViewController(_ menu: LeftMenu, indexPath: IndexPath) {
        switch menu {
        case .settings:
            Analytics.trackClick(button: .leftPanelSettings)
            AppController.sharedInstance.settingsScreen()
        case .help:
            Analytics.trackClick(button: .leftPanelSettings) //todo update that too
            AppController.sharedInstance.helpScreen()
        case .logout:
            Analytics.trackClick(button: .leftPanelLogout)
            self.signoutDialog()
        }
    }
    
    func changeMainViewController(uiNavigationController: UINavigationController, title: String?, animated: Bool) {
        if let slideMenuController = AppController.sharedInstance.slideMenuController {
            slideMenuController.changeMainViewController(uiNavigationController, close: true, animated: animated)
        } else {
            self.slideMenuController()?.changeMainViewController(uiNavigationController, close: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.updateNotificationBadge()
        })
        
        uiNavigationController.setTitle(title: title)
    }
    
    private func setActiveBooking(bookings: [Booking]) {
        activeBookings = bookings
        vehicleTableView.reloadData()
    }
    
    private func updateVehicles(vehicles: [Vehicle]?) {
        if let updatedVehicles = vehicles {
            self.vehicles = updatedVehicles
        } else {
            self.vehicles.removeAll()
        }
        if self.vehicles.count < 1 {
            vehicleTableView.isHidden = true
            vehicleTableView.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(0)
            }
            
            menuTableView.snp.updateConstraints { (make) -> Void in
                make.top.equalTo(vehicleTableView.snp.bottom).offset(100)
            }
        } else {
            if self.vehicles.count > LeftViewController.maxActiveVehicleHeight {
                self.vehicleTableView.isScrollEnabled = true
            } else {
                self.vehicleTableView.isScrollEnabled = false
            }
            vehicleTableView.isHidden = false
            var vehiclesH = CGFloat(self.vehicles.count) * LeftPanelVehicleCell.height + LeftViewController.headerHeight
            if vehiclesH > LeftViewController.maxTableViewVehicleHeight {
                vehiclesH = LeftViewController.maxTableViewVehicleHeight
            }
            vehicleTableView.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(vehiclesH)
            }
            
            menuTableView.snp.updateConstraints { (make) -> Void in
                make.top.equalTo(vehicleTableView.snp.bottom).offset(100)
            }
        }
        vehicleTableView.reloadData()
    }
    
    
    // show red dot update if needed
    func stateDidChange(vehicleId: Int) {
        // show red dot if vehicleId is in active reservation and if vehicle not already current screen
        var isVehicleActive = false
        for booking in activeBookings {
            if !booking.isInvalidated && booking.vehicleId == vehicleId {
                isVehicleActive = true
                break
            }
        }
        if isVehicleActive {
            let showNotif = !isShowingScreenForVehicle(vehicleId: vehicleId)
            showRedDot(vehicleId: vehicleId, show: showNotif)
        }
    }
    
    private func isShowingScreenForVehicle(vehicleId: Int) -> Bool {
        var showingScreen = false
        if let viewController = AppController.sharedInstance.slideMenuController?.mainViewController {
            if let baseController = viewController as? BaseViewController {
                if baseController is VehiclesViewController || baseController is MainViewController || baseController is SettingsViewController {
                    if let mainVc = baseController as? MainViewController, mainVc.vehicleId == vehicleId {
                        // screen showing car info, don't show notif
                        showingScreen = true
                    } else {
                        showingScreen = false
                    }
                }
            } else if let navController = viewController as? UINavigationController, navController.children.count > 0 {
                for controller in navController.children {
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
        vehicleTableView.reloadData()
        updateNotificationBadge()
    }
    
    
    private func updateNotificationBadge() {
        var isShowingNotif = false
        
        for dictValue in notificationDict {
            
            if !isShowingNotif && dictValue.value {
                isShowingNotif = true
            }
        }
        if let viewController = AppController.sharedInstance.slideMenuController?.mainViewController {
            if let baseController = viewController as? BaseViewController {
                if baseController is VehiclesViewController || baseController is MainViewController || baseController is SettingsViewController {
                    baseController.setNavigationBarItem()
                    baseController.showNotifBadge(isShowingNotif)
                }
            } else if let navController = viewController as? UINavigationController, navController.children.count > 0 {
                for controller in navController.children {
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
    
    @objc func onCloseClicked() {
        AppController.sharedInstance.slideMenuController?.toggleLeft()
    }
    
    func signoutDialog() {
        self.showDestructiveDialog(title: .localized(.signout), message: .localized(.popupSignoutConfirmationMessage), cancelButtonTitle: .localized(.cancel), destructiveButtonTitle: .localized(.signout), destructiveCompletion: {
            UserManager.sharedInstance.logout()
            AppController.sharedInstance.startApp()
        })
    }
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
            let vehicle = vehicles[indexPath.row]

            let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle)
            if let booking = booking, booking.isActive() {
                AppController.sharedInstance.loadViewForVehicle(vehicle: vehicle, state: Booking.getStateForBooking(booking: booking))
                showRedDot(vehicleId: vehicle.id, show: false)
                Analytics.trackClick(button: .leftPanelBookings)
            } else {
                VehiclesViewController.selectedVehicleIndex = indexPath.row
                self.changeMainViewController(uiNavigationController: self.mainNavigationViewController, title: nil, animated: true)
                self.updateNotificationBadge()
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == vehicleTableView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: LeftViewController.headerHeight))
            view.backgroundColor = UIColor.white
            
            let separator = UIView(frame: CGRect(x: 15, y: LeftViewController.headerHeight - 1, width: tableView.bounds.width, height: 0.5))
            separator.backgroundColor = .luxeLightGray()
            view.addSubview(separator)
            
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width, height: LeftViewController.headerHeight))
            label.font = UIFont.volvoSansProMedium(size: 13)
            label.textColor = UIColor.luxeGray()
            label.text = UserManager.sharedInstance.yourVolvoStringTitle().uppercased()
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
            return vehicles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == menuTableView {
            let cell = LeftPanelTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: LeftPanelTableViewCell.identifier)
            if indexPath.row == menus.count - 1 {
                cell.setData(menus[indexPath.row], isButton: true)
            } else {
                cell.setData(menus[indexPath.row], isButton: false)
            }
            
            return cell
        } else {
            let cell = LeftPanelVehicleCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: LeftPanelVehicleCell.identifier)
            let vehicle = vehicles[indexPath.row]
            cell.setText(text: vehicle.vehicleDescription())
            if let showNotif = notificationDict[vehicle.id], showNotif {
                cell.showNotification(notificationType: .active)
            } else {
                if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle), booking.getState() != .canceled {
                    cell.showNotification(notificationType: .inactive)
                } else {
                    cell.showNotification(notificationType: nil)
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
