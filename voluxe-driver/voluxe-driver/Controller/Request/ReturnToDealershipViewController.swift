//
//  ReturnToDealershipViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/1/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ReturnToDealershipViewController: RequestStepViewController {
    
    private let titleLabel = Label.taskTitle()
    private let customerLabel = Label.taskTitle()
    private let serviceLabel = Label.taskText()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())
        
        gridView.add(subview: self.titleLabel, from: 1, to: 6)
        self.titleLabel.pinToSuperviewTop(spacing: 40)
        
        gridView.add(subview: self.customerLabel, from: 1, to: 6)
        self.customerLabel.pinTopToBottomOf(view: self.titleLabel, spacing: 10)
        
        gridView.add(subview: self.serviceLabel, from: 1, to: 6)
        self.serviceLabel.pinTopToBottomOf(view: self.customerLabel, spacing: 10)
        
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        self.titleLabel.text = self.title
        
        let customerString = NSMutableAttributedString()
        self.customerLabel.attributedText = customerString.append(.localized(.customerColon), with: self.customerLabel.font).append("\(request.booking?.customer.fullName() ?? "")" , with: Font.Small.medium)
        
        if let repairOrders = request.booking?.repairOrderRequests, repairOrders.count > 0 {
            let addressString = NSMutableAttributedString()
            self.serviceLabel.attributedText = addressString.append(.localized(.serviceColon), with: self.serviceLabel.font).append("\(request.booking?.repairOrderNames() ?? "")" , with: Font.Small.medium)
        }
    }
    
}
