//
//  StateService.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

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
}

protocol StateServiceManagerProtocol: class {
    func stateDidChange(oldState: ServiceState, newState: ServiceState)
}
