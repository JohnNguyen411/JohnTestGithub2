//
//  ReturnToDealershipViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/1/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ReturnToDealershipViewController: DriveViewController {
    
    private let customerLabel = Label.taskText()
    private let serviceLabel = Label.taskText()
    
    private var hasShownDialog = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews([self.customerLabel, self.serviceLabel])
        let navigationView = self.addNavigationButton(below: self.serviceLabel)
        self.addContactButtons(below: navigationView)
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        if let dealershipId = request.booking?.dealershipId, let dealership = DriverManager.shared.dealership(for: dealershipId) {
            self.directionLong = dealership.location.longitude
            self.directionLat = dealership.location.latitude
            self.directionAddressString = dealership.location.address
        }
        
        self.titleLabel.text = self.step?.title ?? .localized(.returnToDealership)
        self.titleLabel.font = Font.Medium.medium
        
        let customerString = NSMutableAttributedString()
        self.customerLabel.attributedText = customerString.append(.localized(.customerColon), with: self.customerLabel.font).append("\(request.booking?.customer.fullName() ?? "")" , with: self.intermediateMediumFont())
        
        if let repairOrders = request.booking?.repairOrderRequests, repairOrders.count > 0 {
            let addressString = NSMutableAttributedString()
            self.serviceLabel.attributedText = addressString.append(.localized(.serviceColon), with: self.serviceLabel.font).append("\(request.booking?.repairOrderNames() ?? "")" , with: self.intermediateMediumFont())
        }
    }
    
    override func swipeNext(completion: ((Bool) -> ())?) {
        // check distance from destination
        
        guard let lat = self.directionLat, let long = self.directionLong, let driverLocation = DriverManager.shared.location else {
            super.swipeNext(completion: completion)
            return
        }
        
        let destinationLocation = CLLocation(latitude: lat, longitude: long)
        
        if !hasShownDialog && distanceBetween(driverLocation: driverLocation, destinationLocation: destinationLocation) > 500 {
            self.hasShownDialog = true
            
            guard let request = self.request, !AppController.shared.isBusy() else {
                return
            }
            
            AppController.shared.playAlertSound()
            AppController.shared.alert(title: .localized(.popupTooFarFromDealershipTitle),
                                       message: .localized(.popupTooFarFromDealershipMessage),
                                       cancelButtonTitle: .localized(.no),
                                       okButtonTitle: .localized(.popupTooFarFromDealershipPositive),
                                       okCompletion: {
                                        // force complete
                                        super.swipeNext(completion: completion)
            },
                                       dialog: request.isPickup ? .pickupTooFarFromDealership : .deliveryTooFarFromDealership,
                                       screen: self.screenName
            )
        } else {
            super.swipeNext(completion: completion)
        }
    }
    
}
