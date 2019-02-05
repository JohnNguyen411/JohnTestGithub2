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
    private let customerLabel = Label.taskTitle()
    private let addressLabel = Label.taskText()
    private let pickupLabel = Label.taskText()
    private let loanerLabel = Label.taskText()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())
        
        gridView.add(subview: self.customerLabel, from: 1, to: 6)
        self.customerLabel.pinToSuperviewTop(spacing: 40)
        
        gridView.add(subview: self.addressLabel, from: 1, to: 6)
        self.addressLabel.pinTopToBottomOf(view: self.customerLabel, spacing: 10)
        
        gridView.add(subview: self.pickupLabel, from: 1, to: 6)
        self.pickupLabel.pinTopToBottomOf(view: self.addressLabel, spacing: 10)
        
        gridView.add(subview: self.loanerLabel, from: 1, to: 6)
        self.loanerLabel.pinTopToBottomOf(view: self.pickupLabel, spacing: 10)
        
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        let customerString = NSMutableAttributedString()
        self.customerLabel.attributedText = customerString.append(.localized(.customerColon),
                                                                  with: self.customerLabel.font).append("\(request.booking?.customer.fullName() ?? "")",
                                                                    with: Font.Medium.medium)
        
        let addressString = NSMutableAttributedString()
        self.addressLabel.attributedText = addressString.append(.localized(.addressColon),
                                                                with: self.addressLabel.font).append("\(request.location?.address ?? "")",
                                                                    with: Font.Small.medium)
        
        if let vehicle = request.booking?.vehicle {
            let pickupString = NSMutableAttributedString()
            self.pickupLabel.attributedText = pickupString.append(request.isPickup ? .localized(.pickupColon) : .localized(.deliveryColon),
                                                                  with: self.pickupLabel.font).append("\(vehicle.vehicleDescription())" ,
                                                                    with: Font.Small.medium)
        }
        
        if let loaner = request.booking?.loanerVehicle {
            let laonerString = NSMutableAttributedString()
            self.loanerLabel.attributedText = laonerString.append(.localized(.loanerColon),
                                                                  with: self.loanerLabel.font).append("\(loaner.vehicleDescription())" ,
                                                                    with: Font.Small.medium)
        }
    }
    
}
