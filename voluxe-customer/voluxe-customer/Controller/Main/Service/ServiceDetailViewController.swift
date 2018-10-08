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
    
    let isDrivableLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .volvoSansProRegular(size: 14)
        label.backgroundColor = .clear
        return label
    }()
    
    let label: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = .volvoSansProRegular(size: 14)
        textView.backgroundColor = .clear
        textView.isEditable = false
        return textView
    }()
    
    var canSchedule = true
    
    var repairOrder: RepairOrder?
    let vehicle: Vehicle
    let service: RepairOrderType
    let confirmButton: VLButton

    convenience init(vehicle: Vehicle, service: RepairOrder) {
        self.init(vehicle: vehicle, service: service.repairOrderType!, canSchedule: false)
        self.repairOrder = service
    }
    
    init(vehicle: Vehicle, service: RepairOrderType, canSchedule: Bool) {
        self.vehicle = vehicle
        self.canSchedule = canSchedule
        self.service = service
        serviceTitle = VLTitledLabel(title: .viewScheduleServiceTypeMilestoneDetailNameLabel, leftDescription: service.name!, rightDescription: "")
        serviceTitle.descLeftLabel.numberOfLines = 2
        serviceTitle.descLeftLabel.volvoProLineSpacing()
        
        var analyticName: AnalyticsEnums.Name.Screen = canSchedule ? .serviceMilestoneDateTime : .serviceMilestoneDetail
        if let repairOrder = repairOrder, let repairOrderType = repairOrder.repairOrderType, repairOrderType.getCategory() == .custom {
            analyticName = AnalyticsEnums.Name.Screen.serviceCustomDetail
        }
        confirmButton = VLButton(type: .bluePrimary, title: (.viewScheduleServiceDetailConfirmService as String).uppercased(), kern: UILabel.uppercasedKern(), event: .scheduleService, screen: analyticName)

        super.init(screen: analyticName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let repairOrder = repairOrder, let repairOrderType = repairOrder.repairOrderType, repairOrderType.getCategory() == .custom {
            label.text = repairOrder.notes
            serviceTitle.setTitle(title: .viewScheduleServiceTypeDetailNameLabelOther, leftDescription: repairOrder.getTitle())
            isDrivableLabel.text = String.viewScheduleServiceTypeOtherDetailLabel + " " + RepairOrder.getDrivabilityTitle(isDrivable: repairOrder.vehicleDrivable.value)
        } else {
            label.text = service.desc
            if let repairOrder = repairOrder {
                serviceTitle.setTitle(title: .viewScheduleServiceTypeMilestoneDetailNameLabel, leftDescription: repairOrder.getTitle())
            }
            label.snp.makeConstraints { make in
                make.right.left.equalTo(serviceTitle)
                make.bottom.equalTo(confirmButton.snp.top).offset(-20)
                make.top.equalTo(serviceTitle.snp.bottom).offset(20)
            }
            isDrivableLabel.isHidden = true
        }
        
        self.navigationItem.title = .newService

        label.volvoProLineSpacing()
        label.sizeToFit()
        
        if !canSchedule || RequestedServiceManager.sharedInstance.getRepairOrder() != nil{
            confirmButton.isEnabled = false
            confirmButton.alpha = 0
            
            if isDrivableLabel.isHidden {
                label.snp.remakeConstraints { make in
                    make.right.left.equalTo(serviceTitle)
                    make.top.equalTo(serviceTitle.snp.bottom).offset(20)
                    make.equalsToBottom(view: self.view, offset: 0)
                }
            } else {
                label.snp.remakeConstraints { make in
                    make.right.left.equalTo(serviceTitle)
                    make.top.equalTo(isDrivableLabel.snp.bottom).offset(20)
                    make.equalsToBottom(view: self.view, offset: 0)
                }
            }
        }
        
        confirmButton.setActionBlock { [weak self] in
            guard let weakself = self else { return }
            // shedule service
            RequestedServiceManager.sharedInstance.setRepairOrder(repairOrder: RepairOrder(repairOrderType: weakself.service))
            StateServiceManager.sharedInstance.updateState(state: .needService, vehicleId: weakself.vehicle.id, booking: nil)
            
            weakself.pushViewController(ServiceCarViewController(title: .viewScheduleServiceOptionPickup, vehicle: weakself.vehicle, state: .needService), animated: true)
        }
        
        serviceTitle.descLeftLabel.volvoProLineSpacing()
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(serviceTitle)
        self.view.addSubview(isDrivableLabel)
        self.view.addSubview(label)
        self.view.addSubview(confirmButton)
        
        serviceTitle.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        isDrivableLabel.snp.makeConstraints { make in
            make.right.left.equalTo(serviceTitle)
            make.top.equalTo(serviceTitle.snp.bottom).offset(20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.right.left.equalTo(serviceTitle)
            make.equalsToBottom(view: self.view, offset: -20)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        label.snp.makeConstraints { make in
            make.right.left.equalTo(serviceTitle)
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
            make.top.equalTo(isDrivableLabel.snp.bottom).offset(20)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.setContentOffset(CGPoint.zero, animated: false)
    }
}
