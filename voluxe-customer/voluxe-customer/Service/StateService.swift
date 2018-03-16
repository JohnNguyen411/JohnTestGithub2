//
//  StateService.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SwiftEventBus

final class StateServiceManager {
    
    private var delegates: [StateServiceManagerProtocol] = []
    private var state: ServiceState
    
    static let sharedInstance = StateServiceManager(state: .noninit)

    init(state: ServiceState) {
        self.state = state
    }
    
    func updateState(state: ServiceState) {
        if self.state != state {
            // state did change
            let oldState = self.state
            self.state = state
            delegates.forEach {delegate in
                delegate.stateDidChange(oldState: oldState, newState: state)
            }
            
            BookingSyncManager.sharedInstance.syncBooking()
        } else if state == .enRouteForDropoff || state == .enRouteForPickup || state == .nearbyForPickup || state == .nearbyForDropoff {
            // update driver's location
            SwiftEventBus.post("driverLocationUpdate")
        }
    }
    
    func addDelegate(delegate: StateServiceManagerProtocol) {
        delegates.append(delegate)
    }
    
    func removeDelegate(delegate: StateServiceManagerProtocol) {
        if let index = delegates.index(where: { $0 === delegate }) {
            delegates.remove(at: index)
        }
    }
    
    func getState() -> ServiceState {
        return state
    }
    
    func isPickup() -> Bool {
        return ServiceState.isPickup(state: state)
    }
}

protocol StateServiceManagerProtocol: class {
    func stateDidChange(oldState: ServiceState, newState: ServiceState)
}
