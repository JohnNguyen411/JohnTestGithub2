//
//  VehicleCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class VehicleCell: UICollectionViewCell {
    
    public static let VehicleCellHeight = 110
    public static let reuseId = "VehicleCell"

    var vehicleImageView: UIImageView
    
    override init(frame: CGRect) {
        vehicleImageView = UIImageView(frame: .zero)
        vehicleImageView.contentMode = .scaleAspectFit

        super.init(frame: frame)
        
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = .luxeLightestGray()
        selectedView.layer.cornerRadius = self.frame.size.height/2
        
        self.selectedBackgroundView = selectedView
        
        self.contentView.addSubview(vehicleImageView)
        
        setupViews()
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        vehicleImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(7)
            make.right.equalToSuperview().offset(-7)
            make.centerY.equalToSuperview()
            make.height.equalTo(90)
        }
    }
    
    public func setVehicle(vehicle: Vehicle) {
        vehicle.setVehicleImage(imageView: vehicleImageView)
    }
    
    
}
