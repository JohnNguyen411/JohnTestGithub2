//
//  Task+Flow.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/7/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension Task {
    
    static func isGreater(_ startTask: Task, than task: Task) -> Bool {
        
        var startTaskIndex = -1
        var endTaskIndex = -1
        for (index, task) in Task.allCases.enumerated() {
            if task == startTask {
                startTaskIndex = index
            }
            if task == task {
                endTaskIndex = index
            }
        }
        
        return startTaskIndex > endTaskIndex
        
    }
    
    static func nextTask(for task: Task, request: Request) -> Task {
        
        if request.isPickup {
            if task == .schedule {
                if request.hasLoaner {
                    return .retrieveLoanerVehicleFromDealership
                } else {
                    return .retrieveForms
                }
            } else if task == .retrieveForms {
                return .getToCustomer
            } else if task == .getToCustomer {
                return .meetWithCustomer
            } else if task == .retrieveLoanerVehicleFromDealership {
                return .recordLoanerMileage
            } else if task == .recordLoanerMileage {
                return .driveLoanerVehicleToCustomer
            } else if task == .driveLoanerVehicleToCustomer {
                return .meetWithCustomer
            } else if task == .meetWithCustomer {
                if request.hasLoaner {
                    return .inspectLoanerVehicle
                } else {
                    return .inspectVehicle
                }
            } else if task == .inspectLoanerVehicle {
                return .inspectVehicle
            } else if task == .inspectVehicle {
                return .inspectDocuments
            } else if task == .inspectDocuments {
                return .inspectNotes
            } else if task == .inspectNotes {
                return .exchangeKeys
            } else if task == .exchangeKeys {
                return .driveVehicleToDealership
            } else if task == .getToDealership {
                return .null
            } else if task == .driveVehicleToDealership {
                return .null
            }
        } else {
            // delivery flow
            if task == .schedule {
                return .retrieveVehicleFromDealership
            } else if task == .retrieveVehicleFromDealership {
                return .driveVehicleToCustomer
            } else if task == .driveVehicleToCustomer {
                return .meetWithCustomer
            } else if task == .meetWithCustomer {
                return .inspectVehicle
            } else if task == .inspectVehicle {
                if request.hasLoaner {
                    return .receiveLoanerVehicle
                } else {
                    return .exchangeKeys
                }
            } else if task == .receiveLoanerVehicle {
                return .inspectLoanerVehicle
            } else if task == .inspectLoanerVehicle {
                return .exchangeKeys
            } else if task == .exchangeKeys {
                if request.hasLoaner {
                    return .driveLoanerVehicleToDealership
                } else {
                    return .getToDealership
                }
            } else if task == .driveLoanerVehicleToDealership {
                return .recordLoanerMileage
            } else if task == .recordLoanerMileage || task == .getToDealership || task == .getToDealership {
                return .null
            }
        }
        
        return .null
    }
    
}
