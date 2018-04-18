//
//  SettingsCarViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsCarViewController: BaseViewController {
    
    let removeVehicleButton = VLButton(type: .orangePrimary, title: (.RemoveVehicle as String).uppercased(), kern: UILabel.uppercasedKern(), actionBlock: nil)
    let vehicleImageView = UIImageView(frame: .zero)
    let vehicleTypeView = VLTitledLabel(title: .VolvoYearModel, leftDescription: "", rightDescription: "")
    let vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        super.init()
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
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleTypeView.snp.bottom).offset(40)
            make.height.equalTo(100)
        }
        
        removeVehicleButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 20, 20, 20))
        }        
    }
    
}
