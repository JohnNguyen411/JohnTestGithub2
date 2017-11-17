//
//  DealershipPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class DealershipPickupViewController: VLPresentrViewController {
    
    var delegate: PickupDealershipDelegate?
    
    static let dealerships: [Dealership] = [Dealership(name: "Volvo of San Francisco"), Dealership(name: "Marin Volvo"), Dealership(name: "Volvo Centrum"),
                                     Dealership(name: "Volvo of Burlingame")]
    
    var groupedLabels: VLGroupedLabels?
    
    override init() {
        var selectedDealership: String? = nil
        if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
            selectedDealership = dealership.name!
        }
        
        var selectedIndex = -1
        var items: [String] = []
        for (index, dealership) in DealershipPickupViewController.dealerships.enumerated() {
            items.append(dealership.name!)
            if dealership.name == selectedDealership {
                selectedIndex = index
            }
        }
        
        groupedLabels = VLGroupedLabels(items: items, singleChoice: true, topBottomSeparator: true)
        if selectedIndex > -1 {
            groupedLabels?.select(selectedIndex: selectedIndex, selected: true)
        }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        if let groupedLabels = groupedLabels {
            containerView.addSubview(groupedLabels)
            
            groupedLabels.snp.makeConstraints { make in
                make.bottom.equalTo(bottomButton.snp.top).offset(-30)
                make.left.right.equalToSuperview()
                make.height.equalTo(groupedLabels.items.count * VLSelectableLabel.height)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(groupedLabels.snp.top).offset(-10)
                make.height.equalTo(25)
            }
        }
    }
    
    override func height() -> Int {
        if let groupedLabels = groupedLabels {
            return (groupedLabels.items.count * VLSelectableLabel.height) + VLPresentrViewController.baseHeight + 60
        }
        return VLPresentrViewController.baseHeight + 60
        
    }
    
    override func onButtonClick() {
        if let delegate = delegate, let groupedLabels = groupedLabels {
            delegate.onDealershipSelected(dealership: DealershipPickupViewController.dealerships[groupedLabels.getLastSelectedIndex()!])
        }
    }
}

// MARK: protocol PickupDealershipDelegate
protocol PickupDealershipDelegate: class {
    func onDealershipSelected(dealership: Dealership)
}

