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

class ScheduledPickupViewController: BaseViewController {
    
    var verticalStepView: GroupedVerticalStepView? = nil
    var steps: [Step] = []
    
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
    }
    
    override func setupViews() {
        super.setupViews()
        
        if let verticalStepView = verticalStepView {
            self.view.addSubview(verticalStepView)
            
            verticalStepView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(verticalStepView.height)
            }
        }
    }
    
}
