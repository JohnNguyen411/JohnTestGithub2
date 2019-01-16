//
//  AdminAPI+Request.swift
//  voluxe-driver
//
//  Created by Christoph on 1/8/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation

extension AdminAPI {

    static func timeslots(dealership: Int,
                          completion: @escaping (([DealershipTimeSlot], LuxeAPIError?) -> ()))
    {
        let route = "v1/dealerships/\(dealership)/time-slots/scheduled"
        let start = DateFormatter.utcISO8601.string(from: Date.earliestToday())
        let end = DateFormatter.utcISO8601.string(from: Date.latestToday())
        let parameters: RestAPIParameters = ["type": "driver",
                                             "start": start,
                                             "end": end,
                                             "compute[0]": "available_assignment_count"]
        AdminAPI.api.get(route: route, queryParameters: parameters) {
            response in
            completion(response?.asDealershipTimeSlots() ?? [], response?.asError())
        }
    }

    static func driverTimeSlotAssignments(timeslot: Int,
                                completion: @escaping (([DriverDealershipTimeSlotAssignment], LuxeAPIError?) -> ()))
    {
        let route = "v1/driver-dealership-time-slot-assignments"
        let parameters: RestAPIParameters = ["dealership_time_slot_id": timeslot,
                                             "limit": 100]
        AdminAPI.api.get(route: route, queryParameters: parameters) {
            response in
            completion(response?.asDriverTimeSlotAssignments() ?? [], response?.asError())
        }
    }

    static func requests(driverId: Int,
                         from fromDate: Date,
                         to toDate: Date,
                         completion: @escaping (([Request], LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driverId)/requests"
        let fromString = DateFormatter.utcISO8601.string(from: fromDate)
        let toString = DateFormatter.utcISO8601.string(from: toDate)
        let parameters: RestAPIParameters = ["start": fromString,
                                             "end": toString]
        self.api.get(route: route, queryParameters: parameters) {
            response in
            let requests = response?.asRequests() ?? []
            completion(requests, response?.asError())
        }
    }
}

fileprivate extension RestAPIResponse {

    struct DealershipTimeSlots: Codable {
        let data: [DealershipTimeSlot]
    }

    func asDealershipTimeSlots() -> [DealershipTimeSlot] {
        let response: DealershipTimeSlots? = self.decode()
        return response?.data ?? []
    }

    struct DriverTimeSlotAssignments: Codable {
        let data: [DriverDealershipTimeSlotAssignment]
    }

    func asDriverTimeSlotAssignments() -> [DriverDealershipTimeSlotAssignment] {
        let response: DriverTimeSlotAssignments? = self.decode()
        return response?.data ?? []
    }

    private struct Requests: Codable {
        let data: [Request]
    }

    func asRequests() -> [Request] {
        let response: Requests? = self.decode()
        return response?.data ?? []
    }
}
