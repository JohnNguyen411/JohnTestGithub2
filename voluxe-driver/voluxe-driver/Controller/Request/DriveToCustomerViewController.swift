//
//  DriveToCustomerViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/24/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class DriveToCustomerViewController: RequestStepViewController {
    
    private let titleLabel = Label.taskTitle()
    private let addressLabel = Label.taskText()
    private let serviceLabel = Label.taskText()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())
        
        gridView.add(subview: self.titleLabel, from: 1, to: 6)
        self.titleLabel.pinToSuperviewTop(spacing: 40)
        
        gridView.add(subview: self.addressLabel, from: 1, to: 6)
        self.addressLabel.pinTopToBottomOf(view: self.titleLabel, spacing: 10)
        
        gridView.add(subview: self.serviceLabel, from: 1, to: 6)
        self.serviceLabel.pinTopToBottomOf(view: self.addressLabel, spacing: 10)
        
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        let customerString = NSMutableAttributedString()
        self.titleLabel.attributedText = customerString.append(.localized(.customerColon), with: self.titleLabel.font).append("\(request.booking?.customer.fullName() ?? "")" , with: Font.Medium.medium)
        
        let addressString = NSMutableAttributedString()
        self.addressLabel.attributedText = addressString.append(.localized(.addressColon), with: self.addressLabel.font).append("\(request.location?.address ?? "")" , with: Font.Small.medium)
        
        if let repairOrders = request.booking?.repairOrderRequests, repairOrders.count > 0 {
            let addressString = NSMutableAttributedString()
            self.serviceLabel.attributedText = addressString.append(.localized(.serviceColon), with: self.serviceLabel.font).append("\(request.booking?.repairOrderNames() ?? "")" , with: Font.Small.medium)
        }
    }
    
}
