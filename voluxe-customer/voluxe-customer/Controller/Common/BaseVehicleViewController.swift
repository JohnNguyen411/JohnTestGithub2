//
//  BaseVehicleViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 7/19/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SwiftEventBus

class BaseVehicleViewController: BaseViewController {
    
    var serviceState: ServiceState

    let vehicle: Vehicle
    let vehicleId: Int
    
    init(vehicle: Vehicle, state: ServiceState, screen: AnalyticsEnums.Name.Screen? = nil) {
        self.serviceState = state
        self.vehicle = vehicle
        self.vehicleId = vehicle.id
        super.init(screen: screen)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftEventBus.onMainThread(self, name:"stateDidChange") {
            result in
            guard let stateChange: StateChangeObject = result?.object as? StateChangeObject else { return }
            if !self.vehicle.isInvalidated {
                self.stateDidChange(vehicleId: stateChange.vehicleId, oldState: stateChange.oldState, newState: stateChange.newState)
            }
        }
    }
    
    deinit {
        SwiftEventBus.unregister(self)
    }
    
    func stateDidChange(vehicleId: Int, oldState: ServiceState?, newState: ServiceState) {
        if vehicleId != vehicle.id {
            return
        }
        stateDidChange(state: newState)
    }
    
}
