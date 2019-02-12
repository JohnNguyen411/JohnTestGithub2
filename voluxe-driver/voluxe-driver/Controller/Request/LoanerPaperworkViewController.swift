//
//  LoanerPaperworkViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/23/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class LoanerPaperworkViewController: RequestStepViewController {
    
    private let licensePlateLabel = Label.taskText()
    private let keyCodeLabel = Label.taskText()
    private let loanerImageView = UIImageViewAligned()
    private let roLabel = Label.taskText()
    private let loanerAgreement = Label.taskText(with: String.localized(.viewChecklistLoanerAgreementLabel))

    private let separatorTop = UIView()
    private let separatorMiddle = UIView()
    private let separatorBottom = UIView()
    
    private var hasLoaner: Bool = false
    private var hasRO: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loanerImageView.alignLeft = true
        loanerImageView.contentMode = .scaleAspectFit
        loanerImageView.clipsToBounds = true
        
        loanerAgreement.font = Font.Intermediate.medium
        
        self.addViews([self.licensePlateLabel, self.keyCodeLabel])
        self.addView(self.loanerImageView, below: self.keyCodeLabel, spacing: 30)
        self.loanerImageView.constrain(height: 100)
        self.loanerImageView.constrain(width: 250)
        
        self.handleSeparators()
    }
    
    private func handleSeparators() {
        
        self.separatorTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.separatorMiddle.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.separatorBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.separatorTop.backgroundColor = Color.Volvo.fog
        self.separatorMiddle.backgroundColor = Color.Volvo.fog
        self.separatorBottom.backgroundColor = Color.Volvo.fog

        // NONE
        if !hasRO && !hasLoaner {
            return
        }
        
        if hasRO && !hasLoaner {
            self.addView(self.separatorTop, below: self.loanerImageView, spacing: 30)
            self.addView(self.roLabel, below: self.separatorTop, spacing: 5)
            self.addView(self.separatorMiddle, below: self.roLabel, spacing: 5)
            
            self.separatorTop.pinTrailingToSuperView(constant: -20)
            self.separatorMiddle.pinTrailingToSuperView(constant: -20)
            
            return
        }
        
        if !hasRO && hasLoaner {
            self.addView(self.separatorMiddle, below: self.loanerImageView, spacing: 30)
            self.addView(self.loanerAgreement, below: self.separatorMiddle, spacing: 5)
            self.addView(self.separatorBottom, below: self.loanerAgreement, spacing: 5)
            
            self.separatorMiddle.pinTrailingToSuperView(constant: -20)
            self.separatorBottom.pinTrailingToSuperView(constant: -20)
            return
        }
        
        // ALL
        self.addView(self.separatorTop, below: self.loanerImageView, spacing: 30)
        self.addView(self.roLabel, below: self.separatorTop, spacing: 5)
        self.addView(self.separatorMiddle, below: self.roLabel, spacing: 5)
        self.addView(self.loanerAgreement, below: self.separatorMiddle, spacing: 5)
        self.addView(self.separatorBottom, below: self.loanerAgreement, spacing: 5)
        
        self.separatorTop.pinTrailingToSuperView(constant: -20)
        self.separatorMiddle.pinTrailingToSuperView(constant: -20)
        self.separatorBottom.pinTrailingToSuperView(constant: -20)
        
    }

    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        if request.isPickup {
            if let loaner = request.booking?.loanerVehicle {
                let loanerString = NSMutableAttributedString()
                self.titleLabel.attributedText = loanerString.append(.localized(.loanerColon), with: self.titleLabel.font).append("\(loaner.vehicleDescription())" , with: Font.Medium.medium)
                
                let licenseString = NSMutableAttributedString()
                self.licensePlateLabel.attributedText = licenseString.append(.localized(.licensePlateColon), with: self.licensePlateLabel.font).append("\(loaner.licensePlate ?? "")" , with: self.intermediateMediumFont())
                
                let keyCodeString = NSMutableAttributedString()
                self.keyCodeLabel.attributedText = keyCodeString.append(.localized(.keyCodeColon), with: self.licensePlateLabel.font).append("\(loaner.keyTagCode ?? "")" , with: self.intermediateMediumFont())
                
                if let photoUrl = loaner.photoUrl, let url = URL(string: photoUrl) {
                    self.loanerImageView.kf.setImage(with: url)
                }
                self.hasLoaner = true
                
            } else {
                let loanerString = NSMutableAttributedString()
                self.titleLabel.attributedText = loanerString.append(.localized(.customerColon), with: self.titleLabel.font).append("\(request.booking?.customer.fullName() ?? "")" , with: Font.Medium.medium)
                
                let addressString = NSMutableAttributedString()
                self.licensePlateLabel.attributedText = addressString.append(.localized(.addressColon), with: self.licensePlateLabel.font).append("\(request.location?.address ?? "")" , with: self.intermediateMediumFont())
                
                self.keyCodeLabel.isHidden = true
                self.loanerAgreement.isHidden = true
                self.loanerImageView.isHidden = true
                self.loanerImageView.constrain(height: 0)
                self.hasLoaner = false

            }
        } else {
            if let vehicle = self.request?.booking?.vehicle {
                let loanerString = NSMutableAttributedString()
                self.titleLabel.attributedText = loanerString.append(.localized(.deliveryColon), with: self.titleLabel.font).append("\(vehicle.vehicleDescription())" , with: Font.Medium.medium)
                
                if let licensePlate = vehicle.licensePlate{
                    let licenseString = NSMutableAttributedString()
                    self.licensePlateLabel.attributedText = licenseString.append(.localized(.licensePlateColon), with: self.licensePlateLabel.font).append(licensePlate , with: self.intermediateMediumFont())
                }
                
                if let photoUrl = vehicle.photoUrl, let url = URL(string: photoUrl) {
                    self.loanerImageView.kf.setImage(with: url)
                }
            }
            
            self.loanerAgreement.isHidden = true
        }
        
        if let booking = request.booking, let ros = booking.repairOrderRequests, ros.count > 0 {
            self.hasRO = true
            let roString = NSMutableAttributedString()
            self.roLabel.attributedText = roString.append("\(String.localized(.repairOrderColon)) \(booking.repairOrderIds())", with: self.intermediateMediumFont())
        }
    }
   
}
