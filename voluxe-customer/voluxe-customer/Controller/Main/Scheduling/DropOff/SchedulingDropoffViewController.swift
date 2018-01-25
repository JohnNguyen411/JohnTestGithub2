//
//  SchedulingDropoffViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

class SchedulingDropoffViewController: SchedulingViewController {
    
    override func setupViews() {
        self.checkupLabel.isHidden = true
        
        super.setupViews()
        
        leftButton.setTitle(title: (.SelfPickup as String).uppercased())
        rightButton.setTitle(title: (.VolvoDelivery as String).uppercased())
        confirmButton.setTitle(title: (.ConfirmDelivery as String).uppercased())
        
        dealershipView.isUserInteractionEnabled = false
        
        loanerView.isHidden = true
        
        self.showCheckupLabel(show: false, alpha: true, animated: false)
    }
    
    override func fillViews() {
        super.fillViews()
        scheduledPickupView.titleLabel.text = .ScheduledDelivery
        pickupLocationView.titleLabel.text = .DeliveryLocation
    }
    
    func hideDealership() {
        
        self.dealershipView.isHidden = true
        
        self.dealershipView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        
        scheduledPickupView.snp.remakeConstraints { make in
            make.left.right.equalTo(checkupLabel)
            make.top.equalTo(descriptionButton.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        pickupLocationView.snp.remakeConstraints { make in
            make.left.right.equalTo(checkupLabel)
            make.top.equalTo(scheduledPickupView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        
       hideDealership()
        
        if state == .serviceCompleted {
            checkupLabel.text = .VolvoServiceComplete
            leftButton.animateAlpha(show: true)
            rightButton.animateAlpha(show: true)
            showCheckupLabel(show: true, alpha: true, animated: true)

        } else {
            checkupLabel.text = .VolvoCurrentlyServicing
            leftButton.isHidden = true
            rightButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                self.stateDidChange(state: .serviceCompleted)
            })
        }
        
    }
    
    
    override func onLocationSelected(responseInfo: NSDictionary?, placemark: CLPlacemark?) {
        
        if scheduleState.rawValue < SchedulePickupState.location.rawValue {
            scheduleState = .location
        }
        
        super.onLocationSelected(responseInfo: responseInfo, placemark: placemark)
        
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.confirmButton.animateAlpha(show: true)
        })
    }
    
    override func confirmButtonClick() {
        StateServiceManager.sharedInstance.updateState(state: .deliveryScheduled)
    }
    
}
