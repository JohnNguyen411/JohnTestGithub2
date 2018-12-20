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
import SwiftEventBus


class LocationViewController: VLPresentrViewController, LocationManagerDelegate, UITextFieldDelegate, VLVerticalSearchTextFieldDelegate {
    
    private static let defaultTableViewGroupedTopInset: Int = 36
    private static let maxCount = 4
    private static let topInset: Int = 24

    private static let newLocationButtonHeight = 0
    private static let newLocationTextFieldHeight = VLVerticalTextField.height - 5

    var newLocationHeight = newLocationButtonHeight

    var user: Customer?
    
    var addresses: [CustomerAddress]?
    var addressesCount = 0
    var realm : Realm?
    
    var wasLocationEnabled = true
    
    weak var pickupLocationDelegate: PickupLocationDelegate?
    var locationManager = LocationManager.sharedInstance
    
    // current location == user current location
    var currentLocationAddress: GMSAddress?
    
    // selected Location == selected from autocomplete
    var selectedLocation: GMSAutocompletePrediction?
    
    // locations displayed in autocomplete
    var autocompletePredictions: [GMSAutocompletePrediction]?
    var autoCompleteCharacterCount = 0
    
    var currentLocationCell: CurrentLocationCellView?
    
    var selectedIndex = -2         // CurrentLocation == -1
    var preselectedIndex = -2     // Nothing selected == -2
    
    let newLocationButton: VLButton
    
    let newLocationTextField = VLVerticalSearchTextField(title: .AddressForPickup, placeholder: .AddressForPickupPlaceholder)
    let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
    
