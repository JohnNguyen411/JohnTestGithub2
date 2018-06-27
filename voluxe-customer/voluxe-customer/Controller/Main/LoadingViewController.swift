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
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = .black
        return activityIndicator
    }()
    
    init() {
        super.init(screenNameEnum: .loading)
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
        weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.startApp()
    }
    
    
    //MARK: API CALLS
    private func callCustomer(customerId: Int) {
        
        // Get Customer object with ID
        CustomerAPI().getMe().onSuccess { result in
            if let customer = result?.data?.result {
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(customer, update: true)
                    }
                }
                UserManager.sharedInstance.setCustomer(customer: customer)
                if !customer.phoneNumberVerified {
                    FTUEStartViewController.flowType = .login
                    self.appDelegate?.phoneVerificationScreen()
                } else {
                    self.callVehicles(customerId: customer.id)
                    self.refreshRepairOrderTypes()
                }
                
            }
            }.onFailure { error in

                if let apiError = error.apiError {
                    if apiError.getCode() == .E3004 {
                        // code not verified
                        UserManager.sharedInstance.tempCustomerId = customerId
                        FTUEStartViewController.flowType = .login
                        self.appDelegate?.phoneVerificationScreen()
                        return
                    } else if apiError.getCode() == .E5001 || apiError.getCode() == .E5002 {
                        // 500 unknown
                        self.showOkDialog(title: .Error, message: .GenericError, completion: {
                            self.callCustomer(customerId: customerId)
                        }, dialogNameEnum: .error, screenNameEnum: self.screenNameEnum)
                        return
                    }
                }
                
                if error.statusCode == 404 || error.statusCode == 403 {
                    self.logout()
                    return
                }
                self.errorRetrievingCustomer(customerId: customerId, error: nil)
        }
    }
    
    private func errorRetrievingCustomer(customerId: Int, error: ResponseError?) {
        
        if let error = error {
            if error.getCode() == .E3004 {
                // code not verified
                UserManager.sharedInstance.tempCustomerId = customerId
                FTUEStartViewController.flowType = .login
                self.appDelegate?.phoneVerificationScreen()
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
                        self.appDelegate?.phoneVerificationScreen()
                    } else {
                        self.callVehicles(customerId: customer.id)
                    }
                    return
                }
            }
            
            
            self.showOkDialog(title: .Error, message: .GenericError, completion: {
                self.callCustomer(customerId: customerId)
            }, dialogNameEnum: .error, screenNameEnum: self.screenNameEnum)
        }
    }
    
    private func callVehicles(customerId: Int) {
        // Get Customer's Vehicles based on ID
        
        CustomerAPI().getVehicles(customerId: customerId).onSuccess { result in
            if let cars = result?.data?.result {
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(cars, update: true)
                    }
                }
                if cars.count == 0 {
                    FTUEStartViewController.flowType = .login
                    self.appDelegate?.showAddVehicleScreen()
                } else {
                    UserManager.sharedInstance.setVehicles(vehicles: cars)
                    self.getBookings(customerId: customerId)
                }
            }            
            }.onFailure { error in
                self.errorRetrievingVehicle(customerId: customerId)
        }
    }
    
    private func errorRetrievingVehicle(customerId: Int) {
        if let realm = self.realm {
            let vehicles = realm.objects(Vehicle.self).filter("ownerId = \(customerId)")
            if vehicles.count > 0 {
                UserManager.sharedInstance.setVehicles(vehicles: Array(vehicles))
                self.getBookings(customerId: customerId)
                return
            }
        }
        self.showOkDialog(title: .Error, message: .GenericError, completion: {
            self.callVehicles(customerId: customerId)
        }, dialogNameEnum: .error, screenNameEnum: self.screenNameEnum)
    }
    
    private func getBookings(customerId: Int) {
        // Get Customer's active Bookings based on ID
        BookingAPI().getBookings(customerId: customerId, active: true).onSuccess { result in
            if let bookings = result?.data?.result, bookings.count > 0 {
                
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
            
            }.onFailure { error in
                UserManager.sharedInstance.setBookings(bookings: nil)
                self.loadVehiclesViewController(customerId: customerId)
        }
    }
    
    private func refreshRepairOrderTypes() {
        RepairOrderAPI().getRepairOrderTypes().onSuccess { services in
            if let services = services?.data?.result {
                if let realm = try? Realm() {
                    try? realm.write {
                        realm.add(services, update: true)
                    }
                }
            }
            }.onFailure { error in
                Logger.print(error)
        }
    }
    
    private func loadVehiclesViewController(customerId: Int) {
        // check BookingFeedbacks if no active reservation is here
        if UserManager.sharedInstance.getActiveBookings().count == 0 {
            BookingAPI().getBookingFeedbacks(customerId: customerId, state: "pending").onSuccess { results in
                if let data = results?.data, let feedbacks = data.result, feedbacks.count > 0 {
                    // just get the last one
                    let bookingFeedback = feedbacks[feedbacks.count-1]
                    self.appDelegate?.loadBookingFeedback(bookingFeedback: bookingFeedback)
                } else {
                    self.appDelegate?.showVehiclesView(animated: true)
                    self.appDelegate?.registerForPushNotificationsIfGranted()
                }
                }.onFailure { error in
                    self.appDelegate?.showVehiclesView(animated: true)
                    self.appDelegate?.registerForPushNotificationsIfGranted()
            }
        } else {
            self.appDelegate?.showVehiclesView(animated: true)
            self.appDelegate?.registerForPushNotificationsIfGranted()
        }
    }
}
