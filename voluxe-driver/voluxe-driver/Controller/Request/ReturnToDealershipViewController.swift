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
    
    private let addressLabel = Label.taskText()
    private let customerLabel = Label.taskText()
    private let serviceLabel = Label.taskText()
    
    private var hasShownDialog = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews([self.addressLabel, self.customerLabel, self.serviceLabel])
        let navigationView = self.addNavigationButton(below: self.serviceLabel)
        self.addContactButtons(below: navigationView)
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        if let dealershipId = request.booking?.dealershipId, let dealership = DriverManager.shared.dealership(for: dealershipId), let location = dealership.location {
            self.directionLong = location.longitude
            self.directionLat = location.latitude
            self.directionAddressString = location.address
            
            let addressString = NSMutableAttributedString()
            self.addressLabel.attributedText = addressString.append(.localized(.dealershipAddressColon), with: self.customerLabel.font).append("\(location.address ?? "")" , with: self.intermediateMediumFont())
        }
        
        self.titleLabel.text = self.step?.title ?? .localized(.returnToDealership)
        self.titleLabel.font = Font.Medium.medium
        
        let customerString = NSMutableAttributedString()
        self.customerLabel.attributedText = customerString.append(.localized(.customerColon), with: self.customerLabel.font).append("\(request.booking?.customer!.fullName() ?? "")" , with: self.intermediateMediumFont())
        
        if let repairOrders = request.booking?.repairOrderRequests, repairOrders.count > 0 {
            let serviceString = NSMutableAttributedString()
            self.serviceLabel.attributedText = serviceString.append(.localized(.serviceColon), with: self.serviceLabel.font).append("\(request.booking?.getRepairOrderName() ?? "")" , with: self.intermediateMediumFont())
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
            
            var dealershipName = String.localized(.dealership)
            if let dealershipId = request.booking?.dealershipId, let dealership = DriverManager.shared.dealership(for: dealershipId) {
                dealershipName = dealership.name ?? ""
            }
            
            
            AppController.shared.playAlertSound()
            AppController.shared.alert(title: String(format: .localized(.popupTooFarFromDealershipTitle), dealershipName),
                                       message: String(format: .localized(.popupTooFarFromDealershipMessage), dealershipName),
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
