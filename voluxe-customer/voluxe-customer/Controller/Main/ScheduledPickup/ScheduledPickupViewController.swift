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
    
    private static let mapViewHeight = 200
    private static let driverViewHeight = 50

    private var verticalStepView: GroupedVerticalStepView? = nil
    private var steps: [Step] = []
    
    private let mapVC = MapViewController()
    private let mapViewContainer = UIView(frame: .zero)
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        generateSteps()
        verticalStepView = GroupedVerticalStepView(steps: steps)
    }
    
    func generateSteps() {
        let step1 = Step(id: 0, text: .ServiceScheduled, state: .done)
        let step2 = Step(id: 1, text: .DriverEnRoute)
        let step3 = Step(id: 2, text: .DriverNearby)
        let step4 = Step(id: 3, text: .DriverArrived)
        
        steps.append(step1)
        steps.append(step2)
        steps.append(step3)
        steps.append(step4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapVC.updateRequestLocation(location: ScheduledPickupViewController.officeLocation)
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
        })
         */
    }
    
    override func setupViews() {
        super.setupViews()
        
        mapViewContainer.backgroundColor = .white
        
        if let verticalStepView = verticalStepView {
            self.view.addSubview(verticalStepView)
            self.view.addSubview(mapViewContainer)
            
            verticalStepView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(30)
                make.top.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(verticalStepView.height)
            }
            
            mapViewContainer.snp.makeConstraints { make in
                make.left.right.equalTo(verticalStepView)
                make.top.equalTo(verticalStepView.snp.bottom)
                make.height.equalTo(ScheduledPickupViewController.mapViewHeight + ScheduledPickupViewController.driverViewHeight)
            }
            
            mapViewContainer.addSubview(mapVC.view)
            mapVC.view.snp.makeConstraints { (make) -> Void in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(ScheduledPickupViewController.mapViewHeight)
            }
            
        }
    }
    
}
