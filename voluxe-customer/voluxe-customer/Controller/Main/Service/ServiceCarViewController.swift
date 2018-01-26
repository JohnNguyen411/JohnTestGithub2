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


class ServiceCarViewController: ChildViewController {
    
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
    
    let scheduledServiceView = VLTitledLabel()
    let descriptionButton = VLButton(type: .BlueSecondary, title: (.ShowDescription as String).uppercased(), actionBlock: nil)

    let vehicleImageView = UIImageView(frame: .zero)
    
    let leftButton = VLButton(type: .BluePrimary, title: (.SelfDrop as String).uppercased(), actionBlock: nil)
    let rightButton = VLButton(type: .BluePrimary, title: (.VolvoPickup as String).uppercased(), actionBlock: nil)
    let confirmButton = VLButton(type: .BluePrimary, title: (.ConfirmPickup as String).uppercased(), actionBlock: nil)
    
    
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
        
        if state == .needService {
            noteLabel.isHidden = false
            checkupLabel.isHidden = false
            
            checkupLabel.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(noteLabel.snp.top).offset(-20)
                make.height.equalTo(checkupLabelHeight)
            }
        } else {
            
            if state == .serviceCompleted {
                checkupLabel.text = .VolvoServiceComplete
                leftButton.animateAlpha(show: true)
                rightButton.animateAlpha(show: true)
                showCheckupLabel(show: true, alpha: true, animated: true)
                
            } else {
                checkupLabel.text = .VolvoCurrentlyServicing
                leftButton.isHidden = true
                rightButton.isHidden = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    self.stateDidChange(state: .serviceCompleted)
                })
            }
        }
        
        if state == .pickupDriverDrivingToDealership || state == .pickupDriverAtDealership {
            
            confirmButton.isHidden = true
            
            if state == .pickupDriverDrivingToDealership {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                    StateServiceManager.sharedInstance.updateState(state: .pickupDriverAtDealership)
                })
            } else if state == .pickupDriverAtDealership {
                
                let alert = UIAlertController(title: .VolvoPickup, message: .YourVehicleHasArrived, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: (.Ok as String).uppercased(), style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                    // show being serviced
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        StateServiceManager.sharedInstance.updateState(state: .servicing)
                    })
                    
                })
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: {
                    // add accessibility if possible
                    if let alertButton = okAction.value(forKey: "__representer") {
                        let view = alertButton as? UIView
                        view?.accessibilityIdentifier = "okAction_AID"
                    }
                })
            }
        }
        
        
        if ServiceState.isPickup(state: state) {
            confirmButton.isHidden = true
            leftButton.setTitle(title: (.SelfDrop as String).uppercased())
            rightButton.setTitle(title: (.VolvoPickup as String).uppercased())
        } else {
            leftButton.setTitle(title: (.SelfPickup as String).uppercased())
            rightButton.setTitle(title: (.VolvoDelivery as String).uppercased())
            confirmButton.setTitle(title: (.ConfirmDelivery as String).uppercased())
        }
    }
    
    //MARK: Actions methods
    func showDescriptionClick() {
    }
    
    func leftButtonClick() {
    }
    
    func rightButtonClick() {
        StateServiceManager.sharedInstance.updateState(state: .schedulingService)
    }
    
    func confirmButtonClick() {
    }
    
    
}
