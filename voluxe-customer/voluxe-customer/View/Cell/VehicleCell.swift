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
        
        self.contentView.addSubview(vehicleImageView)
        
        setupViews()
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Note that the priorities for the image view edges are purposefully
    // lowered to account for the parent cell resizing to zero, typically
    // when the parent collection view is hidden.  This prevents an
    // AutoLayout warning.
    private func setupViews() {
        vehicleImageView.snp.makeConstraints {
            make in
            let insets = UIEdgeInsets(top: 10, left: 7, bottom: 10, right: 7)
            make.edges.equalToSuperview().inset(insets).priority(.high)
        }
    }

    public func setVehicle(vehicle: Vehicle) {
        vehicle.setVehicleImage(imageView: vehicleImageView)
    }
    
 
    override func layoutSubviews() {
        let selectedView = UIView(frame: .zero)
        selectedView.backgroundColor = .luxeLightestGray()
        selectedView.layer.cornerRadius = self.frame.size.height/2
        
        self.selectedBackgroundView = selectedView
        super.layoutSubviews()
        
    }
    
}
