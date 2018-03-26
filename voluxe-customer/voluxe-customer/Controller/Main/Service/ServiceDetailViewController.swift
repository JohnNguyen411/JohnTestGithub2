//
//  ServiceDetailViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

class ServiceDetailViewController: BaseViewController {
    
    let serviceTitle: VLTitledLabel
    let label: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansLight(size: 16)
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    var canSchedule = true
    let service: RepairOrderType
    let confirmButton = VLButton(type: .bluePrimary, title: (.ScheduleService as String).uppercased(), actionBlock: nil)

    init(service: RepairOrderType, canSchedule: Bool) {
        self.canSchedule = canSchedule
        self.service = service
        serviceTitle = VLTitledLabel(title: .FactoryScheduledMaintenance, leftDescription: service.name!, rightDescription: "")
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.setHTMLFromString(text: service.desc)
        label.sizeToFit()
        
        if !canSchedule || RequestedServiceManager.sharedInstance.getRepairOrder() != nil{
            confirmButton.isEnabled = false
            confirmButton.alpha = 0
        }
        
        confirmButton.setActionBlock {
            // shedule service
            RequestedServiceManager.sharedInstance.setRepairOrder(repairOrder: RepairOrder(repairOrderType: self.service))
            StateServiceManager.sharedInstance.updateState(state: .needService)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(serviceTitle)
        self.view.addSubview(label)
        self.view.addSubview(confirmButton)
        
        serviceTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.right.left.equalTo(serviceTitle)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        label.snp.makeConstraints { make in
            make.right.left.equalTo(serviceTitle)
            make.top.equalTo(serviceTitle.snp.bottom).offset(20)
        }
    }
}
