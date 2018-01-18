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

        // call user/vehicle/service
        if let realm = self.realm {
            if let customer = realm.objects(Customer.self).first {
                callCustomer(customerId: customer.id)
                return
            }
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
        
        // Get Customer object with ID
        CustomerAPI().getCustomer(id: customerId).onSuccess { result in
            if let customer = result?.data?.result {
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(customer, update: true)
                    }
                }
                UserManager.sharedInstance.setCustomer(customer: customer)
                self.callVehicle(customerId: customer.id)
                
            }
            }.onFailure { error in
                // todo show error
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
                UserManager.sharedInstance.setVehicles(vehicles: cars)
                self.getBookings(customerId: customerId)
            }
            
            }.onFailure { error in
                // todo show error
        }
    }
    
    private func getBookings(customerId: Int) {
        // Get Customer's Vehicles based on ID
        BookingAPI().getBookings(customerId: customerId).onSuccess { result in
            if let bookings = result?.data?.result, bookings.count > 0 {
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(bookings, update: true)
                    }
                }
                RequestedServiceManager.sharedInstance.setBooking(booking: bookings[0])
                StateServiceManager.sharedInstance.updateState(state: .needService)
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
