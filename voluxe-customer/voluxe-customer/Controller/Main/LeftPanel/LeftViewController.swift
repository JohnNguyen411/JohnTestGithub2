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
    
    let activeBookingsLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = .volvoSansLightBold(size: 16)
        titleLabel.textAlignment = .left
        titleLabel.text = .ActiveBookings
        return titleLabel
    }()
    
    let activeBookingsContainer = UIView(frame: .zero)
    
    var tableView = UITableView(frame: .zero)
    var menus = [String.YourVolvos, String.Settings, String.Logout]
    var activeBookings: [Booking] = []
    var mainNavigationViewController: UIViewController!
    
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
        
        self.view.backgroundColor = .white
        
        self.tableView.isScrollEnabled = false
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.register(LeftPanelTableViewCell.self, forCellReuseIdentifier: LeftPanelTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupViews()
        
        self.setActiveBooking(bookings: UserManager.sharedInstance.getBookings())
        
        SwiftEventBus.onMainThread(self, name: "setActiveBooking") { result in
            // UI thread
            self.setActiveBooking(bookings: UserManager.sharedInstance.getBookings())
        }
    }
    
    func setupViews() {
        self.view.addSubview(tableView)
        self.view.addSubview(activeBookingsLabel)
        self.view.addSubview(activeBookingsContainer)
        
        activeBookingsLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(20)
        }
        
        let bookingsH = CGFloat(activeBookings.count) * LeftPanelTableViewCell.height()
        
        activeBookingsContainer.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(activeBookingsLabel.snp.bottom)
            make.height.equalTo(bookingsH)
        }
        
        let tableH = CGFloat(menus.count) * LeftPanelTableViewCell.height()
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.height.equalTo(tableH)
        }
    }
    
    
    func changeViewController(_ menu: LeftMenu, indexPath: IndexPath) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainNavigationViewController, close: true)
        case .settings:
            weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.settingsScreen()
        case .logout:
            UserManager.sharedInstance.logout()
            weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.startApp()
        }
    }
    
    func changeMainViewController(uiNavigationController: UINavigationController) {
        self.slideMenuController()?.changeMainViewController(uiNavigationController, close: true)
    }
    
    private func setActiveBooking(bookings: [Booking]) {
        activeBookings = bookings
        for view in activeBookingsContainer.subviews {
            view.removeFromSuperview()
        }
        if activeBookings.count == 0 {
            activeBookingsContainer.isHidden = true
            activeBookingsLabel.isHidden = true
        } else {
            activeBookingsLabel.isHidden = false
            activeBookingsContainer.isHidden = false
            var previousLabel: UIView? = nil
            for booking in activeBookings {
                let bookingLabel = generateBookingLabel(booking)
                activeBookingsContainer.addSubview(bookingLabel)
                bookingLabel.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(15)
                    make.right.equalToSuperview().offset(-15)
                    make.top.equalTo(previousLabel == nil ? activeBookingsContainer.snp.top : previousLabel!.snp.bottom)
                    make.height.equalTo(LeftPanelTableViewCell.height())
                }
                previousLabel = bookingLabel
                
            }
            let bookingsH = CGFloat(activeBookings.count) * LeftPanelTableViewCell.height()
            
            activeBookingsContainer.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(bookingsH)
            }
        }
    }
    
    private func generateBookingLabel(_ booking: Booking) -> UILabel {
        
        let tapGesture = BookingTapGesture(target: self, action: #selector(bookingTapped(sender:)))
        tapGesture.booking = booking
        
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textColor = .black
        label.font = .volvoSansLight(size: 16)
        label.textAlignment = .left
        if let vehicle = booking.vehicle {
            label.text = vehicle.vehicleDescription()
        }
        
        label.addGestureRecognizer(tapGesture)
        return label
        
    }
    
    @objc func bookingTapped(sender : BookingTapGesture) {
        if let booking = sender.booking, let vehicle = booking.vehicle, let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.loadViewForVehicle(vehicle: vehicle, state: Booking.getStateForBooking(booking: booking))
        }
    }
}

class BookingTapGesture: UITapGestureRecognizer {
    var booking: Booking?
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
