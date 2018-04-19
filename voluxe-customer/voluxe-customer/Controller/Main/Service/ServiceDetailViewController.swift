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
    
    var repairOrder: RepairOrder?
    let vehicle: Vehicle
    let service: RepairOrderType
    let confirmButton = VLButton(type: .bluePrimary, title: (.ScheduleService as String).uppercased(), kern: UILabel.uppercasedKern(), actionBlock: nil)

    convenience init(vehicle: Vehicle, service: RepairOrder) {
        self.init(vehicle: vehicle, service: service.repairOrderType!, canSchedule: false)
        self.repairOrder = service
    }
    
    init(vehicle: Vehicle, service: RepairOrderType, canSchedule: Bool) {
        self.vehicle = vehicle
        self.canSchedule = canSchedule
        self.service = service
        serviceTitle = VLTitledLabel(title: .FactoryScheduledMaintenance, leftDescription: service.name!, rightDescription: "")
        var analyticName = canSchedule ? AnalyticsConstants.ParamNameServiceMilestoneDetailsSchedulingView : AnalyticsConstants.ParamNameServiceMilestoneDetailsView
        if let repairOrder = repairOrder, let repairOrderType = repairOrder.repairOrderType, repairOrderType.getCategory() == .custom {
            analyticName = AnalyticsConstants.ParamNameServiceCustomDetailsView
        }
        super.init(screenName: analyticName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let repairOrder = repairOrder, let repairOrderType = repairOrder.repairOrderType, repairOrderType.getCategory() == .custom {
            label.text = repairOrder.notes
            serviceTitle.setTitle(title: .OtherMaintenanceRepairs, leftDescription: repairOrder.name!)
        } else {
            label.text = service.desc
        }
        
        self.navigationItem.title = .NewService

        label.sizeToFit()
        
        if !canSchedule || RequestedServiceManager.sharedInstance.getRepairOrder() != nil{
            confirmButton.isEnabled = false
            confirmButton.alpha = 0
        }
        
        confirmButton.setActionBlock {
            // shedule service
            RequestedServiceManager.sharedInstance.setRepairOrder(repairOrder: RepairOrder(repairOrderType: self.service))
            StateServiceManager.sharedInstance.updateState(state: .needService, vehicleId: self.vehicle.id)
            self.appDelegate?.loadViewForVehicle(vehicle: self.vehicle, state: .needService)
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
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        label.snp.makeConstraints { make in
            make.right.left.equalTo(serviceTitle)
            make.top.equalTo(serviceTitle.snp.bottom).offset(20)
        }
    }
}
