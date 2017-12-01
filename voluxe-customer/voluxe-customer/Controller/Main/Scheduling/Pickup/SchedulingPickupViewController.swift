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
    
    override func fillViews() {
        if serviceState == .idle || serviceState == .needService {
            let service = Service(name: "10,000 mile check-up", price: Double(400))
            RequestedServiceManager.sharedInstance.setService(service: service)
        }
        let date = RequestedServiceManager.sharedInstance.getPickupDate()
        let min = RequestedServiceManager.sharedInstance.getPickupTimeMin()
        let max = RequestedServiceManager.sharedInstance.getPickupTimeMax()
        if let date = date, let min = min, let max = max {
            let dateTime = formatter.string(from: date)
            scheduledPickupView.setTitle(title: .ScheduledPickup, leftDescription: "\(dateTime) \(Date.formatHourRange(min: min, max: max))", rightDescription: "")
        }
        
        if let requestLocation = RequestedServiceManager.sharedInstance.getPickupLocation() {
            pickupLocationView.setTitle(title: .PickupLocation, leftDescription: requestLocation.name!, rightDescription: "")
        }
        super.fillViews()
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        
        leftButton.setTitle(title: (.SelfDrop as String).uppercased())
        rightButton.setTitle(title: (.VolvoPickup as String).uppercased())
        
        if state == .pickupDriverDrivingToDealership || state == .pickupDriverAtDealership {
            
            if !self.checkupLabel.isHidden {
                UIView.animate(withDuration: 0.5, animations: {
                    self.checkupLabel.snp.updateConstraints { make in
                        make.height.equalTo(0)
                    }
                    self.checkupLabel.superview?.layoutIfNeeded()
                }, completion: { (completed) in
                    self.checkupLabel.isHidden = true
                })
            }
            
            leftButton.isHidden = true
            rightButton.isHidden = true
            confirmButton.isHidden = true
            
            if state == .pickupDriverDrivingToDealership {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                   StateServiceManager.sharedInstance.updateState(state: .pickupDriverAtDealership)
                })
            } else if state == .pickupDriverAtDealership {
                let alert = UIAlertController(title: .VolvoPickup, message: .YourVehicleHasArrived, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: (.Ok as String).uppercased(), style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                    // show being serviced
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        StateServiceManager.sharedInstance.updateState(state: .servicing)
                    })})
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: {
                    // add accessibility if possible
                    if let alertButton = okAction.value(forKey: "__representer") {
                        let view = alertButton as? UIView
                        view?.accessibilityIdentifier = "okAction_AID"
                    }
                })
            }
        } else {
            if self.checkupLabel.isHidden {
                self.checkupLabel.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.checkupLabel.snp.updateConstraints { make in
                        make.height.equalTo(self.checkupLabelHeight)
                    }
                    self.checkupLabel.superview?.layoutIfNeeded()
                })
            }
        }
        
        if state.rawValue >= ServiceState.pickupScheduled.rawValue {
            
            scheduledPickupView.animateAlpha(show: true)
            pickupLocationView.animateAlpha(show: true)
            loanerView.animateAlpha(show: true)
            
            scheduledPickupView.isUserInteractionEnabled = false
            pickupLocationView.isUserInteractionEnabled = false
            loanerView.isUserInteractionEnabled = false
            dealershipView.isUserInteractionEnabled = false
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
