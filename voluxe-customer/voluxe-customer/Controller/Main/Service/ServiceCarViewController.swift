//
//  ServiceCarViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import CoreLocation
import RealmSwift
import BrightFutures
import Alamofire


class ServiceCarViewController: ChildViewController, LocationManagerDelegate {
    
    var serviceState: ServiceState
    var checkupLabelHeight: CGFloat = 0
    var vehicleImageHeight: CGFloat = 100
    
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
    let descriptionButton = VLButton(type: .BlueSecondary, title: (.ShowDescription as String).uppercased(), actionBlock: nil)
    
    let vehicleImageView = UIImageView(frame: .zero)
    
    let leftButton = VLButton(type: .BluePrimary, title: (.SelfDrop as String).uppercased(), actionBlock: nil)
    let rightButton = VLButton(type: .BluePrimary, title: (.VolvoPickup as String).uppercased(), actionBlock: nil)
    let confirmButton = VLButton(type: .BluePrimary, title: (.Ok as String).uppercased(), actionBlock: nil)
    
    
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            let service = Service(name: "10,000 mile check-up", price: Double(400))
            RequestedServiceManager.sharedInstance.setService(service: service)
            
            noteLabel.text = .NotePickup
        }
        vehicleImageView.image = UIImage(named: "image_auto")
        
        if let service = RequestedServiceManager.sharedInstance.getService() {
            scheduledServiceView.setTitle(title: .RecommendedService, leftDescription: service.name!, rightDescription: String(format: "$%.02f", service.price!))
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
                checkupLabel.text = .VolvoServiceComplete
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
            noteLabel.isHidden = true
            scheduledServiceView.isHidden = true
            descriptionButton.isHidden = true
            
            checkupLabel.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(vehicleImageView.snp.bottom).offset(40)
                make.height.equalTo(checkupLabelHeight)
            }
            
            if state == .servicing {
                checkupLabel.text = .VolvoCurrentlyServicing
                leftButton.isHidden = true
                rightButton.isHidden = true
                
                if Config.sharedInstance.isMock {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                        StateServiceManager.sharedInstance.updateState(state: .serviceCompleted)
                    })
                }
            } else if state == .pickupDriverDrivingToDealership {
                confirmButton.isHidden = true
                leftButton.isHidden = true
                rightButton.isHidden = true
                checkupLabel.text = .DriverDrivingToDealership
                
                if Config.sharedInstance.isMock {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                        StateServiceManager.sharedInstance.updateState(state: .pickupDriverAtDealership)
                    })
                }
                
            } else if state == .pickupDriverAtDealership {
                confirmButton.isHidden = false
                checkupLabel.text = .YourVehicleHasArrived
                
                if Config.sharedInstance.isMock {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                        StateServiceManager.sharedInstance.updateState(state: .servicing)
                    })
                }
                
            } else if state == .completed {
                confirmButton.isHidden = false
                leftButton.isHidden = true
                rightButton.isHidden = true
                checkupLabel.text = .DeliveryComplete
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
    
    //MARK: Actions methods
    func showDescriptionClick() {
    }
    
    func leftButtonClick() {
    }
    
    func rightButtonClick() {
        if StateServiceManager.sharedInstance.isPickup() {
            StateServiceManager.sharedInstance.updateState(state: .schedulingService)
        } else {
            StateServiceManager.sharedInstance.updateState(state: .schedulingDelivery)
        }
    }
    
    func confirmButtonClick() {
        if StateServiceManager.sharedInstance.getState() == .completed {
            // start over
            RequestedServiceManager.sharedInstance.reset()
            StateServiceManager.sharedInstance.updateState(state: .idle)
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
