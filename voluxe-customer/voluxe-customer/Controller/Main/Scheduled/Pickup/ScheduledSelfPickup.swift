//
//  ScheduledSelfPickup.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 9/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class ScheduledSelfPickup: ScheduledSelfViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle(title: .DropoffAtDealership)
        scheduleDeliveryButton.isHidden = true
        deliveryLabel.isHidden = true
        
    }
}
