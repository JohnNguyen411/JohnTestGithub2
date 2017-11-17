//
//  SchedulingPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/3/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

class SchedulingPickupViewController: SchedulingViewController {
    
    override func setupViews() {
        super.setupViews()
        loanerView.snp.makeConstraints { make in
            make.left.right.equalTo(checkupLabel)
            make.top.equalTo(pickupLocationView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        
        leftButton.setTitle(title: (.SelfDrop as String).uppercased())
        rightButton.setTitle(title: (.VolvoPickup as String).uppercased())
        
        if state == .pickupDriverDrivingToDealership || state == .pickupDriverAtDealership {
            leftButton.isHidden = true
            rightButton.isHidden = true
            confirmButton.isHidden = true
            
            if state == .pickupDriverDrivingToDealership {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    StateServiceManager.sharedInstance.updateState(state: .pickupDriverAtDealership)
                })
            } else if state == .pickupDriverAtDealership {
                let alert = UIAlertController(title: .VolvoPickup, message: .YourVehicleHasArrived, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: (.Ok as String).uppercased(), style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                    // show being serviced
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        StateServiceManager.sharedInstance.updateState(state: .servicing)
                    })
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    override func onLocationSelected(responseInfo: NSDictionary?, placemark: CLPlacemark?) {
        var openNext = false
        
        if scheduleState.rawValue < SchedulePickupState.location.rawValue {
            scheduleState = .location
            openNext = true
        }
        
        super.onLocationSelected(responseInfo: responseInfo, placemark: placemark)
        
        currentPresentrVC?.dismiss(animated: true, completion: {
            if openNext {
                self.loanerClick()
            }
        })
    }
    
    override func confirmButtonClick() {
        StateServiceManager.sharedInstance.updateState(state: .pickupScheduled)
    }
    
}