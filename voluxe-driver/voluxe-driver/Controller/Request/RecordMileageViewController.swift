//
//  RecordMileageViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/23/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class RecordMileageViewController: RequestStepViewController {
    
    //MARK - Data
    private var mileageUnit: String?
    private var lastMileage: Int?

    //MARK - Layout
    private let lastMileageLabel = Label.taskText()
    private let mileageTextField = VLVerticalTextField(title: "", placeholder: Unlocalized.loanerMileageUnit)

    let numberToolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mileageTextField.textField.autocorrectionType = .no
        mileageTextField.textField.autocapitalizationType = .none
        mileageTextField.textField.keyboardType = .numberPad

        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.isTranslucent = true
        numberToolbar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Unlocalized.ok, style: .plain, target: self, action: #selector(RecordMileageViewController.okClicked))
        numberToolbar.setItems([spaceButton, doneButton], animated: false)
        numberToolbar.isUserInteractionEnabled = true
        
        UIBarButtonItem.styleBarButtonItem(barButton: doneButton)
        
        mileageTextField.textField.inputAccessoryView = numberToolbar
        
        self.addViews([self.lastMileageLabel])
        self.addView(self.mileageTextField, below: self.lastMileageLabel, spacing: 30)
        
        
        self.mileageTextField.heightAnchor.constraint(equalToConstant: CGFloat(VLVerticalTextField.height)).isActive = true
        
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        self.titleLabel.text = .localized(.viewRecordLoanerMileage)
        self.titleLabel.font = Font.Medium.medium
        
        let mileageString = NSMutableAttributedString()
        mileageString.append(.localized(.recentMileageColon), with: self.lastMileageLabel.font)
        if let loaner = request.booking?.loanerVehicle, let lastMileage = loaner.latestOdometerReading {
            self.mileageUnit = lastMileage.unit
            self.lastMileage = lastMileage.value
            self.lastMileageLabel.attributedText = mileageString.append("\(lastMileage.value) \(lastMileage.unit)", with: self.intermediateMediumFont())
        } else {
            if let dealershipId = request.booking?.dealershipId, let dealership = DriverManager.shared.dealership(for: dealershipId), let preferredVehicleOdometerReadingUnit = dealership.preferredVehicleOdometerReadingUnit {
                self.mileageUnit = preferredVehicleOdometerReadingUnit
            } else {
                self.mileageUnit = "mi"
            }
            mileageString.append("-", with: self.intermediateMediumFont())
        }
        
        mileageTextField.textField.placeholder = String(format: Unlocalized.loanerMileageUnit, self.mileageUnit ?? "")
    }
    
    // MARK: Actions
    
    @objc func okClicked() {
        mileageTextField.textField.resignFirstResponder()
    }
    
    override func swipeNext(completion: ((Bool) -> ())?) {
        
        
        // check mileage
        guard Int(self.mileageTextField.text) ?? 0 > 0 else {
            self.emptyMileageError()
            return
        }
        
        guard !self.checkMileageDifference() else {
            return
        }
        
        self.updateMileage(completion: completion)
    }
    
    func updateMileage(completion: ((Bool) -> ())?) {
        guard let request = self.request,
            let mileage = UInt(self.mileageTextField.text),
            let mileageUnit = self.mileageUnit else {
                super.swipeNext(completion: completion)
                return
        }
        AppController.shared.lookBusy()
        
        DriverAPI.update(request, loanerMileage: mileage, units: mileageUnit, completion: { error in
            AppController.shared.lookNotBusy()
            
            if error != nil {
                // todo: queue task and try later
            }
            super.swipeNext(completion: completion)
        })
    }
    
   
    
    func emptyMileageError() {
        AppController.shared.alert(title: .localized(.viewRecordLoanerMileage), message: .localized(.errorEnterLoanerMileage))
    }
    
    // if tooHigh == false, then too low
    func mileageError(tooHigh: Bool) {
        
        if tooHigh {
            Analytics.trackView(screen: .pickupLoanerMileageTooHigh, from: self.screenName)
        } else {
            Analytics.trackView(screen: .deliveryLoanerMileageTooHigh, from: self.screenName)
        }
        
        
        AppController.shared.alert(title: .localized(.viewRecordLoanerMileage),
                                   message: .localized(tooHigh ? .popupMileageMaxConfirmation : .popupMileageMinConfirmation),
                                   cancelButtonTitle: .localized(.no),
                                   okButtonTitle: .localized(.yes),
                                   okCompletion: {
                                    
                                    self.updateMileage(completion: { success in
                                        self.flowDelegate?.pushNextStep()
                                    })
                                    
        })
    }
    
    // return true is mileage difference issue
    func checkMileageDifference() -> Bool {
        
        guard let lastMileage = self.lastMileage,
            let mileageUnit = self.mileageUnit,
            let enteredMileage = mileageTextField.textField.text,
            let newMileage = Int(enteredMileage) else {
            return false
        }
        
        // check if too much
        if newMileage > lastMileage + maxMileThreshold(unit: mileageUnit) {
            self.mileageError(tooHigh: true)
            return true
        } else if newMileage < lastMileage {
            self.mileageError(tooHigh: false)
            return true
        }
        
        return false
    }
    
    func maxMileThreshold(unit: String) -> Int{
        if unit != "mi" {
            return Int(300 * 1.60934)
        } else {
            // meters
            return 300
        }
    }

}
