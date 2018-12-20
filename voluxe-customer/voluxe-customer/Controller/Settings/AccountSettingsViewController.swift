//
//  AccountSettingsViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift
import MBProgressHUD
import libPhoneNumber_iOS
import FlagPhoneNumber

class AccountSettingsViewController: BaseViewController, AddLocationDelegate {
    
    let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
    let user: Customer?
    var addresses: [CustomerAddress]?
    var addressesCount = 0
    var realm : Realm?
    var uiBarButton: UIBarButtonItem?
    
    init() {
        user = UserManager.sharedInstance.getCustomer()
        realm = try? Realm()
        if let realm = self.realm, let user = user {
            addresses = realm.objects(CustomerAddress.self, predicate: "luxeCustomerId = \(user.id)")
            if let addresses = addresses {
                addressesCount = addresses.count
            }
        }
        super.init(screen: .account)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = .YourAccount
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdIndicator)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdToogle)

        self.navigationItem.rightBarButtonItem?.title = .Edit
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
        }
    }
    
    func getTitleForSection(section: Int) -> String {
        if section == 0 {
            return .PickupDeliveryLocations
        } else if section == 1 {
            return .ContactInformation
        } else {
            return .AccountPassword
        }
    }
    
    func getTextForIndexPath(indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            if let addresses = addresses, addressesCount > indexPath.row {
                return (addresses[indexPath.row].location?.getShortAddress())!
            }
            return .AddNewLocation
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return "\(user?.firstName ?? "") \(user?.lastName ?? "")"
            } else if indexPath.row == 1 {
                return (user?.email)!
            } else {
                if let phoneNumber = user?.phoneNumber, let phoneNumberUtil = NBPhoneNumberUtil.sharedInstance() {
                    let code = phoneNumberUtil.extractCountryCode(phoneNumber, nationalNumber: nil)
                    let region = phoneNumberUtil.getRegionCode(forCountryCode: code)
                    
                    do {
                        let formattedPhoneNumber = try phoneNumberUtil.parse(phoneNumber, defaultRegion: region)
                        return try phoneNumberUtil.format(inOriginalFormat: formattedPhoneNumber, regionCallingFrom: region)
                    } catch {
                        return (user?.phoneNumber) ?? ""
                    }
                }
                return (user?.phoneNumber) ?? ""
            }
            
        } else {
            return "********"
        }
    }

    override func onRightClicked() {
        self.tableView.isEditing ? self.done() : self.edit()
    }
    
    private func edit() {
        Analytics.trackClick(navigation: .edit, screen: self.screen)
        self.navigationItem.rightBarButtonItem?.title = .Done
        tableView.setEditing(true, animated: true)
    }
    
    private func done() {
        Analytics.trackClick(navigation: .done, screen: self.screen)
        self.navigationItem.rightBarButtonItem?.title = .Edit
        tableView.setEditing(false, animated: true)
    }
    
    func showPickupLocationModal(dismissOnTap: Bool) {
        let locationVC = AddLocationViewController()
        locationVC.pickupLocationDelegate = self
        locationVC.presentrDelegate = self
        locationVC.view.accessibilityIdentifier = "locationVC"
        currentPresentrVC = locationVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {
            locationVC.newLocationTextField.closeAutocomplete()
        })
    }
    
    func onLocationAdded(location: Location?, placeId: String) {
        let customerAddress = CustomerAddress(id: location?.address)
        customerAddress.location = location
        customerAddress.createdAt = Date()
        customerAddress.updatedAt = Date()
        customerAddress.volvoCustomerId = user!.email
        customerAddress.luxeCustomerId = user!.id
        
        if let realm = self.realm {
            try? realm.write {
                realm.add(customerAddress, update: true)
                if let addresses = addresses {
                    addressesCount = addresses.count
                }
                tableView.reloadData()
            }
        }
        
        currentPresentrVC?.dismiss(animated: true, completion: nil)
    }
    
    func resetPassword() {
        showProgressHUD()
        if let customerId = UserManager.sharedInstance.customerId() {
            CustomerAPI.requestPasswordChange(customerId: customerId) { error in
                if error != nil {
                    self.showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
                    self.hideProgressHUD()
                } else {
                    FTUEStartViewController.flowType = .signup
                    self.pushViewController(FTUEPhoneVerificationViewController(), animated: true)
                    self.hideProgressHUD()
                }
            }
        }
    }
    
    override func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        if let locationVC = currentPresentrVC as? AddLocationViewController {
            locationVC.newLocationTextField.closeAutocomplete()
        }
        return super.presentrShouldDismiss(keyboardShowing: keyboardShowing)
    }
    
}

