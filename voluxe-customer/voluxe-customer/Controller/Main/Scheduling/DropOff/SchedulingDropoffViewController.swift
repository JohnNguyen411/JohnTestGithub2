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
            make.top.equalTo(descriptionButton.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        pickupLocationView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(scheduledPickupView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        
        loanerView.isEditable = false
        dealershipView.isEditable = false
        scheduledPickupView.isEditable = true
        pickupLocationView.isEditable = true
        
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
    
    override func onLocationSelected(customerAddress: CustomerAddress) {
        // need to check that location is within range
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.showBlockingLoading()
        })
        
        if dropoffScheduleState.rawValue < ScheduleDropoffState.location.rawValue {
            dropoffScheduleState = .location
        }
        
        super.onLocationSelected(customerAddress: customerAddress)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            
            self.fetchDealershipsForLocation(location: customerAddress.location?.getLocation(), completion: {
                // hide loader
                self.hideBlockingLoading()
                
                if let dealerships = self.dealerships, dealerships.count > 0 {
                    for dealership in dealerships {
                        if dealership.id == RequestedServiceManager.sharedInstance.getDealership()?.id {
                            self.pickupLocationView.hideError()
                            self.confirmButton.animateAlpha(show: true)
                            return
                            // within zone
                        }
                    }
                }
                
                //todo: OUT OF ZONE ERROR
                self.pickupLocationView.showError(error: .OutOfPickupArea)
                self.confirmButton.animateAlpha(show: false)
            })
        })
        
        
    }
    
    override func onDateTimeSelected(timeSlot: DealershipTimeSlot) {
        var openNext = false
        if dropoffScheduleState.rawValue < ScheduleDropoffState.dateTime.rawValue {
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
