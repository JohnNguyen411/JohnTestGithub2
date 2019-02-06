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
    
    private let titleLabel = Label.taskTitle()
    private let licensePlateLabel = Label.taskText()
    private let keyCodeLabel = Label.taskText()
    private let loanerImageView = UIImageView()
    private let roLabel = Label.taskText()
    private let loanerAgreement = Label.taskText(with: "Loaner Agreement")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())
        
        loanerImageView.contentMode = .scaleAspectFit
        loanerImageView.clipsToBounds = true
        
        gridView.add(subview: self.titleLabel, from: 1, to: 6)
        self.titleLabel.pinToSuperviewTop(spacing: 40)
        
        gridView.add(subview: self.licensePlateLabel, from: 1, to: 6)
        self.licensePlateLabel.pinTopToBottomOf(view: self.titleLabel, spacing: 10)
        
        gridView.add(subview: self.keyCodeLabel, from: 1, to: 6)
        self.keyCodeLabel.pinTopToBottomOf(view: self.licensePlateLabel, spacing: 10)
        
        gridView.add(subview: self.loanerImageView, from: 1, to: 3)
        self.loanerImageView.pinTopToBottomOf(view: self.keyCodeLabel, spacing: 10)
        self.loanerImageView.constrain(height: 100)
        
        gridView.add(subview: self.roLabel, from: 1, to: 6)
        self.roLabel.pinTopToBottomOf(view: self.loanerImageView, spacing: 10)
        
        gridView.add(subview: self.loanerAgreement, from: 1, to: 6)
        self.loanerAgreement.pinTopToBottomOf(view: self.roLabel, spacing: 10)
        
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        if request.isPickup {
            if let loaner = request.booking?.loanerVehicle {
                let loanerString = NSMutableAttributedString()
                self.titleLabel.attributedText = loanerString.append(.localized(.loanerColon), with: self.titleLabel.font).append("\(loaner.vehicleDescription())" , with: Font.Medium.medium)
                
                let licenseString = NSMutableAttributedString()
                self.licensePlateLabel.attributedText = licenseString.append(.localized(.licensePlateColon), with: self.licensePlateLabel.font).append("\(loaner.licensePlate ?? "")" , with: Font.Small.medium)
                
                let keyCodeString = NSMutableAttributedString()
                self.keyCodeLabel.attributedText = keyCodeString.append(.localized(.keyCodeColon), with: self.licensePlateLabel.font).append("\(loaner.keyTagCode ?? "")" , with: Font.Small.medium)
                
                if let photoUrl = loaner.photoUrl, let url = URL(string: photoUrl) {
                    self.loanerImageView.kf.setImage(with: url)
                }
                
            } else {
                let loanerString = NSMutableAttributedString()
                self.titleLabel.attributedText = loanerString.append(.localized(.customerColon), with: self.titleLabel.font).append("\(request.booking?.customer.fullName() ?? "")" , with: Font.Medium.medium)
                
                let addressString = NSMutableAttributedString()
                self.licensePlateLabel.attributedText = addressString.append(.localized(.addressColon), with: self.licensePlateLabel.font).append("\(request.location?.address ?? "")" , with: Font.Small.medium)
                
                self.keyCodeLabel.isHidden = true
                self.loanerAgreement.isHidden = true
                self.loanerImageView.isHidden = true
                self.loanerImageView.constrain(height: 0)

            }
        } else {
            if let vehicle = self.request?.booking?.vehicle {
                let loanerString = NSMutableAttributedString()
                self.titleLabel.attributedText = loanerString.append(.localized(.deliveryColon), with: self.titleLabel.font).append("\(vehicle.vehicleDescription())" , with: Font.Medium.medium)
                
                if let licensePlate = vehicle.licensePlate{
                    let licenseString = NSMutableAttributedString()
                    self.licensePlateLabel.attributedText = licenseString.append(.localized(.licensePlateColon), with: self.licensePlateLabel.font).append(licensePlate , with: Font.Small.medium)
                }
                
                if let photoUrl = vehicle.photoUrl, let url = URL(string: photoUrl) {
                    self.loanerImageView.kf.setImage(with: url)
                }
            }
            
            self.loanerAgreement.isHidden = true
        }
        
        if let booking = request.booking, let ros = booking.repairOrderRequests, ros.count > 0 {
            let roString = NSMutableAttributedString()
            self.roLabel.attributedText = roString.append("\(String.localized(.repairOrderColon)) \(booking.repairOrderIds())", with: Font.Small.bold)
        }
    }
   
}
