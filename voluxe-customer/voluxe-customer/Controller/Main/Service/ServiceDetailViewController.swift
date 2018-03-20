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
    let label = UILabel(frame: .zero)
    let service: RepairOrderType
    let confirmButton = VLButton(type: .bluePrimary, title: (.ScheduleService as String).uppercased(), actionBlock: nil)

    init(service: RepairOrderType) {
        self.service = service
        serviceTitle = VLTitledLabel(title: .FactoryScheduledMaintenance, leftDescription: service.name!, rightDescription: "")
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.attributedText = toHtml(string: service.name!)
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
            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
        }
    }
    
    func toHtml(string: String) -> NSAttributedString {
        guard let data = string.data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
        
    }
}
