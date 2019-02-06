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

    //MARK - Layout
    private let titleLabel = Label.taskTitle(with: "Record Loaner Mileage")
    private let lastMileageLabel = Label.taskText()
    
    private let mileageTextField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.borderStyle = .roundedRect
        field.keyboardType = .numberPad
        field.placeholder = "Loaner Mileage"
        return field
    }()
    
    let numberToolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.isTranslucent = true
        numberToolbar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Unlocalized.ok, style: .plain, target: self, action: #selector(RecordMileageViewController.okClicked))
        numberToolbar.setItems([spaceButton, doneButton], animated: false)
        numberToolbar.isUserInteractionEnabled = true
        
        UIBarButtonItem.styleBarButtonItem(barButton: doneButton)
        
        mileageTextField.inputAccessoryView = numberToolbar
        
        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView(with: GridLayout.volvoAgent())
        
        gridView.add(subview: self.titleLabel, from: 1, to: 6)
        self.titleLabel.pinToSuperviewTop(spacing: 40)
        
        gridView.add(subview: self.lastMileageLabel, from: 1, to: 6)
        self.lastMileageLabel.pinTopToBottomOf(view: self.titleLabel, spacing: 10)
        
        gridView.add(subview: self.mileageTextField, from: 1, to: 6)
        self.mileageTextField.pinTopToBottomOf(view: self.lastMileageLabel, spacing: 40)
        
    }
    
    override func fillWithRequest(request: Request) {
        super.fillWithRequest(request: request)
        
        let mileageString = NSMutableAttributedString()
        mileageString.append("Recent Mileage: ", with: self.lastMileageLabel.font)
        if let loaner = request.booking?.loanerVehicle, let lastMileage = loaner.latestOdometerReading {
            self.mileageUnit = lastMileage.unit
            self.lastMileageLabel.attributedText = mileageString.append("\(lastMileage.value) \(lastMileage.unit)", with: Font.Small.medium)
        } else {
            if let dealershipId = request.booking?.dealershipId, let dealership = DriverManager.shared.dealership(for: dealershipId), let preferredVehicleOdometerReadingUnit = dealership.preferredVehicleOdometerReadingUnit {
                self.mileageUnit = preferredVehicleOdometerReadingUnit
            } else {
                self.mileageUnit = "mi"
            }
            mileageString.append("-", with: Font.Small.medium)
        }
    }
    
    // MARK: Actions
    
    @objc func okClicked() {
        mileageTextField.resignFirstResponder()
    }
    
    override func swipeNext(completion: ((Bool) -> ())?) {
        guard let request = self.request,
            let mileageString = self.mileageTextField.text,
            let mileage = UInt(mileageString),
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

}
