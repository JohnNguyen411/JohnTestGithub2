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
    
    private let licensePlateLabel = Label.taskText()
    private let loanerImageView = UIImageViewAligned()
    private let reminderLabel = Label.taskText()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reminderLabel.font = Font.Intermediate.italic
        
        self.loanerImageView.alignLeft = true
        self.loanerImageView.contentMode = .scaleAspectFit
        self.loanerImageView.clipsToBounds = true
        
        self.addViews([self.licensePlateLabel])
        self.loanerImageView.constrain(height: 120)
        
        self.addView(self.loanerImageView, below: self.licensePlateLabel, spacing: 20)
        self.addView(self.reminderLabel, below: self.loanerImageView, spacing: 20)

    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
      
        if request.isDropOff {
            if let vehicle = self.request?.booking?.loanerVehicle {
                let loanerString = NSMutableAttributedString()
                self.titleLabel.attributedText = loanerString.append(.localized(.loanerColon),
                                                                      with: self.titleLabel.font).append("\(vehicle.vehicleDescription())",
                                                                        with: Font.Medium.medium)
                
                if let licensePlate = vehicle.licensePlate {
                    let licenseString = NSMutableAttributedString()
                    self.licensePlateLabel.attributedText = licenseString.append(.localized(.licensePlateColon), with: self.licensePlateLabel.font).append(licensePlate , with: self.intermediateMediumFont())
                }
                
                if let photoUrl = vehicle.photoUrl, let url = URL(string: photoUrl) {
                    self.loanerImageView.kf.setImage(with: url)
                }
            }
            
            self.reminderLabel.attributedText = NSMutableAttributedString.highlight(String(format: .localized(.viewReceiveVehicleInfoReminder), self.request?.booking?.customer.fullName() ?? .localized(.unknown)), with: UIColor.Volvo.yellow())
            
            self.reminderLabel.sizeToFit()
        }
        
    }
  
}
