//
//  ScheduledViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import CoreLocation
import GoogleMaps
import BrightFutures
import Result
import SwiftEventBus
import MBProgressHUD

class ScheduledViewController: ChildViewController {
    
    private static let ETARefreshThrottle: Double = 30
    
    private static let mapViewHeight = 160
    private static let driverViewHeight = 55
    
    var states: [ServiceState] = []
    var driverLocations: [CLLocationCoordinate2D] = []
    
    // UITest
    let testView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    
    private let googleDistanceMatrixAPI = GoogleDistanceMatrixAPI()
    
    var steps: [Step] = []
    private var driver: Driver?
    
    var verticalStepView: GroupedVerticalStepView? = nil
    let mapVC = MapViewController()
    let vehicle: Vehicle
    private let mapViewContainer = UIView(frame: .zero)
    private let driverViewContainer = UIView(frame: .zero)
    private let driverIcon: UIImageView
    let timeWindowView = TimeWindowView()
    
    let driverName: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansLightBold(size: 18)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private var lastRefresh: Date? = nil

    private let driverContact: VLButton
    
    init(vehicle: Vehicle, screenName: String) {
        self.vehicle = vehicle
        driverContact = VLButton(type: .blueSecondary, title: (.Contact as String).uppercased(), kern: UILabel.uppercasedKern(), eventName: AnalyticsConstants.eventClickContactDriver, screenName: screenName)
        driverIcon = UIImageView.makeRoundImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35), photoUrl: nil, defaultImage: UIImage(named: "driver_placeholder"))
        super.init(screenName: screenName)
        generateSteps()

        mapVC.screenName = self.screenName

        verticalStepView = GroupedVerticalStepView(steps: steps)
        verticalStepView?.accessibilityIdentifier = "verticalStepView"
        mapVC.view.accessibilityIdentifier = "mapVC.view"
        timeWindowView.accessibilityIdentifier = "timeWindowView"
        testView.accessibilityIdentifier = "testView"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateSteps() {}

    override func viewDidLoad() {
        super.viewDidLoad()
      
        driverContact.setActionBlock { [weak self] in
            self?.contactDriverActionSheet()
        }
        
        driverViewContainer.isHidden = true
        
        mapVC.view.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(ScheduledViewController.mapViewHeight + ScheduledViewController.driverViewHeight)
        }
        
        addShadow(toView: mapViewContainer)
    }
    
    private func addShadow(toView: UIView) {
        
        toView.layer.masksToBounds = false
        
        toView.layer.shadowColor = UIColor.black.cgColor
        toView.layer.shadowOpacity = 0.5
        toView.layer.shadowRadius = 2
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
    
    override func setupViews() {
        super.setupViews()
        
        mapViewContainer.backgroundColor = .white
        
        if let verticalStepView = verticalStepView {
            
            self.view.addSubview(verticalStepView)
            self.view.addSubview(mapViewContainer)
            self.view.addSubview(timeWindowView)
            
            mapViewContainer.addSubview(driverViewContainer)
            driverViewContainer.addSubview(driverIcon)
            driverViewContainer.addSubview(driverName)
            driverViewContainer.addSubview(driverContact)
            
            verticalStepView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(30)
                make.top.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(verticalStepView.height)
            }
            
            mapViewContainer.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(25)
                make.right.equalToSuperview().offset(-25)
                make.top.equalTo(verticalStepView.snp.bottom)
                make.height.equalTo(ScheduledViewController.mapViewHeight + ScheduledViewController.driverViewHeight)
            }
            
            mapViewContainer.addSubview(mapVC.view)
            mapVC.view.snp.makeConstraints { (make) -> Void in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(ScheduledViewController.mapViewHeight)
            }
            
            driverViewContainer.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(mapVC.view.snp.bottom)
                make.height.equalTo(ScheduledViewController.driverViewHeight)
            }
            
            driverIcon.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(35)
            }
            
            driverName.snp.makeConstraints { make in
                make.left.equalTo(driverIcon.snp.right).offset(10)
                make.centerY.right.equalToSuperview()
                make.height.equalTo(35)
            }
            
            driverContact.snp.makeConstraints { make in
                make.centerY.right.equalToSuperview()
                make.height.equalTo(35)
                make.width.equalTo(100)
            }
            
            timeWindowView.snp.makeConstraints { make in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(TimeWindowView.height)
            }
        }
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        self.updateState(id: state, stepState: .done)
        if state == .enRouteForDropoff || state == .enRouteForPickup || state == .nearbyForPickup || state == .nearbyForDropoff {
            SwiftEventBus.onMainThread(self, name: "driverLocationUpdate") { result in
                // UI thread
                self.driverLocationUpdate()
            }
        } else {
            SwiftEventBus.unregister(self)
        }
    }
    
    func newDriver(driver: Driver) {
        
        if self.driver == nil || self.driver?.id != driver.id {
            self.driver = driver
            driverViewContainer.animateAlpha(show: true)
            UIView.animate(withDuration: 0.25, animations: {
                self.mapVC.view.snp.updateConstraints { (make) -> Void in
                    make.height.equalTo(ScheduledViewController.mapViewHeight)
                }
            })
        } else {
            return
        }
        
        driverName.text = driver.name
        if let iconUrl = driver.iconUrl {
            driverIcon.sd_setImage(with: URL(string: iconUrl))
        }
    }
    
    private func updateState(id: ServiceState, stepState: StepState) {
        for step in steps {
            if step.id == id {
                step.state = stepState
                verticalStepView?.updateStep(step: step)
                break
            } else if stepState == .done {
                if step.id.rawValue < id.rawValue {
                    step.state = .done
                    verticalStepView?.updateStep(step: step)
                }
            }
        }
        mapVC.updateServiceState(state: id)
    }
    
    func driverLocationUpdate() {
        
    }
    
    
    func getEta(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) {
        if lastRefresh == nil || lastRefresh!.timeIntervalSinceNow < -ScheduledViewController.ETARefreshThrottle {
            lastRefresh = Date()
            
            weak var weakSelf = self
            
            VLAnalytics.logEventWithName(AnalyticsConstants.eventGmapsRequest, paramName: AnalyticsConstants.paramGMapsType, paramValue: AnalyticsConstants.paramNameGmapsDistance, screenName: screenName)
            googleDistanceMatrixAPI.getDirection(origin: GoogleDistanceMatrixAPI.coordinatesToString(coordinate: fromLocation), destination: GoogleDistanceMatrixAPI.coordinatesToString(coordinate: toLocation), mode: nil).onSuccess { distanceMatrix in
                
                guard let weakSelf = weakSelf else {
                    return
                }
                
                VLAnalytics.logEventWithName(AnalyticsConstants.eventGmapsDistanceAPISuccess, screenName: weakSelf.screenName)
                if let distanceMatrix = distanceMatrix {
                    weakSelf.mapVC.updateETA(eta: distanceMatrix.getEta())
                    weakSelf.timeWindowView.setETA(eta: distanceMatrix.getEta())
                }
                }.onFailure { error in
                    Logger.print(error)
                    guard let weakSelf = weakSelf else {
                        return
                    }
                    VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventGmapsDistanceAPIFail, screenName: weakSelf.screenName)
            }
        }
    }
    
    func contactDriverActionSheet() {
        let alertController = UIAlertController(title: .ContactDriver, message: nil, preferredStyle: .actionSheet)
        
        let textButton = UIAlertAction(title: .TextDriver, style: .default, handler: { (action) -> Void in
            self.contactDriver(mode: "text_only")
        })
        
        let callButton = UIAlertAction(title: .CallDriver, style: .default, handler: { (action) -> Void in
            self.contactDriver(mode: "voice_only")
        })
        
        let cancelButton = UIAlertAction(title: .Cancel, style: .cancel, handler: { (action) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(textButton)
        alertController.addAction(callButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func contactDriver(mode: String) {
        
        guard let customerId = UserManager.sharedInstance.customerId() else {
            return
        }
        
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) else {
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        BookingAPI().contactDriver(customerId: customerId, bookingId: booking.id, mode: mode).onSuccess { result in
            if let contactDriver = result?.data?.result {
                MBProgressHUD.hide(for: self.view, animated: true)
                VLAnalytics.logEventWithName(AnalyticsConstants.eventApiContactDriverSuccess, screenName: self.screenName)
                if mode == "text_only" {
                    // sms
                    let number = "sms:\(contactDriver.textPhoneNumber ?? "")"
                    guard let url = URL(string: number) else { return }
                    UIApplication.shared.open(url)
                } else {
                    let number = "telprompt:\(contactDriver.voicePhoneNumber ?? "")"
                    guard let url = URL(string: number) else { return }
                    UIApplication.shared.open(url)
                }
            }
        }.onFailure { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showOkDialog(title: .Error, message: .GenericError, analyticDialogName: AnalyticsConstants.paramNameErrorDialog, screenName: self.screenName)
            VLAnalytics.logErrorEventWithName(AnalyticsConstants.eventApiContactDriverFail, screenName: self.screenName, error: error)
        }
    }
    
}
