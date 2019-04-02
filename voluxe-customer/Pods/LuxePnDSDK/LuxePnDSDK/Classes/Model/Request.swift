//
//  Request.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

@objcMembers public class Request: NSObject, Codable {
    
    public dynamic var id: Int = -1
    public dynamic var bookingId: Int = -1
    public dynamic var timeslotId: Int = -1
    public dynamic var state: RequestState = .requested
    public dynamic var type: Type?
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?
    public dynamic var driver: Driver?
    public dynamic var location: Location?
    public dynamic var timeSlot: DealershipTimeSlot?
    
    // Driver Fields
    public dynamic var notes: String?
    public dynamic var booking: Booking?
    public dynamic var task: Task?
    public dynamic var driverDealershipTimeSlotAssignmentId: Int?
    public dynamic var driverDealershipTimeSlotAssignment: DriverDealershipTimeSlotAssignment?
    public dynamic var loanerVehicleRequested: Bool?
    public dynamic var loanerInspection: Inspection?
    public dynamic var loanerInspectionId: Int?
    public dynamic var vehicleInspectionId: Int?
    public dynamic var vehicleInspection: Inspection?
    public dynamic var documents: [Inspection]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case booking
        case bookingId = "booking_id"
        case timeslotId = "driver_dealership_time_slot_assignment_id"
        case location
        case timeSlot = "dealership_time_slot"
        case state
        case type
        case notes
        case driverAssignment = "driver_dealership_time_slot_assignment"
        case task
        case loanerVehicleRequested = "loaner_vehicle_requested"
        case loanerInspection = "loaner_vehicle_inspection"
        case vehicleInspectionId = "vehicle_inspection_id"
        case loanerInspectionId = "loaner_vehicle_inspection_id"
        case vehicleInspection = "vehicle_inspection"
        case documents
        case driver
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }
    
    convenience required public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.bookingId = try container.decodeIfPresent(Int.self, forKey: .bookingId) ?? -1
        self.timeslotId = try container.decodeIfPresent(Int.self, forKey: .timeslotId) ?? -1
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.timeSlot = try container.decodeIfPresent(DealershipTimeSlot.self, forKey: .timeSlot)
        self.state = try container.decodeIfPresent(RequestState.self, forKey: .state) ?? .requested
        self.type = try container.decodeIfPresent(Type.self, forKey: .type)
        
        if container.contains(.driverAssignment) {
            self.driverDealershipTimeSlotAssignment = try container.decode(DriverDealershipTimeSlotAssignment.self, forKey: .driverAssignment)
            
            if let driverAssignment = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .driverAssignment) {
                self.driver = try driverAssignment.decodeIfPresent(Driver.self, forKey: .driver)
            } else {
                self.driver = nil
            }
        } else {
            self.driver = nil
        }
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        self.booking = try container.decodeIfPresent(Booking.self, forKey: .booking)
        self.task = try container.decodeIfPresent(Task.self, forKey: .task)
        self.driverDealershipTimeSlotAssignmentId = try container.decodeIfPresent(Int.self, forKey: .timeslotId)
        self.loanerVehicleRequested = try container.decodeIfPresent(Bool.self, forKey: .loanerVehicleRequested)
        self.loanerInspection = try container.decodeIfPresent(Inspection.self, forKey: .loanerInspection)
        self.vehicleInspectionId = try container.decodeIfPresent(Int.self, forKey: .vehicleInspectionId)
        self.loanerInspectionId = try container.decodeIfPresent(Int.self, forKey: .loanerInspectionId)
        self.vehicleInspection = try container.decodeIfPresent(Inspection.self, forKey: .vehicleInspection)
        self.documents = try container.decodeIfPresent([Inspection].self, forKey: .documents)

    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(bookingId, forKey: .bookingId)
        try container.encode(timeslotId, forKey: .timeslotId)
        try container.encode(state, forKey: .state)
        try container.encode(location, forKey: .location)
        try container.encode(timeSlot, forKey: .timeSlot)
        try container.encode(type, forKey: .type)
        var driverAssignment = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .driverAssignment)
        try driverAssignment.encode(driver, forKey: .driver)
        try container.encodeIfPresent(booking, forKey: .booking)
        try container.encodeIfPresent(task, forKey: .task)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(driverDealershipTimeSlotAssignmentId, forKey: .timeslotId)
        try container.encodeIfPresent(driverDealershipTimeSlotAssignment, forKey: .driverAssignment)
        try container.encodeIfPresent(loanerVehicleRequested, forKey: .loanerVehicleRequested)
        try container.encodeIfPresent(loanerInspection, forKey: .loanerInspection)
        try container.encodeIfPresent(vehicleInspectionId, forKey: .vehicleInspectionId)
        try container.encodeIfPresent(loanerInspectionId, forKey: .loanerInspectionId)
        try container.encodeIfPresent(vehicleInspection, forKey: .vehicleInspection)
        try container.encodeIfPresent(documents, forKey: .documents)

    }
    
    public func isToday() -> Bool {
        if let timeSlot = timeSlot, let from = timeSlot.from {
            return Calendar.current.isDateInToday(from)
        }
        return false
    }
}

public enum RequestState: String, Codable {
    case canceled
    case completed
    case requested
    case started
}

public enum `Type`: String, Codable {
    case advisorPickup = "advisor_pickup"
    case advisorDropoff = "advisor_dropoff"
    case dropoff = "driver_dropoff"
    case pickup = "driver_pickup"
}
