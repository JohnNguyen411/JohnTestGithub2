//
//  ReviewServiceViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/22/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ReviewServiceViewController: RequestStepViewController {
    
    // MARK: Layout
    private let addressLabel = Label.taskText()
    private let pickupLabel = Label.taskText()
    private let loanerLabel = Label.taskText()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.addViews([self.addressLabel, self.pickupLabel, self.loanerLabel])
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        let customerString = NSMutableAttributedString()
        customerString.append(.localized(.customerColon),
                              with: self.titleLabel.font).append("\(request.booking?.customer?.fullName() ?? "")",
                                with: Font.Medium.medium)
        
        self.setTitle(attributedString: customerString)
        
        let addressString = NSMutableAttributedString()
        self.addressLabel.attributedText = addressString.append(String(format: .localized(.addressColon), request.typeString),
                                                                with: self.addressLabel.font).append("\(request.location?.address ?? "")",
                                                                    with: self.intermediateMediumFont())
        
        if let vehicle = request.booking?.vehicle {
            let pickupString = NSMutableAttributedString()
            self.pickupLabel.attributedText = pickupString.append(request.isPickup ? .localized(.pickupColon) : .localized(.deliveryColon),
                                                                  with: self.pickupLabel.font).append("\(vehicle.vehicleDescription())" ,
                                                                    with: self.intermediateMediumFont())
        }
        
        if let loaner = request.booking?.loanerVehicle {
            let laonerString = NSMutableAttributedString()
            self.loanerLabel.attributedText = laonerString.append(.localized(.loanerColon),
                                                                  with: self.loanerLabel.font).append("\(loaner.vehicleDescription())" ,
                                                                    with: self.intermediateMediumFont())
        }
    }
    
}
