
//
//  ScheduleSelfDropModal.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 8/23/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class ScheduleSelfDropModal: VLPresentrViewController {
    
    weak var delegate: ScheduleSelfDropModalDelegate?
    
    let rescheduleLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .UnableToMeetDriver
        textView.font = .volvoSansProRegular(size: 14)
        textView.numberOfLines = 0
        textView.backgroundColor = .clear
        textView.textColor = .luxeDarkGray()
        textView.volvoProLineSpacing()
        return textView
    }()
    let rescheduleButton: VLButton
    
    let selfPickupLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .PreferPickup
        textView.font = .volvoSansProRegular(size: 14)
        textView.numberOfLines = 0
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.volvoProLineSpacing()
        return textView
    }()
    let selfPickupButton: VLButton
    
    init(title: String, screen: AnalyticsEnums.Name.Screen) {
        rescheduleButton = VLButton(type: .grayPrimary, title: (.RescheduleDelivery as String).uppercased(), kern: UILabel.uppercasedKern(), event: .scheduleDelivery, screen: screen)
        selfPickupButton = VLButton(type: .grayPrimary, title: (.SelfPickupAtDealership as String).uppercased(), kern: UILabel.uppercasedKern(), event: .scheduleDelivery, screen: screen)
        super.init(title: title, buttonTitle: "", screen: screen)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        bottomButton.isHidden = true
        
        containerView.addSubview(rescheduleLabel)
        containerView.addSubview(rescheduleButton)
        containerView.addSubview(selfPickupLabel)
        containerView.addSubview(selfPickupButton)

        selfPickupButton.snp.makeConstraints { make in
            make.bottom.left.right.top.height.equalTo(bottomButton)
        }
        
        selfPickupLabel.snp.makeConstraints { make in
            make.bottom.equalTo(selfPickupButton.snp.top).offset(-20)
            make.left.right.equalToSuperview()
        }
        
        rescheduleButton.snp.makeConstraints { make in
            make.bottom.equalTo(selfPickupLabel.snp.top).offset(-40)
            make.height.equalTo(VLButton.primaryHeight)
            make.left.right.equalToSuperview()
        }
        
        rescheduleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rescheduleButton.snp.top).offset(-20)
            make.left.right.equalToSuperview()
        }
        
        
    }
    
    override func height() -> Int {
        return baseHeight + 260
    }
    
    override func onButtonClick() {
    }
    
   
}

// MARK: protocol ScheduleSelfDropModalDelegate
protocol ScheduleSelfDropModalDelegate: VLPresentrViewDelegate {
    func onRescheduleSelected(loanerNeeded: Bool)
    func onSelfPickupSelected(loanerNeeded: Bool)
}