    override init(title: String, buttonTitle: String, screen: AnalyticsEnums.Name.Screen) {
        newLocationButton = VLButton(type: .blueSecondary, title: (.AddNewLocation as String).uppercased(), kern: UILabel.uppercasedKern(), event: .addNewLocation, screen: screen)
        super.init(title: title, buttonTitle: buttonTitle, screen: screen)
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
        if locationManager.isAuthorizationGranted() {
            wasLocationEnabled = true
            locationManager.startUpdatingLocation()
        } else {
            wasLocationEnabled = false
        }
        bottomButton.isEnabled = false
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CheckmarkCell.self, forCellReuseIdentifier: CheckmarkCell.reuseId)
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: CGFloat(-LocationViewController.topInset), left: 0, bottom: 0, right: 0);
        
        user = UserManager.sharedInstance.getCustomer()
        var selectedLocation = RequestedServiceManager.sharedInstance.getPickupLocation()
        if RequestedServiceManager.sharedInstance.getDropoffLocation() != nil {
            selectedLocation = RequestedServiceManager.sharedInstance.getDropoffLocation()
        }
        realm = try? Realm()
        var recentlySelectedAddress: CustomerAddress? = nil
        var recentlySelectedAddressIndex: Int = -2
        if let realm = self.realm, let user = user {
            addresses = realm.objects(CustomerAddress.self, predicate:"luxeCustomerId = \(user.id)", sortedByKeyPath: "createdAt")
            if let addresses = addresses {
                addressesCount = addresses.count
                for (index, address) in addresses.enumerated() {
                    self.onLocationAdded()
                    if let selectedLocation = selectedLocation, selectedLocation.id == address.location?.id {
                        preselectedIndex = index
                    } else if recentlySelectedAddress == nil {
                        recentlySelectedAddress = address
                        recentlySelectedAddressIndex = index
                    } else if let prevAddress = recentlySelectedAddress, let prevAddressUpdatedAt = prevAddress.updatedAt, let currentAddressUpdatedAt = address.updatedAt {
                        if prevAddressUpdatedAt.isEarlier(than: currentAddressUpdatedAt) {
                            recentlySelectedAddress = address
                            recentlySelectedAddressIndex = index
                        }
                    }
                }
                if addressesCount > 0 && preselectedIndex < -1 {
                    // select the last added location
                    if recentlySelectedAddressIndex > -2 {
                        preselectedIndex = recentlySelectedAddressIndex
                    } else {
                        preselectedIndex = -1
                    }
                }
            }
            // scroll to selected row
            tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.scrollToSelectedRow()
            })

        }
        
        newLocationButton.setActionBlock { [weak self] in
            self?.addNewLocationClicked()
        }
        
        if locationManager.authorizationStatus() == .notDetermined {
            if preselectedIndex < -1 {
                selectedIndex = -2
            }
            // Fake Adding location to make space for "Current Location" and ask for permission
            onLocationAdded()
        }
        
        // register to permission Changed
        SwiftEventBus.onMainThread(self, name: "onLocationPermissionStatusChanged") { result in
            self.onLocationPermissionStatusChanged()
        }
        
        showNewLocationTextField(show: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)

    }
    
    private func scrollToSelectedRow() {
        if preselectedIndex >= -1 {
            selectIndex(selectedIndex: preselectedIndex)
            if preselectedIndex > 0 && self.tableView.isScrollEnabled{
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.tableView.setContentOffset(CGPoint(x: 0, y: (CGFloat(self.preselectedIndex) * CheckmarkCell.height)), animated: true)
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func willEnterForeground() {
        if !wasLocationEnabled && locationManager.isAuthorizationGranted() {
            onLocationPermissionStatusChanged()
        }
    }
    
    func onLocationPermissionStatusChanged() {
        if locationManager.isAuthorizationGranted() {
            locationManager.startUpdatingLocation()
        }
        showNewLocationTextField(show: false)
        onLocationAdded()
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
        containerView.addSubview(newLocationTextField)
        containerView.addSubview(newLocationButton)
        
        newLocationTextField.isHidden = true
        
        newLocationTextField.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(VLVerticalTextField.height)
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
        
    }
    
    func tableViewHeight() -> Int {
        var viewHeight = 0
        if numberOfRows() + 1 > LocationViewController.maxCount {
            viewHeight = (LocationViewController.maxCount - 1) * Int(CheckmarkCell.height) + LocationViewController.topInset + CurrentLocationCellView.height + 1
            self.tableView.isScrollEnabled = true
        } else {
            viewHeight = numberOfRows() * Int(CheckmarkCell.height) + LocationViewController.topInset + CurrentLocationCellView.height + 1
            self.tableView.isScrollEnabled = false
        }
        
        if viewHeight <= Int(CheckmarkCell.height) {
            viewHeight = Int(CurrentLocationCellView.height) + LocationViewController.topInset + 1
        }
        
        return viewHeight
    }
    
    override func height() -> Int {
        return (tableViewHeight()) + baseHeight + newLocationHeight + 73
    }
    
    func autocompleteWithText(userText: String){
        selectedLocation = nil
        self.bottomButton.isEnabled = false
        weak var weakSelf = self
        if userText.count > 2 {
            self.locationManager.googlePlacesAutocomplete(address: self.newLocationTextField.text) {
                autocompletePredictions, error in

                Analytics.trackCallGoogle(endpoint: .places, error: error)

                guard let weakSelf = weakSelf else { return }
                if weakSelf.isBeingDismissed { return }
                
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
        } else {
            self.newLocationTextField.filteredStrings([])
        }
    }
    
    func locationFound(_ latitude: Double, longitude: Double) {
        
        weak var weakSelf = self
        
        locationManager.reverseGeocodeLocation(latitude: latitude, longitude: longitude) { (reverseGeocodeResponse, error) in
            Analytics.trackCallGoogle(endpoint: .geocode, error: error)
            if let weakSelf = weakSelf, let response = reverseGeocodeResponse, let address = response.firstResult() {
                
                weakSelf.currentLocationAddress = address
                
                Logger.print("Address found")
                Logger.print(weakSelf.currentLocationAddress?.thoroughfare ?? "")
                if let cell = self.currentLocationCell {
                    cell.setAddress(address: address)
                } else {
                    weakSelf.tableView.reloadData()
                }
                weakSelf.onLocationAdded()
                weakSelf.bottomButton.isEnabled = true
                
                if !weakSelf.wasLocationEnabled {
                    weakSelf.preselectedIndex = -1
                    self.wasLocationEnabled = true
                }
                
                if weakSelf.preselectedIndex > -1 {
                    weakSelf.selectIndex(selectedIndex: weakSelf.preselectedIndex)
                } else {
                    weakSelf.selectIndex(selectedIndex: -1)
                }
            }
        }
    }
    
    override func onButtonClick() {
        if let pickupLocationDelegate = pickupLocationDelegate {
            if self.currentLocationAddress != nil && selectedIndex == -1 {
                
                guard let currentLocationInfo = self.currentLocationAddress else { return }
                
                // add location to realm
                let addressString: String = currentLocationInfo.fullAddress()
                if let customerAddress = insertCustomerAddress(addressString: addressString) {
                    pickupLocationDelegate.onLocationSelected(customerAddress: customerAddress)
                }
            } else {
                if let addresses = addresses, selectedIndex > -1 && addresses.count > selectedIndex {
                    if let realm = self.realm {
                        let address = addresses[selectedIndex]
                        try? realm.write {
                            address.updatedAt = Date()
                            realm.add(address, update: true)
                        }
                    }
                    
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
        newLocationTextField.animateAlpha(show: show)
        newLocationButton.animateAlpha(show: !show)
        
        if show {
            tableView.snp.remakeConstraints { make in
                make.bottom.equalTo(newLocationTextField.snp.top).offset(-20)
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
        
        guard let autocompletePredictions = autocompletePredictions else { return }
        if selectedIndex > autocompletePredictions.count { return }
        
        selectedLocation = autocompletePredictions[selectedIndex]
        
        guard let selectedLocation = selectedLocation, let placeId = selectedLocation.placeID, let superview = self.view.superview else { return }
        
        showNewLocationTextField(show: false)
        
        MBProgressHUD.showAdded(to: superview, animated: true)
        
        self.locationManager.getPlace(placeId: placeId) { (gmsPlace, error) in
            Analytics.trackCallGoogle(endpoint: .places, error: error)
            MBProgressHUD.hide(for: superview, animated: true)
            if let place = gmsPlace {
                // add location to realm
                
                let customerAddress = CustomerAddress(id: selectedLocation.attributedFullText.string)
                customerAddress.location = Location(name: selectedLocation.attributedFullText.string, latitude: nil, longitude: nil, location: place.coordinate)
                customerAddress.createdAt = Date()
                customerAddress.updatedAt = Date()
                customerAddress.volvoCustomerId = self.user!.email
                customerAddress.luxeCustomerId = self.user!.id
                
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(customerAddress, update: true)
                        
                        if let addresses = self.addresses {
                            self.addressesCount = addresses.count
                        }
                        self.onLocationAdded()
                        self.newLocationTextField.clearResults()
                        self.resetValues()
                        self.newLocationTextField.textField.resignFirstResponder()
                        self.preselectedIndex = 0
                        self.selectIndex(selectedIndex: 0)
                        if self.tableView.isScrollEnabled {
                            self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                        }
                    }
                }
                
                self.bottomButton.isEnabled = true
            }
        }
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
        if self.selectedIndex >= -1 {
            self.bottomButton.isEnabled = true
            self.tableView.reloadData()
        }
    }
    
    func numberOfRows() -> Int {
        return addressesCount
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        newLocationTextField.closeAutocomplete()
    }
    
    private func indexOfCurrentAddress() -> Int {
        guard let addresses = self.addresses else { return -1 }
        guard let currentLocationInfo = self.currentLocationAddress else { return -1 }
        let currentLocationString = currentLocationInfo.fullAddress()
        
        for (index, address) in addresses.enumerated() {
            guard let location = address.location else { continue }
            if location.address == currentLocationString {
                return index
            }
        }
        
        return -1
    }
    
    private func selectOrAddCurrentAddress(addressString: String) {
        let index = indexOfCurrentAddress()
        if index > -1 {
            // select
            selectIndex(selectedIndex: index)
            tableView.reloadData()
        } else {
            let customerAddress = insertCustomerAddress(addressString: addressString)
            if customerAddress != nil {
                selectOrAddCurrentAddress(addressString: addressString)
            }
        }
    }
    
    private func insertCustomerAddress(addressString: String) -> CustomerAddress? {
        guard let currentLocationInfo = self.currentLocationAddress else { return nil}

        var customerAddress = CustomerAddress(id: addressString)
        
        customerAddress.location = Location(name: addressString, latitude: nil, longitude: nil, location: currentLocationInfo.coordinate)
        customerAddress.createdAt = Date()
        customerAddress.updatedAt = Date()
        customerAddress.volvoCustomerId = user!.email
        customerAddress.luxeCustomerId = user!.id
        
        if let realm = self.realm {
            // "email = %@", user.email ?? ""
            let existingAddress = realm.objects(CustomerAddress.self, predicate: "location.address = \(addressString) AND luxeCustomerId = \(user!.id)").first
            if existingAddress == nil {
                try? realm.write {
                    realm.add(customerAddress, update: true)
                    if let addresses = addresses {
                        addressesCount = addresses.count
                    }
                }
            } else {
                customerAddress = existingAddress!
            }
        }
        return customerAddress
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
            cell.setTitle(title: location.getMediumAddress() ?? "")
            cell.setChecked(checked: indexPath.row == selectedIndex)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Analytics.trackClick(button: .selectLocation, screen: self.screen)
        self.preselectedIndex = indexPath.row
        selectIndex(selectedIndex: indexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // show current location view
        currentLocationCell = CurrentLocationCellView(delegate: self)
        currentLocationCell!.setAddress(address: currentLocationAddress)
        currentLocationCell!.isLocationEnabled = (locationManager.authorizationStatus() == .authorizedAlways || locationManager.authorizationStatus() == .authorizedWhenInUse)
        currentLocationCell!.isChecked = selectedIndex == -1
        return currentLocationCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(CurrentLocationCellView.height)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension LocationViewController: CurrentLocationCellDelegate {
    
    func currentLocationClick() {
        if currentLocationAddress != nil {
            Analytics.trackClick(button: .selectLocation, screen: self.screen)
            self.preselectedIndex = -1
            self.selectIndex(selectedIndex: -1)
            self.tableView.reloadData()
        }
    }
    
    func requestPermissionLocationClick() {
        let locationManager = LocationManager.sharedInstance.locationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        Analytics.trackView(screen: .requestLocation)
    }
    
    func deniedPermissionClick() {
        self.showDialog(title: .LocationPermission, message: .PermissionLocationDenied, cancelButtonTitle: .Close, okButtonTitle: .OpenSettings, okCompletion: {
            let urlObj = NSURL.init(string:UIApplication.openSettingsURLString)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urlObj! as URL, options: [ : ], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(urlObj! as URL)
            }
        }, dialog: .locationPermissionDenied, screen: screen)
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let granted = status == .authorizedWhenInUse || status == .authorizedAlways
        Analytics.trackChangePermission(permission: .location, granted: granted, screen: self.screen)
        SwiftEventBus.post("onLocationPermissionStatusChanged")
    }
}

// MARK: protocol PickupLocationDelegate
protocol PickupLocationDelegate: VLPresentrViewDelegate {
    func onLocationSelected(customerAddress: CustomerAddress)
}
