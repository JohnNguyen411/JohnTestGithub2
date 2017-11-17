//
//  ScheduledPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import CoreLocation
import GoogleMaps

class ScheduledPickupViewController: BaseViewController {
    
    static let officeLocation = CLLocationCoordinate2D(latitude: 37.788866, longitude: -122.398210)
    static let driverLocation1 = CLLocationCoordinate2D(latitude: 37.7686497, longitude: -122.4175534)
    static let driverLocation2 = CLLocationCoordinate2D(latitude: 37.772028, longitude: -122.418198)
    static let driverLocation3 = CLLocationCoordinate2D(latitude: 37.773911, longitude: -122.417629)
    static let driverLocation4 = CLLocationCoordinate2D(latitude: 37.776421, longitude: -122.414518)
    static let driverLocation5 = CLLocationCoordinate2D(latitude: 37.779974, longitude: -122.409948)
    static let driverLocation6 = CLLocationCoordinate2D(latitude: 37.783298, longitude: -122.405785)
    static let driverLocation7 = CLLocationCoordinate2D(latitude: 37.786071, longitude: -122.402191)
    static let driverLocation8 = CLLocationCoordinate2D(latitude: 37.788148, longitude: -122.399627)
    static let driverLocation9 = CLLocationCoordinate2D(latitude: 37.789094, longitude: -122.398403)
    
    static let mockDriver = Driver(id: 0, name: "Michelle", iconUrl: "https://www.biography.com/.image/t_share/MTE5NDg0MDU0ODEyNzIyNzAz/michelle-obama-thumb-2.jpg",
                                   phone: nil, email: "")
    
    
    private static let mapViewHeight = 160
    private static let driverViewHeight = 55
    
    // mock
    private var states: [ServiceState] = [ServiceState.pickupDriverInRoute, ServiceState.pickupDriverInRoute, ServiceState.pickupDriverInRoute, ServiceState.pickupDriverInRoute,
                                          ServiceState.pickupDriverInRoute, ServiceState.pickupDriverInRoute, ServiceState.pickupDriverNearby, ServiceState.pickupDriverNearby,
                                          ServiceState.pickupDriverArrived]
    
    private var driverLocations: [CLLocationCoordinate2D] = []
    
    
    private let googleDirectionAPI = GoogleDirectionAPI()
    
    private var steps: [Step] = []
    private var driver: Driver?
    
    private var verticalStepView: GroupedVerticalStepView? = nil
    private let mapVC = MapViewController()
    private let mapViewContainer = UIView(frame: .zero)
    private let driverViewContainer = UIView(frame: .zero)
    private let driverIcon: UIImageView
    private let timeWindowView = TimeWindowView()
    
    let driverName: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansLightBold(size: 18)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private let driverContact = VLButton(type: .OrangeSecondarySmall, title: (.Contact as String).uppercased(), actionBlock: nil)
    
    override init() {
        driverIcon = UIImageView.makeRoundImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35), photoUrl: nil, defaultImage: UIImage(named: "driver_placeholder"))
        super.init()
        generateSteps()
        generateDriverLocations()
        verticalStepView = GroupedVerticalStepView(steps: steps)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateSteps() {
        let step1 = Step(id: ServiceState.pickupScheduled, text: .ServiceScheduled, state: .done)
        let step2 = Step(id: ServiceState.pickupDriverInRoute, text: .DriverEnRoute)
        let step3 = Step(id: ServiceState.pickupDriverNearby, text: .DriverNearby)
        let step4 = Step(id: ServiceState.pickupDriverArrived, text: .DriverArrived)
        
        steps.append(step1)
        steps.append(step2)
        steps.append(step3)
        steps.append(step4)
    }
    
    func generateDriverLocations() {
        driverLocations.append(ScheduledPickupViewController.driverLocation1)
        driverLocations.append(ScheduledPickupViewController.driverLocation2)
        driverLocations.append(ScheduledPickupViewController.driverLocation3)
        driverLocations.append(ScheduledPickupViewController.driverLocation4)
        driverLocations.append(ScheduledPickupViewController.driverLocation5)
        driverLocations.append(ScheduledPickupViewController.driverLocation6)
        driverLocations.append(ScheduledPickupViewController.driverLocation7)
        driverLocations.append(ScheduledPickupViewController.driverLocation8)
        driverLocations.append(ScheduledPickupViewController.driverLocation9)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapVC.updateRequestLocation(location: ScheduledPickupViewController.officeLocation)
        
        var delay = 4.0
        for (index, driverLocation) in driverLocations.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.newDriver(driver: ScheduledPickupViewController.mockDriver)
                self.newDriverLocation(location: driverLocation)
                self.updateState(id: self.states[index], stepState: .done)
                self.getEta(fromLocation: driverLocation, toLocation: ScheduledPickupViewController.officeLocation)
            })
            
            delay = delay + 4
        }
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
                make.height.equalTo(ScheduledPickupViewController.mapViewHeight + ScheduledPickupViewController.driverViewHeight)
            }
            
            mapViewContainer.addSubview(mapVC.view)
            mapVC.view.snp.makeConstraints { (make) -> Void in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(ScheduledPickupViewController.mapViewHeight)
            }
            
            driverViewContainer.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(mapVC.view.snp.bottom)
                make.height.equalTo(ScheduledPickupViewController.driverViewHeight)
            }
            
            driverIcon.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(35)
            }
            
            driverName.snp.makeConstraints { make in
                make.left.equalTo(driverIcon.snp.right).offset(20)
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
    
    func newDriver(driver: Driver) {
        
        if self.driver == nil || self.driver?.id != driver.id {
            self.driver = driver
        } else {
            return
        }
        
        driverName.text = driver.name
        driverIcon.sd_setImage(with: URL(string: driver.iconUrl!))
    }
    
    func updateState(id: ServiceState, stepState: StepState) {
        for step in steps {
            if step.id == id {
                step.state = stepState
                verticalStepView?.updateStep(step: step)
                break
            }
        }
        mapVC.updateServiceState(state: id)
    }
    
    func newDriverLocation(location: CLLocationCoordinate2D) {
        mapVC.updateDriverLocation(location: location)
    }
    
    func getEta(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) {
        googleDirectionAPI.getDirection(origin: GoogleDirectionAPI.coordinatesToString(coordinate: fromLocation), destination: GoogleDirectionAPI.coordinatesToString(coordinate: toLocation), mode: nil).onSuccess { direction in
            if let direction = direction {
                self.mapVC.updateETA(eta: direction.getEta())
                self.timeWindowView.setETA(eta: direction.getEta())
            }
            }.onFailure { error in
                print("error")
        }
        
    }
    
}
