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
    
    let groupedLabels = VLGroupedLabels(items: ["Marin Volvo", "Volvo of San Francisco", "Volvo Centrum", "Volvo of Burlingame"], singleChoice: true, topBottomSeparator: true)
    
    override func setupViews() {
        super.setupViews()
        
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
    
    override func height() -> Int {
        return (groupedLabels.items.count * VLSelectableLabel.height) + VLPresentrViewController.baseHeight + 60
    }
    
    override func onButtonClick() {
        if let delegate = delegate {
            delegate.onDealershipSelected(dealership: groupedLabels.items[groupedLabels.getLastSelectedIndex()!])
        }
    }
}

// MARK: protocol PickupDealershipDelegate
protocol PickupDealershipDelegate: class {
    func onDealershipSelected(dealership: String)
}

