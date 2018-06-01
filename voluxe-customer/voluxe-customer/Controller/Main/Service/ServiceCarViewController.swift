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
    
    let updateLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = (.New as String).uppercased()
        textView.font = .volvoSansLightBold(size: 14)
        textView.textColor = .white
        textView.backgroundColor = .luxeCobaltBlue()
        textView.numberOfLines = 0
        textView.layer.masksToBounds = true
        textView.textAlignment = .center
        textView.layer.cornerRadius = 5
        textView.addUppercasedCharacterSpacing()
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
    let vehicle: Vehicle

    let vehicleTypeView = VLTitledLabel(title: .VolvoYearModel, leftDescription: "", rightDescription: "")

    let scheduledServiceView = VLTitledLabel()
    let descriptionButton = VLButton(type: .blueSecondary, title: (.ShowDescription as String).uppercased(), kern: UILabel.uppercasedKern())
    
    let vehicleImageView = UIImageView(frame: .zero)
    
    let leftButton = VLButton(type: .bluePrimary, title: (.SelfDrop as String).uppercased(), kern: UILabel.uppercasedKern())
    let rightButton = VLButton(type: .bluePrimary, title: (.VolvoPickup as String).uppercased(), kern: UILabel.uppercasedKern())
    let confirmButton = VLButton(type: .bluePrimary, title: (.Ok as String).uppercased(), kern: UILabel.uppercasedKern())
    
    var analyticScreenName = ""
    var screenTitle: String?
    
    //MARK: Lifecycle methods
    init(title: String? = nil, vehicle: Vehicle, state: ServiceState) {
        self.vehicle = vehicle
        self.serviceState = state
        self.screenTitle = title
        super.init(screenName: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = self.screenTitle {
            self.navigationItem.title = title
        }
        
        vehicleTypeView.setLeftDescription(leftDescription: vehicle.vehicleDescription())

        vehicleImageView.contentMode = .scaleAspectFit
        
        leftButton.setActionBlock { [weak self] in
            self?.leftButtonClick()
        }
        rightButton.setActionBlock { [weak self] in
            self?.rightButtonClick()
        }
        confirmButton.setActionBlock { [weak self] in
            self?.confirmButtonClick()
        }
        
        descriptionButton.setActionBlock { [weak self] in
            self?.showDescriptionClick()
        }
        descriptionButton.contentHorizontalAlignment = .left
        
        fillViews()
        
        stateDidChange(state: serviceState)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.autoUpdate = true
        if locationManager.canUpdateLocation() {
            locationManager.startUpdatingLocation()
        }
        RequestedServiceManager.sharedInstance.resetScheduling()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            RequestedServiceManager.sharedInstance.reset()
        }
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
        
        contentView.addSubview(vehicleTypeView)
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
            make.edgesEqualsToView(view: self.view, edges: UIEdgeInsetsMake(0, 20, 20, 20))
        }
        
        vehicleTypeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleTypeView.snp.bottom)
            make.height.equalTo(Vehicle.vehicleImageHeight)
        }
        
        checkupLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
            make.height.equalTo(checkupLabelHeight)
        }
        
        scheduledServiceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
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
        }
        
        if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.selfPickupEnabledKey) {
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
        } else {
            rightButton.snp.makeConstraints { make in
                make.right.left.bottom.equalToSuperview()
                make.height.equalTo(VLButton.primaryHeight)
            }
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
        
        vehicle.setVehicleImage(imageView: vehicleImageView)
        
        if let service = RequestedServiceManager.sharedInstance.getRepairOrder() {
            var title = String.RecommendedService
            if RequestedServiceManager.sharedInstance.isSelfInitiated() {
                title = .SelectedService
                showUpdateLabel(show: false, title: String.New.uppercased(), width: 40, right: true)
            } else {
                showUpdateLabel(show: true, title: String.New.uppercased(), width: 40, right: true)
            }
            scheduledServiceView.setTitle(title: title, leftDescription: service.name!, rightDescription: "")
        }
    }
    
    
    override func logViewScreen(screenName: String) {
        analyticScreenName = screenName
        super.logViewScreen(screenName: screenName)
        descriptionButton.setEventName(AnalyticsConstants.eventClickShowServiceDescription, screenName: screenName)
        confirmButton.setEventName(AnalyticsConstants.eventClickOk, screenName: screenName)
    }
    
    func showCheckupLabel(show: Bool, alpha: Bool, animated: Bool) {
        self.checkupLabel.changeVisibility(show: show, alpha: alpha, animated: animated, height: self.checkupLabelHeight)
    }
    
    func showVehicleImage(show: Bool, alpha: Bool, animated: Bool) {
        self.vehicleImageView.changeVisibility(show: show, alpha: alpha, animated: animated, height: Vehicle.vehicleImageHeight)
    }
    
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        
        if serviceState == .idle || serviceState == .needService || serviceState == .serviceCompleted {
            noteLabel.text = .NotePickup
        }
        
        stateTestView.accessibilityIdentifier = "schedulingTestView\(state)"
        stateTestView.text = "schedulingTestView\(state)"
        
        confirmButton.isHidden = true
        
        if state == .needService || state == .serviceCompleted {
            
            scheduledServiceView.isHidden = false
            descriptionButton.isHidden = false
            
            if state == .needService {
                logViewScreen(screenName: AnalyticsConstants.paramNameNeedServiceView)
                dealershipPrefetching()
                if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.selfPickupEnabledKey) {
                    checkupLabel.text = .ScheduleDropDealershipSelfEnabled
                } else {
                    checkupLabel.text = .ScheduleDropDealership
                }
            } else {
                if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.selfPickupEnabledKey) {
                    checkupLabel.text = .SchedulePickupDealershipSelfEnabled
                } else {
                    checkupLabel.text = .SchedulePickupDealership
                }
                showUpdateLabel(show: true, title: (.New as String).uppercased(), width: 40, right: true)
                if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                    scheduledServiceView.setTitle(title: String.CompletedService, leftDescription: booking.getRepairOrderName(), rightDescription: "")
                }
                logViewScreen(screenName: AnalyticsConstants.paramNameServiceCompletedView)
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
            if dealership == nil, let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
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
                
                logViewScreen(screenName: AnalyticsConstants.paramNameServiceInProgressView)

            } else if state == .enRouteForService {
                confirmButton.isHidden = true
                leftButton.isHidden = true
                rightButton.isHidden = true
                checkupLabel.text = String(format: NSLocalizedString(.DriverDrivingToDealership), (dealership?.name)!)
                
                logViewScreen(screenName: AnalyticsConstants.paramNameServiceInRouteView)
                
            } else if state == .completed {
                confirmButton.isHidden = false
                leftButton.isHidden = true
                rightButton.isHidden = true
                
                checkupLabel.text = String(format: NSLocalizedString(.DeliveryComplete), (dealership?.name)!)
                logViewScreen(screenName: AnalyticsConstants.paramNameReservationCompletedView)
            }
        }
        
        
        if ServiceState.isPickup(state: state) {
            
            leftButton.setEventName(AnalyticsConstants.eventClickSelfIB, screenName: analyticScreenName)
            rightButton.setEventName(AnalyticsConstants.eventClickVolvoIB, screenName: analyticScreenName)
            
            leftButton.setTitle(title: (.SelfDrop as String).uppercased())
            if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.selfPickupEnabledKey) {
                rightButton.setTitle(title: (.VolvoPickup as String).uppercased())
            } else {
                rightButton.setTitle(title: (.SchedulePickup as String).uppercased())
            }
        } else {
            leftButton.setTitle(title: (.SelfPickup as String).uppercased())
            if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.selfPickupEnabledKey) {
                rightButton.setTitle(title: (.VolvoDelivery as String).uppercased())
            } else {
                rightButton.setTitle(title: (.ScheduleDelivery as String).uppercased())
            }
            
            leftButton.setEventName(AnalyticsConstants.eventClickSelfOB, screenName: analyticScreenName)
            rightButton.setEventName(AnalyticsConstants.eventClickVolvoOB, screenName: analyticScreenName)
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
        if let repairOrder = RequestedServiceManager.sharedInstance.getRepairOrder() {
            if let childViewDelegate = self.childViewDelegate {
            childViewDelegate.pushViewController(controller: ServiceDetailViewController(vehicle: vehicle, service: repairOrder), animated: true, backLabel: .Back, title: repairOrder.name)
            } else {
                self.pushViewController(ServiceDetailViewController(vehicle: vehicle, service: repairOrder), animated: true, backLabel: .Back)
            }
        } else if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle), booking.repairOrderRequests.count > 0 {
            childViewDelegate?.pushViewController(controller: ServiceDetailViewController(vehicle: vehicle, service: booking.repairOrderRequests[0]), animated: true, backLabel: .Back, title: booking.repairOrderRequests[0].name)
        }
    }
    
    func leftButtonClick() {
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            RequestedServiceManager.sharedInstance.setPickupRequestType(requestType: .advisorPickup)
            if let childViewDelegate = self.childViewDelegate {
                childViewDelegate.pushViewController(controller: SchedulingPickupViewController(vehicle: vehicle, state: .schedulingService), animated: true, backLabel: .Back, title: nil)
            } else {
                self.pushViewController(SchedulingPickupViewController(vehicle: vehicle, state: .schedulingService), animated: true, backLabel: .Back)
            }
        } else {
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                RequestedServiceManager.sharedInstance.setDropOffRequestType(requestType: .advisorDropoff)
                if let childViewDelegate = self.childViewDelegate {
                    childViewDelegate.pushViewController(controller: SchedulingDropoffViewController(state: .schedulingDelivery, booking: booking), animated: true, backLabel: .Back, title: nil)
                } else {
                    self.pushViewController(SchedulingDropoffViewController(state: .schedulingDelivery, booking: booking), animated: true, backLabel: .Back)
                }
            }
        }
    }
    
    func rightButtonClick() {
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            RequestedServiceManager.sharedInstance.setPickupRequestType(requestType: .driverPickup)
            if let childViewDelegate = self.childViewDelegate {
                childViewDelegate.pushViewController(controller: SchedulingPickupViewController(vehicle: vehicle, state: .schedulingService), animated: true, backLabel: .Back, title: nil)
            } else {
                self.pushViewController(SchedulingPickupViewController(vehicle: vehicle, state: .schedulingService), animated: true, backLabel: .Back)
            }
        } else {
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                RequestedServiceManager.sharedInstance.setDropOffRequestType(requestType: .driverDropoff)
                
                if let childViewDelegate = self.childViewDelegate {
                    childViewDelegate.pushViewController(controller: SchedulingDropoffViewController(state: .schedulingDelivery, booking: booking), animated: true, backLabel: .Back, title: nil)
                } else {
                    self.pushViewController(SchedulingDropoffViewController(state: .schedulingDelivery, booking: booking), animated: true, backLabel: .Back)
                }
            }
        }
    }
    
    func confirmButtonClick() {
        if StateServiceManager.sharedInstance.getState(vehicleId: vehicle.id) == .completed {
            // start over
            RequestedServiceManager.sharedInstance.reset()
            appDelegate?.loadMainScreen()
        }
    }
    
    
    //MARK: Prefetching methods
    
    func dealershipPrefetching() {
        if locationManager.canUpdateLocation() && locationManager.lastKnownLatitude != 0 && locationManager.lastKnownLongitude != 0 && locationManager.hasLastKnownLocation {
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
