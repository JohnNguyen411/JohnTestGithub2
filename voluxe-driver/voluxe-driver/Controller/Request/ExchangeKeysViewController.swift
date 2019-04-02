//
//  ExchangeKeysViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/1/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ExchangeKeysViewController: RequestStepViewController {
    
    private let customerLabel = Label.taskText()
    private let serviceLabel = Label.taskText()
    private var reminderLabel = Label.highlightLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews([self.customerLabel, self.serviceLabel])
        self.addView(self.reminderLabel, below: self.serviceLabel, spacing: 30)
        
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        self.titleLabel.text = self.step?.title ?? .localized(.exchangeKeys)
        self.titleLabel.font = Font.Medium.medium
        
        let customerString = NSMutableAttributedString()
        self.customerLabel.attributedText = customerString.append(.localized(.customerColon), with: self.customerLabel.font).append("\(request.booking?.customer?.fullName() ?? "")" , with: self.intermediateMediumFont())
        
        if let repairOrders = request.booking?.repairOrderRequests, repairOrders.count > 0 {
            let addressString = NSMutableAttributedString()
            self.serviceLabel.attributedText = addressString.append(.localized(.serviceColon), with: self.serviceLabel.font).append("\(request.booking?.getRepairOrderName() ?? "")" , with: self.intermediateMediumFont())
        }
        
        DispatchQueue.main.async {
            self.reminderLabel.text = String(format: .localized(.viewReceiveVehicleInfoReminder), self.request?.booking?.customer?.fullName() ?? .localized(.unknown))
            self.reminderLabel.sizeToFit()
            self.reminderLabel.setNeedsDisplay()
        }
        
    }
    
    
    
    override func nextTask() -> Task? {
        guard let request = self.request else {
            return super.nextTask()
        }
        
        if request.isPickup && request.hasLoaner {
            return .driveVehicleToDealership
        } else if request.isDropOff && request.hasLoaner {
            return .driveLoanerVehicleToDealership
        }
        
        return super.nextTask()
    }
    
    
}
