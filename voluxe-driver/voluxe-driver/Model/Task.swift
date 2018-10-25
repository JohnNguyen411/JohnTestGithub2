//
//  Task.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

enum Task: String, Codable {
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
}
