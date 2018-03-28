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
    case activeBookings = 1
    case settings = 2
    case logout = 3
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu, indexPath: IndexPath)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    var tableView = UITableView(frame: .zero)
    var menus = [String.YourVolvos, String.Settings, String.Logout]
    var activeBookings: [Booking] = []
    var mainNavigationViewController: UIViewController!
    var imageHeaderView: UIImageView!
    
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
        
        self.setActiveBooking(bookings: UserManager.sharedInstance.getBookings())

        SwiftEventBus.onMainThread(self, name: "setActiveBooking") { result in
            // UI thread
            self.setActiveBooking(bookings: UserManager.sharedInstance.getBookings())
        }
        
        self.view.backgroundColor = .white
        
        self.imageHeaderView = UIImageView(frame: .zero)
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.register(LeftPanelTableViewCell.self, forCellReuseIdentifier: LeftPanelTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(imageHeaderView)
        self.view.addSubview(tableView)
        
        let tableH = CGFloat(menus.count) * LeftPanelTableViewCell.height()
        
        imageHeaderView.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(160)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(imageHeaderView.snp.bottom)
            make.height.equalTo(tableH)
        }
    }
    
    
    func changeViewController(_ menu: LeftMenu, indexPath: IndexPath) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainNavigationViewController, close: true)
        case .settings:
            weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.navigationController?.pushViewController(SettingsViewController(), animated: true)
            closeLeft()
        case .logout:
            UserManager.sharedInstance.logout()
            weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.startApp()
        case .activeBookings:
            let bookingIndex = indexPath.row - 1
            if activeBookings.count > bookingIndex {
                let booking = activeBookings[bookingIndex]
                if let vehicle = booking.vehicle, let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.loadViewForVehicle(vehicle: vehicle, state: Booking.getStateForBooking(booking: booking))
                }
            }
        }
    }
    
    func changeMainViewController(uiNavigationController: UINavigationController) {
        self.slideMenuController()?.changeMainViewController(uiNavigationController, close: true)
    }
    
    func setActiveBooking(bookings: [Booking]) {
        activeBookings = bookings
        if activeBookings.count == 0 {
            menus = [String.YourVolvos, String.Settings, String.Logout]
        } else {
            menus.removeAll()
            menus.append(String.YourVolvos)
            for booking in activeBookings {
                if let vehicle = booking.vehicle {
                    menus.append(vehicle.vehicleDescription())
                }
            }
        }
        menus.append(String.Settings)
        menus.append(String.Logout)
        tableView.reloadData()
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LeftPanelTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu, indexPath: indexPath)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LeftPanelTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: LeftPanelTableViewCell.identifier)
        cell.setData(menus[indexPath.row])
        return cell
        
    }
    
    
}
