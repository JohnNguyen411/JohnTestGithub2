//
//  SchedulePickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/3/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

class SchedulePickupViewController: BaseViewController {
    
    let scrollView = UIScrollView()
    let scheduledServiceView = VLTitledLabel()
    let descriptionButton = VLButton(type: .BlueSecondary, title: (.ShowDescription as String).uppercased(), actionBlock: nil)
    let dealershipView = VLTitledLabel()
    let scheduledPickupView = VLTitledLabel()
    let pickupLocationView = VLTitledLabel()
    let loanerView = VLTitledLabel()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionButton.setActionBlock {
            self.showDescriptionClick()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(scheduledServiceView)
        scrollView.addSubview(descriptionButton)
        scrollView.addSubview(dealershipView)
        scrollView.addSubview(scheduledPickupView)
        scrollView.addSubview(pickupLocationView)
        scrollView.addSubview(loanerView)
        
        
        
    }
    
    func showDescriptionClick() {
        
    }
    
}
