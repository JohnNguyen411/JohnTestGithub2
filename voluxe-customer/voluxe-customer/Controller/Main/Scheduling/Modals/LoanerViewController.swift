//
//  LoanerViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/8/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class LoanerViewController: VLPresentrViewController, VLGroupedLabelsDelegate {
    
    weak var delegate: PickupLoanerDelegate?
    
    let groupedLabels = VLGroupedLabels(items: [.Yes, .No], singleChoice: true, selectDefault: false, topBottomSeparator: true)
    
    override func setupViews() {
        super.setupViews()
        
        groupedLabels.delegate = self
        containerView.addSubview(groupedLabels)
        
        groupedLabels.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(groupedLabels.items.count * VLSelectableLabel.height)
        }
        
        
        if let loaner = RequestedServiceManager.sharedInstance.getLoaner() {
            groupedLabels.select(selectedIndex: loaner ? 0 : 1, selected: true)
        } else {
            bottomButton.isEnabled = false
        }
    }
    
    override func height() -> Int {
        return (groupedLabels.items.count * VLSelectableLabel.height) + baseHeight + 60
    }
    
    override func onButtonClick() {
        if let delegate = delegate {
            let index = groupedLabels.getLastSelectedIndex()
            delegate.onLoanerSelected(loanerNeeded: index == 0 ? true : false)
        }
    }
    
    func onSelectionChanged(selected: Bool, selectedIndex: Int) {
        bottomButton.isEnabled = true
        Analytics.trackClick(button: .selectLoaner, screen: self.screen, selected: selected)
    }
}

// MARK: protocol PickupDealershipDelegate
protocol PickupLoanerDelegate: VLPresentrViewDelegate {
    func onLoanerSelected(loanerNeeded: Bool)
}
