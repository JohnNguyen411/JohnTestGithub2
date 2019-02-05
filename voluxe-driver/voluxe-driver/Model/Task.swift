//
//  Task.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

enum Task: String, Codable, CaseIterable {
    case unsupported
    case null
    case schedule
    case startRequest = "start_request"
    case retrieveLoanerVehicleFromDealership = "retrieve_loaner_vehicle_from_dealership"
    case retrieveForms = "retrieve_forms"
    case retrieveVehicleFromDealership = "retrieve_vehicle_from_dealership"
    case recordLoanerMileage = "record_loaner_mileage"
    case driveLoanerVehicleToCustomer = "drive_loaner_vehicle_to_customer"
    case driveVehicleToCustomer = "drive_vehicle_to_customer"
    case getToCustomer = "get_to_customer"
    case meetWithCustomer = "meet_with_customer"
    case inspectDocuments = "inspect_documents"
    case inspectLoanerVehicle = "inspect_loaner_vehicle"
    case inspectVehicle = "inspect_vehicle"
    case inspectNotes = "inspect_notes"
    case exchangeKeys = "exchange_keys"
    case driveLoanerVehicleToDealership = "drive_loaner_vehicle_to_dealership"
    case driveVehicleToDealership = "drive_vehicle_to_dealership"
    case receiveLoanerVehicle = "receive_loaner_vehicle"
    case getToDealership = "get_to_dealership"
    
    
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
    
    static func nextTask(for task: Task, request: Request) -> Task? {
        
        if request.isPickup {
            if task == .schedule {
                if request.hasLoaner {
                    return .retrieveLoanerVehicleFromDealership
                } else {
                    return .retrieveForms
                }
            } else if task == .retrieveForms {
                return .getToCustomer
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
            } else if task == .recordLoanerMileage || task == .getToDealership {
                return .null
            }
        }
        
        return nil
    }
    
}

/*
 Task supported by backend:
 /**
 * checks if the next task is supported on backend
 */
 fun isNextTaskSupported(nextRequestTask: String?): Boolean {
 return when (nextRequestTask) {
 Request.TASK_RETRIEVE_LOANER_VEHICLE_FROM_DEALERSHIP,
 Request.TASK_RETRIEVE_VEHICLE_FROM_DEALERSHIP,
 Request.TASK_DRIVE_LOANER_VEHICLE_TO_CUSTOMER,
 Request.TASK_DRIVE_VEHICLE_TO_CUSTOMER,
 Request.TASK_GET_TO_CUSTOMER,
 Request.TASK_MEET_WITH_CUSTOMER,
 Request.TASK_INSPECT_LOANER_VEHICLE,
 Request.TASK_INSPECT_VEHICLE,
 Request.TASK_EXCHANGE_KEYS,
 Request.TASK_DRIVE_LOANER_VEHICLE_TO_DEALERSHIP,
 Request.TASK_DRIVE_VEHICLE_TO_DEALERSHIP,
 Request.TASK_GET_TO_DEALERSHIP,
 Request.TASK_NULL,
 null -> {
 true
 }
 else -> {
 false
 }
 }
 }
 */
