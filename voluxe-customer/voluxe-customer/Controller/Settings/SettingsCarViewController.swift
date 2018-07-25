//
//  SettingsCarViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift
import MBProgressHUD

class SettingsCarViewController: BaseViewController {
    
    var realm : Realm?
    
    let removeVehicleButton: VLButton
    let vehicleImageView = UIImageView(frame: .zero)
    let vehicleTypeView = VLTitledLabel(title: .VolvoYearModel, leftDescription: "", rightDescription: "")
    let vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        removeVehicleButton = VLButton(type: .orangePrimary, title: (.RemoveVehicle as String).uppercased(), kern: UILabel.uppercasedKern(), event: .removeVehicle, screen: .vehicleDetail)
        super.init(screen: .vehicleDetail)
        
        realm = try? Realm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = vehicle.vehicleDescription()
        
        vehicleImageView.contentMode = .scaleAspectFit
        vehicleTypeView.setLeftDescription(leftDescription: vehicle.vehicleDescription())
        vehicle.setVehicleImage(imageView: vehicleImageView)
        
        
        removeVehicleButton.setActionBlock { [weak self] in
            self?.removeVehicleAlert()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        let contentView = UIView(frame: .zero)
        
        self.view.addSubview(contentView)
        contentView.addSubview(vehicleTypeView)
        contentView.addSubview(vehicleImageView)
        contentView.addSubview(removeVehicleButton)
        
        vehicleTypeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleTypeView.snp.bottom)
            make.height.equalTo(Vehicle.vehicleImageHeight)
        }
        
        removeVehicleButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        contentView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self.view, edges: UIEdgeInsetsMake(10, 20, 20, 20))
        }
    }
    
    private func removeVehicleAlert() {
        self.showDestructiveDialog(title: .RemoveVehicle,
                                   message: .RemoveVehicleConfirmation,
                                   cancelButtonTitle: .Cancel,
                                   destructiveButtonTitle: .Remove,
                                   destructiveCompletion: { [weak self] in self?.removeVehicle() },
                                   dialog: .vehicleDelete,
                                   screen: self.screen)
    }
    
    private func removeVehicle() {
        
        guard let customerId = UserManager.sharedInstance.customerId() else { return }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        weak var weakSelf = self
        CustomerAPI().deleteVehicle(customerId: customerId, vehicleId: vehicle.id).onSuccess { result in
            if let customerId = UserManager.sharedInstance.customerId() {
                weakSelf?.callVehicles(customerId: customerId)
            }
            }.onFailure { error in
                weakSelf?.deleteVehicleFailed()
        }
    }
    
    private func deleteVehicleFailed() {
        MBProgressHUD.hide(for: self.view, animated: true)
        showOkDialog(title: .Error, message: .GenericError, dialog: .error, screen: self.screen)
    }
    
    
    private func callVehicles(customerId: Int) {
        
        weak var weakSelf = self
        CustomerAPI().getVehicles(customerId: customerId).onSuccess { result in
            if let cars = result?.data?.result {
                if let realm = weakSelf?.realm {
                    try? realm.write {
                        realm.add(cars, update: true)
                    }
                }
                if let view = weakSelf?.view {
                    MBProgressHUD.hide(for: view, animated: true)
                }
                if cars.count == 0 {
                    FTUEStartViewController.flowType = .login
                    AppController.sharedInstance.showAddVehicleScreen()
                } else {
                    UserManager.sharedInstance.setVehicles(vehicles: cars)
                    weakSelf?.navigationController?.popViewController(animated: true)
                }
            }
            }.onFailure { error in
                weakSelf?.retrieveVehiclesFailed()
        }
    }
    
    private func retrieveVehiclesFailed() {
        MBProgressHUD.hide(for: self.view, animated: true)
        AppController.sharedInstance.startApp()
    }
}
