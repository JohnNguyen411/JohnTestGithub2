//
//  ReceiveLoanerViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/5/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ReceiveLoanerViewController: RequestStepViewController {
    
    private let loanerLabel = Label.taskTitle()
    private let licensePlateLabel = Label.taskText()
    private let loanerImageView = UIImageView()
    private let reminderLaber = Label.taskText(with: "Loaner Agreement")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())
        
        loanerImageView.contentMode = .scaleAspectFit
        loanerImageView.clipsToBounds = true
        
        gridView.add(subview: self.loanerLabel, from: 1, to: 6)
        self.loanerLabel.pinToSuperviewTop(spacing: 40)
        
        gridView.add(subview: self.licensePlateLabel, from: 1, to: 6)
        self.licensePlateLabel.pinTopToBottomOf(view: self.loanerLabel, spacing: 10)
        
        gridView.add(subview: self.loanerImageView, from: 1, to: 3)
        self.loanerImageView.pinTopToBottomOf(view: self.licensePlateLabel, spacing: 10)
        self.loanerImageView.constrain(height: 100)
        
        gridView.add(subview: self.reminderLaber, from: 1, to: 6)
        self.reminderLaber.pinTopToBottomOf(view: self.loanerImageView, spacing: 10)
        
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
      
        if request.isDropOff {
            if let vehicle = self.request?.booking?.loanerVehicle {
                let loanerString = NSMutableAttributedString()
                self.loanerLabel.attributedText = loanerString.append(.localized(.loanerColon),
                                                                      with: self.loanerLabel.font).append("\(vehicle.vehicleDescription())",
                                                                        with: Font.Medium.medium)
                
                if let licensePlate = vehicle.licensePlate {
                    let licenseString = NSMutableAttributedString()
                    self.licensePlateLabel.attributedText = licenseString.append(.localized(.licensePlateColon), with: self.licensePlateLabel.font).append(licensePlate , with: Font.Small.medium)
                }
                
                if let photoUrl = vehicle.photoUrl, let url = URL(string: photoUrl) {
                    self.loanerImageView.kf.setImage(with: url)
                }
            }
            
            self.reminderLaber.text = String(format: .localized(.viewReceiveVehicleInfoReminder), self.request?.booking?.customer.fullName() ?? .localized(.unknown))
        }
        
    }
  
}
