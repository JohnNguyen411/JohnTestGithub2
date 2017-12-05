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
        
        self.checkupLabel.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
    
    override func fillViews() {
        super.fillViews()
        scheduledPickupView.titleLabel.text = .ScheduledDelivery
        pickupLocationView.titleLabel.text = .DeliveryLocation
    }
    
    override func hideCheckupLabel() {
        super.hideCheckupLabel()
        
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
        
        if self.checkupLabel.isHidden {
            self.checkupLabel.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.checkupLabel.snp.updateConstraints { make in
                    make.height.equalTo(self.checkupLabelHeight)
                }
                self.checkupLabel.superview?.layoutIfNeeded()
            })
        }
        
        if state == .serviceCompleted {
            checkupLabel.text = .VolvoServiceComplete
            leftButton.animateAlpha(show: true)
            rightButton.animateAlpha(show: true)
        } else {
            checkupLabel.text = .VolvoCurrentlyServicing
            leftButton.isHidden = true
            rightButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
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
