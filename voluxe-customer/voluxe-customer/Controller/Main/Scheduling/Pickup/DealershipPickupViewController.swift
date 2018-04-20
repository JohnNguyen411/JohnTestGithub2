//
//  DealershipPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class DealershipPickupViewController: VLPresentrViewController, VLGroupedLabelsDelegate {
    
    var delegate: PickupDealershipDelegate?
    
    var dealerships: [Dealership] = []
    
    var groupedLabels: VLGroupedLabels?
    
    init(title: String, buttonTitle: String, dealerships: [Dealership]) {
        super.init(title: title, buttonTitle: buttonTitle, screenName: AnalyticsConstants.paramNameSchedulingIBDealershipModalView)
        setDealerhips(dealerships: dealerships)
    }
    
    private func setDealerhips(dealerships: [Dealership]) {
        self.dealerships = dealerships

        var selectedDealership: String? = nil
        if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
            if let dealershipName = dealership.name {
                selectedDealership = dealershipName
            }
        }
        
        var selectedIndex = -1
        var items: [String] = []
        for (index, dealership) in dealerships.enumerated() {
            if let dealershipName = dealership.name {
                items.append(dealershipName)
                if let selectedDealership = selectedDealership, dealership.name == selectedDealership {
                    selectedIndex = index
                }
            }
        }
        
        groupedLabels = VLGroupedLabels(items: items, singleChoice: true, selectDefault: true, topBottomSeparator: true)
        if selectedIndex > -1 {
            groupedLabels?.select(selectedIndex: selectedIndex, selected: true)
        }
        
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
            groupedLabels.delegate = self
        }
        
        containerView.snp.updateConstraints{ make in
            make.height.equalTo(height())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func height() -> Int {
        if let groupedLabels = groupedLabels {
            return (groupedLabels.items.count * VLSelectableLabel.height) + VLPresentrViewController.baseHeight + 60
        }
        return VLPresentrViewController.baseHeight + 60
        
    }
    
    override func onButtonClick() {
        if let delegate = delegate, let groupedLabels = groupedLabels {
            delegate.onDealershipSelected(dealership: dealerships[groupedLabels.getLastSelectedIndex()!])
        }
    }
    
    func onSelectionChanged(selected: Bool, selectedIndex: Int) {
        if selected {
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickSelectDealershipIndex, screenName: screenName, index: selectedIndex)
        }
    }
}

// MARK: protocol PickupDealershipDelegate
protocol PickupDealershipDelegate: VLPresentrViewDelegate {
    func onDealershipSelected(dealership: Dealership)
}

