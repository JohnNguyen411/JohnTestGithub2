//
//  LoadingViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class LoadingViewController: LogoViewController {
    
    var realm : Realm?
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = .black
        return activityIndicator
    }()
    
    init() {
        super.init(screen: .loading)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        
        //DO NOT UNCOMMENT, DEBUG MODE ONLY
        //logout()
        
        // check realm integrity
        guard let _ = self.realm else {
            // logout will take the user back to the LandingPage where the db error will be displayed
            logout()
            return
        }
        
        if let customerId = UserManager.sharedInstance.customerId() {
            callCustomer(customerId: customerId)
            return
        }
        //logout
        logout()
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        activityIndicator.startAnimating()
        
    }
    
    private func logout() {
        UserManager.sharedInstance.logout()
        AppController.sharedInstance.startApp()
    }
    
    
    //MARK: API CALLS
    private func callCustomer(customerId: Int) {
        
        // Get Customer object with ID
        CustomerAPI.me { customer, error in
            if let customer = customer {
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(customer, update: true)
                    }
                }
                UserManager.sharedInstance.setCustomer(customer: customer)
                if !customer.phoneNumberVerified {
                    FTUEStartViewController.flowType = .login
                    AppController.sharedInstance.phoneVerificationScreen()
                } else {
                    self.callVehicles(customerId: customer.id)
                    self.refreshRepairOrderTypes()
                }
                
            } else {
                
                guard let error = error else {
                    self.errorRetrievingCustomer(customerId: customerId, error: nil)
                    return
                }
                
                if error.statusCode == 404 || error.statusCode == 403 {
                    self.logout()
                    return
                }
                
                if let code = error.code {
                    if code == .E3004 {
                        // code not verified
                        UserManager.sharedInstance.tempCustomerId = customerId
                        FTUEStartViewController.flowType = .login
                        AppController.sharedInstance.phoneVerificationScreen()
                        return
                    } else if code == .E5001 || code == .E5002 {
                        // 500 unknown
                        self.showOkDialog(title: .Error, message: .GenericError, completion: {
                            self.callCustomer(customerId: customerId)
                        }, dialog: .error, screen: self.screen)
                        return
                    } else {
                        self.errorRetrievingCustomer(customerId: customerId, error: error)
                    }
                }
            }
        }
    }
    
    private func errorRetrievingCustomer(customerId: Int, error: LuxeAPIError?) {
        
        if let error = error {
            if error.code == .E3004 {
                // code not verified
                UserManager.sharedInstance.tempCustomerId = customerId
                FTUEStartViewController.flowType = .login
                AppController.sharedInstance.phoneVerificationScreen()
                return
            } else {
                //todo show error && logout?
                logout()
                return
            }
        } else {
            if let realm = self.realm {
                if let customer = realm.objects(Customer.self).filter("id = \(customerId)").first {
                    UserManager.sharedInstance.setCustomer(customer: customer)
                    if !customer.phoneNumberVerified {
                        FTUEStartViewController.flowType = .login
                        AppController.sharedInstance.phoneVerificationScreen()
                    } else {
                        self.callVehicles(customerId: customer.id)
                    }
                    return
                }
            }
            
            
            self.showOkDialog(title: .Error, message: .GenericError, completion: {
                self.callCustomer(customerId: customerId)
            }, dialog: .error, screen: self.screen)
        }
    }
    
    private func callVehicles(customerId: Int) {
        // Get Customer's Vehicles based on ID
        
        CustomerAPI.vehicles(customerId: customerId) { vehicles, error in
            
            if error != nil {
                self.errorRetrievingVehicle(customerId: customerId)
            } else {
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(vehicles, update: true)
                    }
                }
                if vehicles.count == 0 {
                    FTUEStartViewController.flowType = .login
                    AppController.sharedInstance.showAddVehicleScreen()
                } else {
                    UserManager.sharedInstance.setVehicles(vehicles: vehicles)
                    self.getBookings(customerId: customerId)
                }
            }
        }
    }
    
    private func errorRetrievingVehicle(customerId: Int) {
        if let realm = self.realm {
            let vehicles = realm.objects(Vehicle.self)
            if vehicles.count > 0 {
                UserManager.sharedInstance.setVehicles(vehicles: Array(vehicles))
                self.getBookings(customerId: customerId)
                return
            }
        }
        self.showOkDialog(title: .Error, message: .GenericError, completion: {
            self.callVehicles(customerId: customerId)
        }, dialog: .error, screen: self.screen)
    }
    
    private func getBookings(customerId: Int) {
        // Get Customer's active Bookings based on ID
        CustomerAPI.bookings(customerId: customerId, active: true) { bookings, error in
            if bookings.count > 0 {
                
                for booking in bookings {
                    if booking.customerId == -1 {
                        booking.customerId = customerId
                    }
                }
                
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(bookings, update: true)
                    }
                }
                // set the bookings
                UserManager.sharedInstance.setBookings(bookings: bookings)
                self.loadVehiclesViewController(customerId: customerId)
                
            } else {
                UserManager.sharedInstance.setBookings(bookings: nil)
                self.loadVehiclesViewController(customerId: customerId)
            }
        }
    }
    
    private func refreshRepairOrderTypes() {
        CustomerAPI.repairOrderTypes() { services, error in
            
            if error != nil {
                Logger.print("\(error?.message ?? "")")
            } else {
                if let realm = try? Realm() {
                    try? realm.write {
                        realm.delete(realm.objects(RepairOrderType.self))
                        realm.add(services, update: true)
                    }
                }
            }
        }
    }
    
    private func loadVehiclesViewController(customerId: Int) {
        // check BookingFeedbacks if no active reservation is here
        if UserManager.sharedInstance.getActiveBookings().count == 0 {
            CustomerAPI.bookingFeedbacks(customerId: customerId, state: "pending") { bookingFeedbacks, error in
                if bookingFeedbacks.count > 0 {
                    // just get the last one
                    let bookingFeedback = bookingFeedbacks[bookingFeedbacks.count-1]
                    AppController.sharedInstance.loadBookingFeedback(bookingFeedback: bookingFeedback)
                } else {
                    AppController.sharedInstance.showVehiclesView(animated: true)
                    self.appDelegate?.registerForPushNotificationsIfGranted()
                }
            }
        } else {
            AppController.sharedInstance.showVehiclesView(animated: true)
            self.appDelegate?.registerForPushNotificationsIfGranted()
        }
    }
}
