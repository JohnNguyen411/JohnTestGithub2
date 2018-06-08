//
//  AddLocationViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/9/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GooglePlaces
import MBProgressHUD

class AddLocationViewController: VLPresentrViewController, LocationManagerDelegate, UITextFieldDelegate, VLVerticalSearchTextFieldDelegate, PresentrDelegate {
    
    weak var pickupLocationDelegate: AddLocationDelegate?
    var locationManager = LocationManager.sharedInstance
    
    weak var presentrDelegate: PresentrDelegate?
    var selectedLocation: GMSPlace?
    
    var autocompletePredictions: [GMSAutocompletePrediction]?
    var autoCompleteCharacterCount = 0
    
    let newLocationTextField = VLVerticalSearchTextField(title: .AddressForPickup, placeholder: .AddressForPickupPlaceholder)
    
    override init(title: String, buttonTitle: String, screenName: String) {
        super.init(title: title, buttonTitle: buttonTitle, screenName: screenName)
        newLocationTextField.textField.autocorrectionType = .no
        newLocationTextField.tableYOffset = -20
        newLocationTextField.tableBottomMargin = 0
        newLocationTextField.maxResultsListHeight = Int(3 * VLVerticalSearchTextField.defaultCellHeight)
        newLocationTextField.delegate = self
        newLocationTextField.textField.accessibilityIdentifier = "newLocationTextField.textField"
        newLocationTextField.textField.delegate = self
        newLocationTextField.rightLabel.isHidden = true
        newLocationTextField.rightLabel.accessibilityIdentifier = "newLocationTextField.rightLabel"

        locationManager.delegate = self

        bottomButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        locationManager.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newLocationTextField.textField.becomeFirstResponder()
    }
    
    override func setupViews() {
        super.setupViews()
        containerView.addSubview(newLocationTextField)
        
        newLocationTextField.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(VLVerticalTextField.height)
        }
        
    }
    
    override func height() -> Int {
        return baseHeight + VLVerticalTextField.height + 80
    }
    
    
    override func onButtonClick() {
        if let pickupLocationDelegate = pickupLocationDelegate, let selectedLocation = selectedLocation {
            let location = Location(name: selectedLocation.formattedAddress, latitude: nil, longitude: nil, location: selectedLocation.coordinate)
            pickupLocationDelegate.onLocationAdded(location: location, placeId: selectedLocation.placeID)
        }
    }
    
    
    func autocompleteWithText(userText: String){
        selectedLocation = nil
        self.bottomButton.isEnabled = false
        
        if userText.count > 2 {
            weak var weakSelf = self

            self.locationManager.googlePlacesAutocomplete(address: userText) { (autocompletePredictions, error) in
                guard let weakSelf = weakSelf else { return }
                if weakSelf.isBeingDismissed { return }
                
                if let _ = error {
                    self.newLocationTextField.text = userText
                    self.autoCompleteCharacterCount = 0
                    
                } else if let autocompletePredictions = autocompletePredictions {
                    self.autocompletePredictions = autocompletePredictions
                    var formattedAddress: [NSAttributedString] = []
                    autocompletePredictions.forEach { prediction in
                        formattedAddress.append(prediction.attributedFullText)
                    }
                    self.newLocationTextField.filteredStrings(formattedAddress)
                }
            }
            VLAnalytics.logEventWithName(AnalyticsConstants.eventGmapsRequest, paramName: AnalyticsConstants.paramGMapsType, paramValue: AnalyticsConstants.paramNameGmapsPlace, screenName: screenName)
        } else {
            self.newLocationTextField.filteredStrings([])
        }
    }
    
    func locationFound(_ latitude: Double, longitude: Double) {
    }
    
    // MARK: protocol UITextFieldDelegate
    
    func onAutocompleteSelected(selectedIndex: Int) {
        
        newLocationTextField.closeAutocomplete()
        
        guard let autocompletePredictions = autocompletePredictions, let superview = self.view.superview else { return }
        if selectedIndex > autocompletePredictions.count { return }
        
        let selectedPrediction = autocompletePredictions[selectedIndex]
        
        guard let placeId = selectedPrediction.placeID else { return }
        
        MBProgressHUD.showAdded(to: superview, animated: true)
        
        self.locationManager.getPlace(placeId: placeId) { (gmsPlace, error) in
            MBProgressHUD.hide(for: superview, animated: true)
            if let place = gmsPlace {
                self.selectedLocation = place
                self.bottomButton.isEnabled = true
            }
        }
        VLAnalytics.logEventWithName(AnalyticsConstants.eventGmapsRequest, paramName: AnalyticsConstants.paramGMapsType, paramValue: AnalyticsConstants.paramNameGmapsPlace, screenName: screenName)

        //self.newLocationTextField.textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string) // 2
        subString = formatSubstring(subString: subString)
        
        if subString.count == 0 { // 3 when a user clears the textField
            resetValues()
        } else {
            autocompleteWithText(userText: subString) //4
        }
        return true
    }
    
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized //5
        return formatted
    }
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        self.newLocationTextField.textField.text = ""
    }
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        if let presentrDelegate = presentrDelegate {
            return presentrDelegate.presentrShouldDismiss!(keyboardShowing: keyboardShowing)
        }
        return true
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        newLocationTextField.closeAutocomplete()
    }
}

// MARK: protocol AddLocationDelegate
protocol AddLocationDelegate: class {
    func onLocationAdded(location: Location?, placeId: String)
    
}
