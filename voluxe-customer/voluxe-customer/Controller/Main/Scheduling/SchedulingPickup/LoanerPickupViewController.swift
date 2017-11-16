//
//  LoanerPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class LoanerPickupViewController: VLPresentrViewController {
    
    var delegate: PickupLoanerDelegate?
    
    let groupedLabels = VLGroupedLabels(items: [.Yes, .No], singleChoice: true, topBottomSeparator: true)
    
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
            let index = groupedLabels.getLastSelectedIndex()
            delegate.onLoanerSelected(loanerNeeded: index == 0 ? true : false)
        }
    }
    
}

// MARK: protocol PickupDealershipDelegate
protocol PickupLoanerDelegate: class {
    func onLoanerSelected(loanerNeeded: Bool)
}
