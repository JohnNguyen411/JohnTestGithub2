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

class AccountSettingsViewController: BaseViewController, AddLocationDelegate {
    
    let tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
    let user: Customer?
    var addresses: Results<CustomerAddress>?
    var addressesCount = 0
    var realm : Realm?
    var uiBarButton: UIBarButtonItem?
    
    override init() {
        user = UserManager.sharedInstance.getCustomer()
        realm = try? Realm()
        if let realm = self.realm, let user = user {
            addresses = realm.objects(CustomerAddress.self).filter("volvoCustomerId = %@", user.email ?? "")
            if let addresses = addresses {
                addressesCount = addresses.count
            }
        }
        super.init()
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
        
        uiBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = uiBarButton
        
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
                return (addresses[indexPath.row].location?.address)!
            }
            return .AddNewLocation
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return (user?.email)!
            } else {
                return (user?.phoneNumber)!
            }
            
        } else {
            return "********"
        }
    }
    
    @objc func edit() {
        uiBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = uiBarButton
        tableView.setEditing(true, animated: true)
    }
    
    @objc func done() {
        uiBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = uiBarButton
        tableView.setEditing(false, animated: true)
    }
    
    func showPickupLocationModal(dismissOnTap: Bool) {
        let locationVC = AddLocationViewController(title: .AddNewLocation, buttonTitle: .Add)
        locationVC.pickupLocationDelegate = self
        locationVC.view.accessibilityIdentifier = "locationVC"
        currentPresentrVC = locationVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {
            locationVC.newLocationTextField.closeAutocomplete()
        })
    }
    
    func onLocationAdded(responseInfo: NSDictionary?, placemark: CLPlacemark?) {
        let customerAddress = CustomerAddress()
        
        customerAddress.location = Location(name: responseInfo!.value(forKey: "formattedAddress") as? String, latitude: nil, longitude: nil, location: placemark?.location?.coordinate)
        customerAddress.createdAt = Date()
        customerAddress.volvoCustomerId = user!.email
        
        if let realm = self.realm {
            try? realm.write {
                realm.add(customerAddress)
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
        if let customerId = UserManager.sharedInstance.getCustomerId() {
            CustomerAPI().requestPasswordChange(customerId: customerId).onSuccess { response in
                if let _ = response?.error {
                    // show error
                    self.showOkDialog(title: .Error, message: .GenericError)
                } else {
                    FTUEStartViewController.flowType = .signup
                    self.navigationController?.pushViewController(FTUEPhoneVerificationViewController(), animated: true)
                }
                self.hideProgressHUD()
                }.onFailure { error in
                    self.showOkDialog(title: .Error, message: .GenericError)
                    self.hideProgressHUD()
            }
        }
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
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ServiceCell.height
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
                editImage = "edit"
            } else if indexPath.section == 1 {
                editImage = "edit"
                if indexPath.row == 0 {
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0 && indexPath.row < addressesCount {
            let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
                if let realm = self.realm, let addresses = self.addresses {
                    try? realm.write {
                        realm.delete(addresses[indexPath.row])
                        self.addressesCount = addresses.count
                    }
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
            })
            return [delete]
            
        } else if indexPath.section == 1 || indexPath.section == 2 {
            let edit = UITableViewRowAction(style: .normal, title: .Edit) { (action, indexPath) in
                // edit item at indexPath
                if indexPath.section == 2 {
                    // pwd
                    self.navigationController?.pushViewController(FTUESignupPasswordViewController(), animated: true)
                } else if indexPath.section == 1 || indexPath.row == 1 {
                    // update phone number
                    self.navigationController?.pushViewController(FTUEPhoneNumberViewController(type: .update), animated: true)
                }
            }
            return [edit]
        }
        
        return []
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ServiceCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SettingsCell.height))
        view.backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SettingsCell.height))
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.luxeGray()
        label.text = getTitleForSection(section: section).uppercased()
        label.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 0 && indexPath.row >= addressesCount) {
            showPickupLocationModal(dismissOnTap: true)
        }
    }
    
    func switchChanged(_ cell: UITableViewCell) {}
    
    func onEditClicked(_ cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 0 {
                if let realm = self.realm, let addresses = self.addresses {
                    try? realm.write {
                        realm.delete(addresses[indexPath.row])
                        self.addressesCount = addresses.count
                    }
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            } else if indexPath.section == 2 {
                // pwd
                self.resetPassword()
            } else if indexPath.section == 1 || indexPath.row == 1 {
                // update phone number
                self.pushViewController(FTUEPhoneNumberViewController(type: .update), animated: true, backLabel: .Back)
            }
        }
    }
    
    
    
}
