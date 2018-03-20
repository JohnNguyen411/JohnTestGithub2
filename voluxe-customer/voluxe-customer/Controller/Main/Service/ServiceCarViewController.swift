//
//  ServiceCarViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SlideMenuControllerSwift
import CoreLocation
import RealmSwift
import BrightFutures
import Alamofire
import Kingfisher


class ServiceCarViewController: ChildViewController, LocationManagerDelegate {
    
    var serviceState: ServiceState
    var checkupLabelHeight: CGFloat = 0
    var vehicleImageHeight: CGFloat = 100
    
    let updateLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = (.New as String).uppercased()
        textView.font = .volvoSansLightBold(size: 14)
        textView.textColor = .white
        textView.backgroundColor = .luxeDeepBlue()
        textView.numberOfLines = 0
        textView.layer.masksToBounds = true
        textView.textAlignment = .center
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    let checkupLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .ScheduleDropDealership
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let noteLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .NotePickup
        textView.font = .volvoSansLightBold(size: 12)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    var locationManager = LocationManager.sharedInstance
    
    let stateTestView = UILabel(frame: .zero)

    let scheduledServiceView = VLTitledLabel()
    let descriptionButton = VLButton(type: .blueSecondary, title: (.ShowDescription as String).uppercased(), actionBlock: nil)
    
    let vehicleImageView = UIImageView(frame: .zero)
    
