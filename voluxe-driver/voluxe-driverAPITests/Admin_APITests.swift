//
//  Admin_APITests.swift
//  voluxe-driverAPITests
//
//  Created by Christoph on 1/8/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import XCTest

class Admin_APITests: XCTestCase {

    static var timeslots: [DealershipTimeSlot] = []
    static var assignments: [DriverDealershipTimeSlotAssignment] = []
    static let driverId = 40
//    static let requestId = 1255 // cancelled
    static let requestId = 1330 // pickup
//    static let requestId = 1332 // pickup
//    static let requestId = 1282 // pickup
//    static let requestId = 1258 // dropoff
//    static let requestId = 1277 // dropoff

    func test00_loginAdmin() {
        AdminAPI.login(email: "bots@luxe.com", password: "1234qwer") {
            error in
            XCTAssertNil(error)
            XCTAssertNotNil(AdminAPI.api.token)
        }
        self.wait()
    }

    func test10_dealershipTimeslots() {
//        AdminAPI.timeslots(dealership: 1) {
//            timeslots, error in
//            XCTAssertNil(error)
//            Admin_APITests.timeslots = timeslots
//        }
        self.wait()
    }

    func test20_driverTimeSlotAssignments() {
//        guard let timeslot = Admin_APITests.timeslots.last else {
//            XCTFail("dealership time slot required")
//            return
//        }
//        AdminAPI.driverTimeSlotAssignments(timeslot: timeslot.id) {
//            assignments, error in
//            XCTAssertNil(error)
//            Admin_APITests.assignments = assignments
//        }
        self.wait()
    }

    func test30_assignDriverToTimeSlotAndRequest() {

        let assignments = Admin_APITests.assignments.filter { $0.driverId == nil }
        guard let assignment = assignments.first else { XCTFail(); return }

        AdminAPI.api.patch(route: "v1/driver-dealership-time-slot-assignments/\(assignment.id)",
                           bodyParameters: ["driver_id": Admin_APITests.driverId])
        {
            response in
            XCTAssertNil(response?.asError())
        }

        AdminAPI.api.put(route: "v1/driver-pickup-requests/\(Admin_APITests.requestId)/driver-dealership-time-slot-assignment",
                         bodyParameters: ["driver_dealership_time_slot_assignment_id": assignment.id])
        {
            response in
            XCTAssertNil(response?.asError())
        }

        self.wait()
    }
}
