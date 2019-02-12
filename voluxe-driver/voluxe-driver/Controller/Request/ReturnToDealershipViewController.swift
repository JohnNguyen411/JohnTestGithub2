//
//  ReturnToDealershipViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/1/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ReturnToDealershipViewController: DriveViewController {
    
    private let customerLabel = Label.taskText()
    private let serviceLabel = Label.taskText()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews([self.customerLabel, self.serviceLabel])
        let navigationView = self.addNavigationButton(below: self.serviceLabel)
        self.addContactButtons(below: navigationView)
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        if let dealershipId = request.booking?.dealershipId, let dealerhip = DriverManager.shared.dealership(for: dealershipId) {
            self.directionLong = dealerhip.location.longitude
            self.directionLat = dealerhip.location.latitude
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
    
}