    let leftButton = VLButton(type: .bluePrimary, title: (.SelfDrop as String).uppercased(), actionBlock: nil)
    let rightButton = VLButton(type: .bluePrimary, title: (.VolvoPickup as String).uppercased(), actionBlock: nil)
    let confirmButton = VLButton(type: .bluePrimary, title: (.Ok as String).uppercased(), actionBlock: nil)
    
    
    //MARK: Lifecycle methods
    init(state: ServiceState) {
        self.serviceState = state
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vehicleImageView.contentMode = .scaleAspectFit
        
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        leftButton.setActionBlock {
            self.leftButtonClick()
        }
        rightButton.setActionBlock {
            self.rightButtonClick()
        }
        confirmButton.setActionBlock {
            self.confirmButtonClick()
        }
        
        descriptionButton.setActionBlock {
            self.showDescriptionClick()
        }
        descriptionButton.contentHorizontalAlignment = .left
        
        fillViews()
        
        stateDidChange(state: serviceState)
    }
    
    
    //MARK: Views methods
    override func setupViews() {
        super.setupViews()
        rightButton.accessibilityIdentifier = "rightButton"
        confirmButton.accessibilityIdentifier = "confirmButton"
        
        checkupLabelHeight = checkupLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height
        
        let contentView = UIView(frame: .zero)
        
        self.view.addSubview(contentView)
        
        contentView.addSubview(stateTestView)
        stateTestView.textColor = .clear
        
        contentView.addSubview(vehicleImageView)
        contentView.addSubview(scheduledServiceView)
        contentView.addSubview(descriptionButton)
        contentView.addSubview(checkupLabel)
        contentView.addSubview(noteLabel)
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        contentView.addSubview(confirmButton)
        contentView.addSubview(updateLabel)
        
        updateLabel.isHidden = true
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(20, 20, 20, 20))
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(vehicleImageHeight)
        }
        
        checkupLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom).offset(10)
            make.height.equalTo(checkupLabelHeight)
        }
        
        scheduledServiceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom).offset(40)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        updateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(scheduledServiceView).offset(-3)
            make.width.greaterThanOrEqualTo(45)
            make.height.equalTo(20)
        }
        
        descriptionButton.snp.makeConstraints { make in
            make.left.right.equalTo(scheduledServiceView)
            make.top.equalTo(scheduledServiceView.snp.bottom).offset(10)
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        leftButton.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        stateTestView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
            make.height.width.equalTo(1)
        }
        
    }
    
    func fillViews() {
        if serviceState == .idle || serviceState == .needService {
            noteLabel.text = .NotePickup
        } else if serviceState == .serviceCompleted {
            noteLabel.text = .NoteDelivery
        }
        
        if let vehicle = UserManager.sharedInstance.getVehicle() {
            vehicle.setVehicleImage(imageView: vehicleImageView)
        }
        
        if let service = RequestedServiceManager.sharedInstance.getRepairOrder() {
            var title = String.RecommendedService
            if RequestedServiceManager.sharedInstance.isSelfInitiated() {
                title = .SelectedService
                showUpdateLabel(show: false, title: .New, width: 40, right: true)
            } else {
                showUpdateLabel(show: true, title: .New, width: 40, right: true)
            }
            scheduledServiceView.setTitle(title: title, leftDescription: service.name!, rightDescription: "")
        }
    }
    
    
    func showCheckupLabel(show: Bool, alpha: Bool, animated: Bool) {
        self.checkupLabel.changeVisibility(show: show, alpha: alpha, animated: animated, height: self.checkupLabelHeight)
    }
    
    func showVehicleImage(show: Bool, alpha: Bool, animated: Bool) {
        self.vehicleImageView.changeVisibility(show: show, alpha: alpha, animated: animated, height: self.vehicleImageHeight)
    }
    
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        
        stateTestView.accessibilityIdentifier = "schedulingTestView\(state)"
        stateTestView.text = "schedulingTestView\(state)"
        
        confirmButton.isHidden = true
        
        if state == .needService || state == .serviceCompleted {
            
            scheduledServiceView.isHidden = false
            descriptionButton.isHidden = false
            
            if state == .needService {
                dealershipPrefetching()
                checkupLabel.text = .ScheduleDropDealership
            } else {
                checkupLabel.text = .SchedulePickupDealership
                showUpdateLabel(show: true, title: (.New as String).uppercased(), width: 40, right: true)
                checkupLabel.text = .VolvoServiceComplete
                scheduledServiceView.setTitle(title: .CompletedService)
            }
            noteLabel.isHidden = false
            
            checkupLabel.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(noteLabel.snp.top).offset(-20)
                make.height.equalTo(checkupLabelHeight)
            }
           
            leftButton.animateAlpha(show: true)
            rightButton.animateAlpha(show: true)
            confirmButton.animateAlpha(show: false)
        } else {
            
            var dealership = RequestedServiceManager.sharedInstance.getDealership()
            if dealership == nil, let booking = UserManager.sharedInstance.getFirstBookingForVehicle(vehicle: UserManager.sharedInstance.getVehicle()!) {
                dealership = booking.dealership
            }
            noteLabel.isHidden = true
            scheduledServiceView.isHidden = true
            descriptionButton.isHidden = true
            
            checkupLabel.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(vehicleImageView.snp.bottom).offset(50)
                make.height.equalTo(checkupLabelHeight)
            }
            
            showUpdateLabel(show: true, title: (.New as String).uppercased(), width: 40, right: false)
            
            if state == .service {
                checkupLabel.text = .VolvoCurrentlyServicing
                leftButton.isHidden = true
                rightButton.isHidden = true
                
                if Config.sharedInstance.isMock {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                        StateServiceManager.sharedInstance.updateState(state: .serviceCompleted)
                    })
                }
            } else if state == .enRouteForService {
                confirmButton.isHidden = true
                leftButton.isHidden = true
                rightButton.isHidden = true
                checkupLabel.text = String(format: NSLocalizedString(.DriverDrivingToDealership), (dealership?.name)!)

                if Config.sharedInstance.isMock {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                        StateServiceManager.sharedInstance.updateState(state: .service)
                    })
                }
                
            } else if state == .service { // TODO: merge with upstairs
                
                showUpdateLabel(show: true, title: (.Update as String).uppercased(), width: 70, right: false)
                
                confirmButton.isHidden = false
                checkupLabel.text = String(format: NSLocalizedString(.YourVehicleHasArrived), (dealership?.name)!)

                if Config.sharedInstance.isMock {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                        StateServiceManager.sharedInstance.updateState(state: .service)
                    })
                }
                
            } else if state == .completed {
                confirmButton.isHidden = false
                leftButton.isHidden = true
                rightButton.isHidden = true
                
                checkupLabel.text = String(format: NSLocalizedString(.DeliveryComplete), (dealership?.name)!)
            }
        }
        
        
        if ServiceState.isPickup(state: state) {
            leftButton.setTitle(title: (.SelfDrop as String).uppercased())
            rightButton.setTitle(title: (.VolvoPickup as String).uppercased())
        } else {
            leftButton.setTitle(title: (.SelfPickup as String).uppercased())
            rightButton.setTitle(title: (.VolvoDelivery as String).uppercased())
        }
    }
    
    private func showUpdateLabel(show: Bool, title: String?, width: Int, right: Bool) {
        
        updateLabel.isHidden = !show
        updateLabel.text = title
        
        if right {
            updateLabel.snp.remakeConstraints { make in
                make.right.equalToSuperview()
                make.top.equalTo(scheduledServiceView).offset(-3)
                make.width.greaterThanOrEqualTo(width)
                make.height.equalTo(20)
            }
        } else {
            updateLabel.snp.remakeConstraints { make in
                make.left.equalToSuperview()
                make.bottom.equalTo(checkupLabel.snp.top).offset(-10)
                make.width.greaterThanOrEqualTo(width)
                make.height.equalTo(20)
            }
        }
    }
    
    //MARK: Actions methods
    func showDescriptionClick() {
        if let repairOrder = RequestedServiceManager.sharedInstance.getRepairOrder(), let repairOrderType = repairOrder.repairOrderType {
            childViewDelegate?.pushViewController(controller: ServiceDetailViewController(service: repairOrderType), animated: true, backLabel: .Back, title: repairOrderType.name)
        }
    }
    
    func leftButtonClick() {
        if StateServiceManager.sharedInstance.isPickup() {
            RequestedServiceManager.sharedInstance.setPickupRequestType(requestType: .advisorPickup)
            self.childViewDelegate?.pushViewController(controller: SchedulingPickupViewController(state: .schedulingService), animated: true, backLabel: .Back, title: nil)
        } else {
            RequestedServiceManager.sharedInstance.setDropOffRequestType(requestType: .advisorDropoff)
            self.childViewDelegate?.pushViewController(controller: SchedulingDropoffViewController(state: .schedulingDelivery), animated: true, backLabel: .Back, title: nil)
        }
    }
    
    func rightButtonClick() {
        if StateServiceManager.sharedInstance.isPickup() {
            self.childViewDelegate?.pushViewController(controller: SchedulingPickupViewController(state: .schedulingService), animated: true, backLabel: .Back, title: nil)
        } else {
            self.childViewDelegate?.pushViewController(controller: SchedulingDropoffViewController(state: .schedulingDelivery), animated: true, backLabel: .Back, title: nil)
        }
    }
    
    func confirmButtonClick() {
        if StateServiceManager.sharedInstance.getState() == .completed {
            // start over
            RequestedServiceManager.sharedInstance.reset()
            StateServiceManager.sharedInstance.updateState(state: .noninit)
        }
    }
    
    
    //MARK: Prefetching methods
    
    func dealershipPrefetching() {
        if CLLocationManager.locationServicesEnabled() && locationManager.lastKnownLatitude != 0 && locationManager.lastKnownLongitude != 0 && locationManager.hasLastKnownLocation {
            DealershipAPI().getDealerships(location: CLLocationCoordinate2DMake(locationManager.lastKnownLatitude, locationManager.lastKnownLongitude)).onSuccess { result in
                
                self.saveDealerships(result: result)
                
                }.onFailure { error in
            }
        } else {
            DealershipAPI().getDealerships().onSuccess { result in
                
                self.saveDealerships(result: result)
                
                }.onFailure { error in
            }
        }
    }
    
    func saveDealerships(result: ResponseObject<MappableDataArray<Dealership>>?) {
        if let dealerships = result?.data?.result, dealerships.count > 0 {
            if let realm = try? Realm() {
                try? realm.write {
                    realm.add(dealerships, update: true)
                }
            }
        }
        
    }
    
    //MARK: LocationDelegate methods
    
    func locationFound(_ latitude: Double, longitude: Double) {
    }
    
}
