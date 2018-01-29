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
        
        super.setupViews()
        
        dealershipView.isUserInteractionEnabled = false
        
        loanerView.isHidden = true
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
            make.left.right.equalToSuperview()
            make.top.equalTo(descriptionButton.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        pickupLocationView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(scheduledPickupView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        
        if state == .schedulingDelivery {
            hideDealership()
            scheduledPickupClick()
        }
        
    }
    
    
    @objc override func dealershipClick() {
    }
    
    @objc override func scheduledPickupClick() {
        showPickupDateTimeModal(dismissOnTap: dropoffScheduleState.rawValue >= ScheduleDropoffState.dateTime.rawValue)
        super.scheduledPickupClick()
    }
    
    @objc override func pickupLocationClick() {
        showPickupLocationModal(dismissOnTap: dropoffScheduleState.rawValue >= ScheduleDropoffState.location.rawValue)
        super.pickupLocationClick()
    }
    
    @objc override func loanerClick() {
    }
    
    override func onLocationSelected(responseInfo: NSDictionary?, placemark: CLPlacemark?) {
        
        if dropoffScheduleState.rawValue < SchedulePickupState.location.rawValue {
            dropoffScheduleState = .location
        }
        
        super.onLocationSelected(responseInfo: responseInfo, placemark: placemark)
        
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.confirmButton.animateAlpha(show: true)
        })
    }
    
    override func onDateTimeSelected(timeSlot: DealershipTimeSlot) {
        var openNext = false
        if dropoffScheduleState.rawValue < SchedulePickupState.dateTime.rawValue {
            dropoffScheduleState = .dateTime
            openNext = true
        }
        super.onDateTimeSelected(timeSlot: timeSlot)
        currentPresentrVC?.dismiss(animated: true, completion: {
            if openNext {
                self.pickupLocationClick()
            }
        })
    }
    
    override func confirmButtonClick() {
        StateServiceManager.sharedInstance.updateState(state: .deliveryScheduled)
    }
    
}
