//
//  VehiclesViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/31/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import CoreLocation
import RealmSwift
import BrightFutures
import Alamofire


class VehiclesViewController: ChildViewController {

    var serviceState: ServiceState
    var vehicles: [Vehicle]?

    let vehicleCollectionView = UICollectionView(frame: .zero)
    let vehicleTypeView = VLTitledLabel(title: .VolvoYearModel, leftDescription: "", rightDescription: "")
    let vehicleImageView = UIImageView(frame: .zero)
    let vehicleMileageView = VLTitledLabel(title: .Mileage, leftDescription: "", rightDescription: "")
    let preferedDealershipView = VLTitledLabel(title: .PreferredDealership, leftDescription: "", rightDescription: "")
    let scheduledServiceView = VLTitledLabel()
    let contentView = UIView(frame: .zero)
    let confirmButton = VLButton(type: .BluePrimary, title: (.Ok as String).uppercased(), actionBlock: nil)

    //MARK: Lifecycle methods
    init(state: ServiceState) {
        self.serviceState = state
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.setActionBlock {
            self.confirmButtonClick()
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: VehicleCell.VehicleCellHeight, height: VehicleCell.VehicleCellHeight)
        
        vehicleCollectionView.setCollectionViewLayout(layout, animated: false)
        vehicleCollectionView.register(VehicleCell.self, forCellWithReuseIdentifier: VehicleCell.reuseId)

        vehicleCollectionView.delegate = self
        vehicleCollectionView.dataSource = self
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(contentView)
        
        contentView.addSubview(vehicleCollectionView)
        contentView.addSubview(vehicleTypeView)
        contentView.addSubview(vehicleImageView)
        contentView.addSubview(vehicleMileageView)
        contentView.addSubview(preferedDealershipView)
        contentView.addSubview(scheduledServiceView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(20, 20, 20, 20))
        }
        
        vehicleCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        vehicleTypeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleCollectionView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleCollectionView.snp.bottom).offset(20)
            make.height.equalTo(100)
        }
        
        vehicleMileageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        preferedDealershipView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleMileageView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        scheduledServiceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(preferedDealershipView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
    }
    
    func showVehicles(vehicles: [Vehicle]) {
        if vehicles.count > 1 {
            vehicleCollectionView.snp.updateConstraints { make in
                make.height.equalTo(100)
            }
        } else {
            vehicleCollectionView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            selectVehicle(vehicle: vehicles[0])
        }
    }
    
    func selectVehicle(vehicle: Vehicle) {
        vehicleTypeView.setLeftDescription(leftDescription: vehicle.vehicleDescription())
        vehicleMileageView.setLeftDescription(leftDescription: String.intToStringDecimal(largeNumber: vehicle.mileage()))
        vehicleImageView.image = UIImage(named: "image_auto")
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        // check if service scheduled
        
        //todo: check service for vehicle
        if RequestedServiceManager.sharedInstance.getBooking() != nil {
            scheduledServiceView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        } else {
            scheduledServiceView.snp.updateConstraints { make in
                make.height.equalTo(100)
            }
        }
        
    }
    
    //MARK: Actions methods
    func confirmButtonClick() {
    }
    
}

extension VehiclesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleCell.reuseId, for: indexPath) as! VehicleCell
        cell.setVehicle(vehicle: vehicles![indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let vehicles = vehicles {
            return vehicles.count
        }
        return 0
    }
    
}
