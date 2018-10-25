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
    let phone_number: String
    let location: Location
    let coverage_radius: Int
    let auto_weekly_schedules_count: Int
    let city_id: Int
    let daily_loaner_vehicle_cap: Int
    let enabled: Bool
    // TODO need date type
    let created_at: String
    let registered_at: String
    let updated_at: String
    let driver_pickup_schedule_buffer_customer: Int?
    let driver_dropff_schedule_buffer_customer: Int?
    let advisor_pickup_schedule_buffer_customer: Int?
    let advisor_dropoff_schedule_buffer_customer: Int?
}
