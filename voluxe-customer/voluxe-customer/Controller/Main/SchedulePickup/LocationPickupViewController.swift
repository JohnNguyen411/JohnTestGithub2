//
//  LocationPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class LocationPickupViewController: VLPresentrViewController {
    
    var pickupLocationDelegate: PickupLocationDelegate?
    
    let newLocationLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.text = (.AddNewLocation as String).uppercased()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let newLocationTextField = VLVerticalTextField(title: .AddressForPickup, placeholder: .AddressForPickupPlaceholder)
    let groupedLabels = VLGroupedLabels(singleChoice: true, topBottomSeparator: true)
    
    override init() {
        super.init()
        newLocationTextField.setRightButtonText(rightButtonText: (.Add as String).uppercased())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        containerView.addSubview(groupedLabels)
        containerView.addSubview(newLocationLabel)
        containerView.addSubview(newLocationTextField)
        
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

        groupedLabels.snp.makeConstraints { make in
            make.bottom.equalTo(newLocationLabel.snp.top).offset(-20)
            make.left.right.equalToSuperview()
            make.height.equalTo(groupedLabels.items.count * VLSelectableLabel.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(groupedLabels.snp.top).offset(-10)
            make.height.equalTo(25)
        }
    }
    
    override func height() -> Int {
        return (groupedLabels.items.count * VLSelectableLabel.height) + VLPresentrViewController.baseHeight + VLVerticalTextField.height + 90
    }
    
}

// MARK: protocol VLGroupedLabelsDelegate
protocol PickupLocationDelegate: class {
    func onLocationAdded(newSize: Int)
}