extension AccountSettingsViewController: UITableViewDataSource, UITableViewDelegate, SettingsCellProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // need at least one for "Add a New Volvo"
            if let addresses = addresses {
                return addresses.count + 1
            }
            return 1
        } else if section == 1 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CheckmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdIndicator, for: indexPath) as! SettingsCell
        var leftImage: String? = nil
        var editImage: String? = nil
        
        var text = getTextForIndexPath(indexPath: indexPath)
        
        if indexPath.section == 0 && indexPath.row >= addressesCount {
            cell.setCellType(type: .button)
            text = text.uppercased()
        } else {
            if indexPath.section == 0 {
                editImage = "remove"
            } else if indexPath.section == 1 {
                editImage = "edit"
                if indexPath.row == 0 {
                    leftImage = "user_shape"
                } else if indexPath.row == 1 {
                    leftImage = "message"
                } else {
                    leftImage = "phone"
                }
            } else if indexPath.section == 2 {
                editImage = "edit"
            }
            cell.setCellType(type: .none)
        }
        
        cell.setText(text: text, leftImageName: leftImage, editImageName: editImage)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0 && indexPath.row >= addressesCount) {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CheckmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SettingsCell.height))
        view.backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SettingsCell.height))
        label.font = .volvoSansProMedium(size: 13)
        label.textColor = UIColor.luxeGray()
        label.text = getTitleForSection(section: section).uppercased()
        label.addUppercasedCharacterSpacing()
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 0 && indexPath.row >= addressesCount) {
            Analytics.trackClick(button: .addNewLocation, screen: self.screen)
            showPickupLocationModal(dismissOnTap: true)
        }
    }
    
    func switchChanged(_ cell: UITableViewCell) {}
    
    func onEditClicked(_ cell: UITableViewCell) {

        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if indexPath.section == 0 {
            Analytics.trackClick(button: .settingsDeleteAddress, screen: self.screen)
            self.showDestructiveDialog(title: .Confirm,
                                       message: String(format: .AreYouSureDeleteAddress, self.getTextForIndexPath(indexPath: indexPath)),
                                       cancelButtonTitle: .Cancel,
                                       destructiveButtonTitle: .Delete,
                                       destructiveCompletion: { self.deleteAddressAtIndexPath(indexPath) },
                                       dialog: .confirm,
                                       screen: self.screen)
        }

        else if indexPath.section == 2 {
            Analytics.trackClick(button: .settingsEditPassword, screen: self.screen)
            self.resetPassword()
        }

        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                // edit name
                Analytics.trackClick(button: .settingsEditName, screen: self.screen)
                self.pushViewController(FTUESignupNameViewController(), animated: true)
            } else if indexPath.row == 1 {
                // edit email
                Analytics.trackClick(button: .settingsEditEmail, screen: self.screen)
                self.pushViewController(EditEmailViewController(), animated: true)
            } else if indexPath.row == 2 {
                // edit phone
                Analytics.trackClick(button: .settingsEditPhone, screen: self.screen)
                self.pushViewController(FTUEPhoneNumberViewController(type: .update), animated: true)
            }
        }
    }
    
    
    private func deleteAddressAtIndexPath(_ indexPath: IndexPath) {
        Analytics.trackClick(button: .settingsDeleteAddress, screen: self.screen)
        if let realm = self.realm, let addresses = self.addresses {
            try? realm.write {
                realm.deleteFirst(CustomerAddress.self, predicate: "id = \(addresses[indexPath.row].id)")
                //realm.delete(addresses[indexPath.row])
                self.addressesCount = addresses.count
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}
