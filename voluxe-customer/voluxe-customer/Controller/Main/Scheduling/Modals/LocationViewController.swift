//
//  LocationViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import RealmSwift
import GooglePlaces
import MBProgressHUD


class LocationViewController: VLPresentrViewController, LocationManagerDelegate, UITextFieldDelegate, VLVerticalSearchTextFieldDelegate {
    
    private static let maxCount = 4
    
    private static let newLocationButtonHeight = 0
    private static let newLocationTextFieldHeight = VLVerticalTextField.height + 5

    var newLocationHeight = newLocationButtonHeight
    
    var user: Customer?
    
    var addresses: Results<CustomerAddress>?
    var addressesCount = 0
    var realm : Realm?
    
    var pickupLocationDelegate: PickupLocationDelegate?
    var locationManager = LocationManager.sharedInstance
    
    // current location == user current location
    var currentLocationAddress: GMSAddress?
    
    // selected Location == selected from autocomplete
    var selectedLocation: GMSAutocompletePrediction?
    
    // locations displayed in autocomplete
    var autocompletePredictions: [GMSAutocompletePrediction]?
    var autoCompleteCharacterCount = 0
    
    var selectedIndex = 0
    var preselectedIndex = -1
    
    let newLocationLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.text = (.AddNewLocation as String).uppercased()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.textAlignment = .left
        titleLabel.addUppercasedCharacterSpacing()
        return titleLabel
    }()
    
    let newLocationButton: VLButton
    
    let newLocationTextField = VLVerticalSearchTextField(title: .AddressForPickup, placeholder: .AddressForPickupPlaceholder)
    let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
    
    override init(title: String, buttonTitle: String, screenName: String) {
        newLocationButton = VLButton(type: .blueSecondary, title: (.AddNewLocation as String).uppercased(), kern: UILabel.uppercasedKern(), eventName: AnalyticsConstants.eventClickAddNewLocation, screenName: screenName)
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
  
        locationManager.autoUpdate = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        bottomButton.isEnabled = false
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CheckmarkCell.self, forCellReuseIdentifier: CheckmarkCell.reuseId)
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        
        user = UserManager.sharedInstance.getCustomer()
        var selectedLocation = RequestedServiceManager.sharedInstance.getPickupLocation()
        if RequestedServiceManager.sharedInstance.getDropoffLocation() != nil {
            selectedLocation = RequestedServiceManager.sharedInstance.getDropoffLocation()
        }
        realm = try? Realm()
        if let realm = self.realm, let user = user {
            addresses = realm.objects(CustomerAddress.self).filter("volvoCustomerId = %@", user.email ?? "")
            if let addresses = addresses {
                addressesCount = addresses.count
                for (index, address) in addresses.enumerated() {
                    self.onLocationAdded()
                    if let selectedLocation = selectedLocation, selectedLocation.id == address.location?.id {
                        preselectedIndex = index
                    }
                }
                if addressesCount > 0 && preselectedIndex < 0 {
                    selectIndex(selectedIndex: selectedIndex)
                }
            }
            if preselectedIndex >= 0 {
                selectIndex(selectedIndex: preselectedIndex)
            }
        }
        
        newLocationButton.setActionBlock { [weak self] in
            self?.addNewLocationClicked()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    func onLocationAdded() {
        tableView.reloadData()
        
        containerView.snp.updateConstraints{ make in
            make.height.equalTo(height())
        }
        
        tableView.snp.updateConstraints{ make in
            make.height.equalTo(self.tableViewHeight())
        }
        
        if let pickupLocationDelegate = self.pickupLocationDelegate {
            pickupLocationDelegate.onSizeChanged()
        }
        
    }
    
    override func setupViews() {
        super.setupViews()
        
        containerView.addSubview(tableView)
        containerView.addSubview(newLocationLabel)
        containerView.addSubview(newLocationTextField)
        containerView.addSubview(newLocationButton)
        
        newLocationLabel.isHidden = true
        newLocationTextField.isHidden = true
        
        newLocationTextField.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        newLocationLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(newLocationTextField.snp.top)
            make.height.equalTo(25)
        }
        
        newLocationButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(bottomButton.snp.top).offset(-20)
        }
        
        let tableViewSeparator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-20, height: 1))
        tableViewSeparator.backgroundColor = .luxeLightestGray()
        
        self.tableView.tableFooterView = tableViewSeparator
        
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(newLocationButton.snp.top).offset(-20)
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(15)
            make.height.equalTo(self.tableViewHeight())
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(tableView.snp.top).offset(-10)
            make.height.equalTo(25)
        }
    }
    
    func tableViewHeight() -> Int {
        if numberOfRows() > LocationViewController.maxCount {
            return LocationViewController.maxCount * Int(CheckmarkCell.height) + 1
        } else {
            return numberOfRows() * Int(CheckmarkCell.height) + 1
        }
    }
    
    override func height() -> Int {
        return (tableViewHeight()) + baseHeight + newLocationHeight + 100
    }
    
    func autocompleteWithText(userText: String){
        selectedLocation = nil
        self.bottomButton.isEnabled = false
        weak var weakSelf = self
        if userText.count > 2 {
            self.locationManager.googlePlacesAutocomplete(address: self.newLocationTextField.text) { (autocompletePredictions, error) in
                guard let weakSelf = weakSelf else {
                    return
                }
                
                if weakSelf.isBeingDismissed {
                    return
                }
                
                if let _ = error {
                    weakSelf.newLocationTextField.text = userText
                    weakSelf.autoCompleteCharacterCount = 0
                } else if let autocompletePredictions = autocompletePredictions {
                    weakSelf.autocompletePredictions = autocompletePredictions
                    var formattedAddress: [NSAttributedString] = []
                    autocompletePredictions.forEach { prediction in
                        formattedAddress.append(prediction.attributedFullText)
                    }
                    weakSelf.newLocationTextField.filteredStrings(formattedAddress)
                }
            }
            VLAnalytics.logEventWithName(AnalyticsConstants.eventGmapsRequest, paramName: AnalyticsConstants.paramGMapsType, paramValue: AnalyticsConstants.paramNameGmapsPlace, screenName: screenName)
        }
    }
    
    func locationFound(_ latitude: Double, longitude: Double) {
        
        weak var weakSelf = self
        
        locationManager.reverseGeocodeLocation(latitude: latitude, longitude: longitude) { (reverseGeocodeResponse, error) in
            if let weakSelf = weakSelf, let response = reverseGeocodeResponse, let address = response.firstResult() {
                
                weakSelf.currentLocationAddress = address
                
                Logger.print("Address found")
                Logger.print(weakSelf.currentLocationAddress?.thoroughfare ?? "")
                weakSelf.onLocationAdded()
                weakSelf.bottomButton.isEnabled = true
                if weakSelf.preselectedIndex >= 0 {
                    weakSelf.selectIndex(selectedIndex: weakSelf.preselectedIndex)
                } else {
                    
                    weakSelf.selectIndex(selectedIndex: weakSelf.numberOfRows() - 1)
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        weakSelf.tableView.scrollToRow(at: IndexPath(row: weakSelf.numberOfRows() - 1, section: 0), at: .bottom, animated: true)
                    })
                }
            }
        }
        VLAnalytics.logEventWithName(AnalyticsConstants.eventGmapsRequest, paramName: AnalyticsConstants.paramGMapsType, paramValue: AnalyticsConstants.paramNameGmapsGeocode, screenName: screenName)
    }
    
    override func onButtonClick() {
        if let pickupLocationDelegate = pickupLocationDelegate {
            if self.currentLocationAddress != nil && selectedIndex == self.numberOfRows() - 1 {
                
                guard let currentLocationInfo = currentLocationAddress else {
                    return
                }
                // add location to realm
                var customerAddress = CustomerAddress()
                let addressString: String = currentLocationInfo.fullAddress()
                
                customerAddress.location = Location(name: addressString, latitude: nil, longitude: nil, location: currentLocationInfo.coordinate)
                customerAddress.createdAt = Date()
                customerAddress.volvoCustomerId = user!.email
                
                if let realm = self.realm {
                    // "email = %@", user.email ?? ""
                    let existingAddress = realm.objects(CustomerAddress.self).filter("location.address = %@ AND volvoCustomerId = %@", addressString, user!.email ?? "").first
                    if existingAddress == nil {
                        try? realm.write {
                            realm.add(customerAddress)
                            if let addresses = addresses {
                                addressesCount = addresses.count
                            }
                        }
                    } else {
                        customerAddress = existingAddress!
                    }
                }
                
                pickupLocationDelegate.onLocationSelected(customerAddress: customerAddress)
            } else {
                if let addresses = addresses {
                    pickupLocationDelegate.onLocationSelected(customerAddress: addresses[selectedIndex])
                }
            }
        }
    }
    
    private func addNewLocationClicked() {
        showNewLocationTextField(show: true)
        onLocationAdded()
        newLocationTextField.textField.becomeFirstResponder()
    }
    
    private func showNewLocationTextField(show: Bool) {
        newLocationLabel.animateAlpha(show: show)
        newLocationTextField.animateAlpha(show: show)
        newLocationButton.animateAlpha(show: !show)
        
        if show {
            tableView.snp.remakeConstraints { make in
                make.bottom.equalTo(newLocationLabel.snp.top).offset(-20)
                make.left.equalToSuperview()
                make.right.equalToSuperview().offset(15)
                make.height.equalTo(self.tableViewHeight())
            }
            
        } else {
            tableView.snp.remakeConstraints { make in
                make.bottom.equalTo(newLocationButton.snp.top).offset(-20)
                make.left.equalToSuperview()
                make.right.equalToSuperview().offset(15)
                make.height.equalTo(self.tableViewHeight())
            }
        }
        
        newLocationHeight = show ? LocationViewController.newLocationTextFieldHeight : LocationViewController.newLocationButtonHeight
    }
    
    // MARK: protocol UITextFieldDelegate
    
    func onAutocompleteSelected(selectedIndex: Int) {
        
        newLocationTextField.closeAutocomplete()
        
        guard let autocompletePredictions = autocompletePredictions else {
            return
        }
        
        if selectedIndex > autocompletePredictions.count {
            return
        }
        
        selectedLocation = autocompletePredictions[selectedIndex]
        
        guard let selectedLocation = selectedLocation, let placeId = selectedLocation.placeID, let superview = self.view.superview else {
            return
        }
        
        showNewLocationTextField(show: false)
        
        MBProgressHUD.showAdded(to: superview, animated: true)
        
        self.locationManager.getPlace(placeId: placeId) { (gmsPlace, error) in
            MBProgressHUD.hide(for: superview, animated: true)
            if let place = gmsPlace {
                // add location to realm
                let customerAddress = CustomerAddress()
                
                customerAddress.location = Location(name: selectedLocation.attributedFullText.string, latitude: nil, longitude: nil, location: place.coordinate)
                customerAddress.createdAt = Date()
                customerAddress.volvoCustomerId = self.user!.email
                
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(customerAddress)
                        
                        if let addresses = self.addresses {
                            self.addressesCount = addresses.count
                        }
                        self.onLocationAdded()
                        self.newLocationTextField.clearResults()
                        self.resetValues()
                        self.newLocationTextField.textField.resignFirstResponder()
                        self.selectIndex(selectedIndex: self.addressesCount - 1)
                    }
                }
                
                self.bottomButton.isEnabled = true
            }
        }
        VLAnalytics.logEventWithName(AnalyticsConstants.eventGmapsRequest, paramName: AnalyticsConstants.paramGMapsType, paramValue: AnalyticsConstants.paramNameGmapsPlace, screenName: screenName)
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
    
    func selectIndex(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        if self.selectedIndex > -1 {
            self.bottomButton.isEnabled = true
        }
    }
    
    func numberOfRows() -> Int {
        if self.currentLocationAddress != nil {
            return addressesCount + 1
        }
        return addressesCount
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        newLocationTextField.closeAutocomplete()
    }
    
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CheckmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckmarkCell.reuseId, for: indexPath) as! CheckmarkCell
        if let addresses = self.addresses, addressesCount > indexPath.row, let location = addresses[indexPath.row].location {
            cell.setTitle(title: location.getShortAddress() ?? "")
        } else if let _ = self.currentLocationAddress {
            cell.setTitle(title: .CurrentLocation)
        }
        cell.setChecked(checked: indexPath.row == selectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        VLAnalytics.logEventWithName(AnalyticsConstants.eventClickSelectLocationIndex, screenName: screenName, index: indexPath.row)
        selectIndex(selectedIndex: indexPath.row)
        tableView.reloadData()
    }
    
}

// MARK: protocol PickupLocationDelegate
protocol PickupLocationDelegate: VLPresentrViewDelegate {
    func onLocationSelected(customerAddress: CustomerAddress)
}