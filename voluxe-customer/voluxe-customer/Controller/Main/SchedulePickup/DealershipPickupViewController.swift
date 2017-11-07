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

    let groupedLabels = VLGroupedLabels(items: ["Marin Volvo", "Volvo of San Francisco", "Volvo Centrum", "Volvo of Burlingame"], singleChoice: true)
    
    override func setupViews() {
        super.setupViews()
        containerView.addSubview(groupedLabels)
        
        groupedLabels.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(groupedLabels.items.count * VLSelectableLabel.height)
        }
    }
    override func height() -> Int {
        return (groupedLabels.items.count * VLSelectableLabel.height) + VLPresentrViewController.baseHeight
    }
    
}

