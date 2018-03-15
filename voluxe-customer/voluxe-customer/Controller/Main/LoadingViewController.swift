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

class LoadingViewController: ChildViewController {
    
    let loadingView = UIActivityIndicatorView(frame: .zero)
    var realm : Realm?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        
        //DO NOT UNCOMMENT, DEBUG MODE ONLY
        //logout()
        
        // call user/vehicle/service
        if let customerId = UserManager.sharedInstance.getCustomerId() {
            callCustomer(customerId: customerId)
            return
        }
        //logout
        logout()
    }
    
    override func setupViews() {
        super.setupViews()
        
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingView.color = .luxeDarkBlue()
        
        self.view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        loadingView.startAnimating()
    }
    
    private func logout() {
        UserManager.sharedInstance.logout()
        weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.startApp()
    }
    
    
    //MARK: API CALLS
    private func callCustomer(customerId: Int) {
        
        if Config.sharedInstance.isMock {
            if let realm = self.realm {
                if let customer = realm.objects(Customer.self).filter("id = \(customerId)").first {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        
                        UserManager.sharedInstance.setCustomer(customer: customer)
                        var cars = realm.objects(Vehicle.self)
                        if cars.count == 1 {
                            // create one more
                            let vehicle = Vehicle()
                            vehicle.id = 654654
                            vehicle.baseColor = "White"
                            vehicle.model = "XC40"
                            vehicle.year = 2018
                            try? realm.write {
                                realm.add(vehicle)
                            }
                            cars = realm.objects(Vehicle.self)
                        }
                        UserManager.sharedInstance.setVehicles(vehicles: Array(cars))
                        
                        let bookings = realm.objects(Booking.self).filter("customerId = %@ AND (state = %@ OR state = %@)", customerId, "created", "started")
                        UserManager.sharedInstance.setBookings(bookings: Array(bookings))
                        if StateServiceManager.sharedInstance.getState() == .loading {
                            StateServiceManager.sharedInstance.updateState(state: .idle)
                        }
                        
                    })
                }
            }
            
            return
        }
        
        // Get Customer object with ID
        CustomerAPI().getCustomer(id: customerId).onSuccess { result in
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
                    self.callVehicle(customerId: customer.id)
                }
                
            } else {
                // error
                if let error = result?.error {
                    if error.code == "E3004" {
                        // code not verified
                        UserManager.sharedInstance.tempCustomerId = customerId
                        FTUEStartViewController.flowType = .login
                        self.appDelegate?.phoneVerificationScreen()
                    } else {
                        //todo show error
                    }
                }
            }
            }.onFailure { error in
                // todo show error
                if error.responseCode == 404 || error.responseCode == 403 {
                    self.logout()
                    return
                }
                self.errorRetrievingCustomer(customerId: customerId, error: nil)
        }
    }
    
    private func errorRetrievingCustomer(customerId: Int, error: ResponseError?) {
        
        if let error = error {
            if error.code == "E3004" {
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
                        self.callVehicle(customerId: customer.id)
                    }
                    return
                }
            }
            
            
            self.showOkDialog(title: .Error, message: .GenericError, completion: {
                self.callCustomer(customerId: customerId)
            })
        }
    }
    
    private func callVehicle(customerId: Int) {
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
            } else {
                self.errorRetrievingVehicle(customerId: customerId)
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
            self.callVehicle(customerId: customerId)
        })
    }
    
    private func getBookings(customerId: Int) {
        // Get Customer's Bookings based on ID
        BookingAPI().getBookings(customerId: customerId).onSuccess { result in
            if let bookings = result?.data?.result, bookings.count > 0 {
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(bookings, update: true)
                    }
                }
                // set the bookings
                UserManager.sharedInstance.setBookings(bookings: bookings)
                
            } else {
                // error
                StateServiceManager.sharedInstance.updateState(state: .needService)
            }
            
            }.onFailure { error in
                // todo show error
                StateServiceManager.sharedInstance.updateState(state: .needService)
        }
    }
}
