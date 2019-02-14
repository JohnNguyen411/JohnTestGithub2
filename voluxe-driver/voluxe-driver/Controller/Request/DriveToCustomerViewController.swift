//
//  DriveToCustomerViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/24/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DriveToCustomerViewController: DriveViewController {
    
    private let addressLabel = Label.taskText()
    private let serviceLabel = Label.taskText()
    private let notesLabel = Label.taskText()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews([self.addressLabel, self.serviceLabel, self.notesLabel])
        let navigationView = self.addNavigationButton(below: self.notesLabel)
        self.addContactButtons(below: navigationView)
        
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        self.directionLong = request.location?.longitude
        self.directionLat = request.location?.latitude

        let customerString = NSMutableAttributedString()
        self.titleLabel.attributedText = customerString.append(.localized(.customerColon), with: self.titleLabel.font).append("\(request.booking?.customer.fullName() ?? "")" , with: Font.Medium.medium)
        
        let addressString = NSMutableAttributedString()
        self.addressLabel.attributedText = addressString.append(.localized(.addressColon), with: self.addressLabel.font).append("\(request.location?.address ?? "")" , with: self.intermediateMediumFont())
        
        if let repairOrders = request.booking?.repairOrderRequests, repairOrders.count > 0 {
            let addressString = NSMutableAttributedString()
            self.serviceLabel.attributedText = addressString.append(.localized(.serviceColon), with: self.serviceLabel.font).append("\(request.booking?.repairOrderNames() ?? "")" , with: self.intermediateMediumFont())
        }
        
        if let requestNotes = request.notes {
            let notesString = NSMutableAttributedString()
            self.notesLabel.attributedText = notesString.append(.localized(.notesColon), with: self.notesLabel.font).append("\(requestNotes)" , with: self.intermediateMediumFont())
        }
    }
    
    override func swipeNext(completion: ((Bool) -> ())?) {
        // check distance from destination
        
        guard let lat = self.directionLat, let long = self.directionLong, let driverLocation = DriverManager.shared.location else {
            super.swipeNext(completion: completion)
            return
        }
        
        let destinationLocation = CLLocation(latitude: lat, longitude: long)
        
        if distanceBetween(driverLocation: driverLocation, destinationLocation: destinationLocation) > 500 {
            AppController.shared.playAlertSound()
            AppController.shared.alert(title: .localized(.popupTooFarFromCustomerTitle),
                                       message: .localized(.popupTooFarFromCustomerMessage),
                                       cancelButtonTitle: .localized(.no),
                                       okButtonTitle: .localized(.popupTooFarFromCustomerPositive),
                                       okCompletion: {
                                        // force complete
                                        super.swipeNext(completion: completion)
            })
        } else {
            super.swipeNext(completion: completion)
        }
    }
}
