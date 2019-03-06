//
//  Dealership.swift
//  voluxe-driver
//
//  Created by Christoph on 10/22/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

struct Dealership: Codable {

    let id: Int
    let name: String
    let email: String
    let phoneNumber: String
    let location: Location
    let coverageRadius: Int
    let autoWeeklySchedulesCount: Int
    let cityId: Int
    let dailyLoanerVehicleCap: Int
    let enabled: Bool
    let preferredVehicleOdometerReadingUnit: String?
    let driverPickupScheduleBufferCustomer: Int?
    let driverDropffScheduleBufferCustomer: Int?
    let advisorPickupScheduleBufferCustomer: Int?
    let advisorDropoffScheduleBufferCustomer: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phoneNumber = "phone_number"
        case location
        case coverageRadius = "coverage_radius"
        case autoWeeklySchedulesCount = "auto_weekly_schedules_count"
        case cityId = "city_id"
        case dailyLoanerVehicleCap = "daily_loaner_vehicle_cap"
        case enabled
        case preferredVehicleOdometerReadingUnit = "preferred_vehicle_odometer_reading_unit"
        case driverPickupScheduleBufferCustomer = "driver_pickup_schedule_buffer_customer"
        case driverDropffScheduleBufferCustomer = "driver_dropff_schedule_buffer_customer"
        case advisorPickupScheduleBufferCustomer = "advisor_pickup_schedule_buffer_customer"
        case advisorDropoffScheduleBufferCustomer = "advisor_dropoff_schedule_buffer_customer"
    }
}
