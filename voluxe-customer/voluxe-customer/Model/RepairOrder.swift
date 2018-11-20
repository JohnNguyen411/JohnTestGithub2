//
//  RepairOrder.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class RepairOrder: Object, Codable {
    
    dynamic var id: Int = -1
    dynamic var bookingId: Int = -1
    dynamic var dealershipRepairOrderId: Int = -1
    dynamic var notes: String = ""
    dynamic var state: String?
    dynamic let vehicleDrivable = RealmOptional<Bool>()
    dynamic var repairOrderType: RepairOrderType?
    dynamic var name: String?
    dynamic var title: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?
    
    convenience init(title: String, repairOrderType: RepairOrderType, customerDescription: String, drivable: Bool?) {
        self.init()
        self.name = title
        self.title = title
        self.repairOrderType = repairOrderType
        self.notes = customerDescription
        if let drivable = drivable {
            self.vehicleDrivable.value = drivable
        } else {
            self.vehicleDrivable.value = nil
        }
    }
    
    convenience init(repairOrderType: RepairOrderType) {
        self.init()
        self.title = repairOrderType.name
        self.name = repairOrderType.name
        if repairOrderType.getCategory() == .custom {
            self.name = String.DiagnosticInspection
        }
        self.repairOrderType = repairOrderType
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /*
 
     
     DECODE ERROR: keyNotFound(CodingKeys(stringValue: "desc", intValue: nil), Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "data", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0)], debugDescription: "No value associated with key CodingKeys(stringValue: \"desc\", intValue: nil) (\"desc\").", underlyingError: nil))
     
     
     data: {"meta":{"limit":10,"offset":0,"count":10,"request_id":"aba9ea21-c08d-4ddc-9f20-5b21996c6421"},"data":[{"id":1,"name":"10,000 mile check-up","description":"Maintenance made simple\nGreater convenience—paid for in advance. Service is performed by Volvo trained technicians, using the latest procedures, specialized tools and Volvo Genuine Parts.\n\nService Operations Performed:\n• Engine oil and filter: replace\n• Service Reminder Indicator (SRI): reset\n• Coolant level: check/adjust\n• Power steering fluid level: check/adjust\n• Washer fluid level: check/adjust\n• Wiper blades and washers: check/adjust\n• External lighting: check\n• Horn, parking brake, seatbelts: check function\n• Windshield and front camera: clean\n• Brake fluid level: check/adjust\n• Brake pads/discs: check\n• Wheels and tires: check pressure/wear/condition\n• Spare tire: check","created_at":"2018-02-16T22:54:40.000Z","updated_at":"2018-07-08T16:23:15.000Z","category":"routine_maintenance_by_distance"},{"id":2,"name":"20,000 mile check-up","description":"Maintenance made simple\nGreater convenience—paid for in advance. Service is performed by Volvo trained technicians, using the latest procedures, specialized tools and Volvo Genuine Parts.\n\nService Operations Performed:\n• Engine oil and filter: replace\n• Engine, transmission, timing gear: check\n• Service Reminder Indicator (SRI): reset\n• Coolant level: check/adjust\n• Power steering fluid level: check/adjust\n• Washer fluid level: check/adjust\n• Wiper blades and washers: check/adjust\n• External lighting: check\n• Headlights, fog lights: check/adjust\n• Horn, parking brake, seatbelts: check function\n• Cabin air filter: replace\n• Windshield and front camera: clean\n• Brake fluid level: check/adjust\n• Brake pads/discs: check\n• Wheels and tires: check pressure/wear/condition\n• Spare tire: check","created_at":"2018-02-16T22:54:40.000Z","updated_at":"2018-07-08T16:23:37.000Z","category":"routine_maintenance_by_distance"},{"id":3,"name":"30,000 mile check-up","description":"Maintenance made simple\nGreater convenience—paid for in advance. Service is performed by Volvo trained technicians, using the latest procedures, specialized tools and Volvo Genuine Parts.\n\nService Operations Performed:\n• Engine oil and filter: replace\n• Engine, transmission, timing gear: check\n• Service Reminder Indicator (SRI): reset\n• Coolant level: check/adjust\n• Power steering fluid level: check/adjust\n• Washer fluid level: check/adjust\n• Wiper blades and washers: check/adjust\n• External lighting: check\n• Horn, parking brake, seatbelts: check function\n• Windshield and front camera: clean\n• Brake fluid level: check/adjust\n• Brake pads/discs: check\n• Wheels and tires: check pressure/wear/condition\n• Spare tire: check","created_at":"2018-02-16T22:54:40.000Z","updated_at":"2018-07-08T16:23:41.000Z","category":"routine_maintenance_by_distance"},{"id":4,"name":"40,000 mile check-up","description":"Maintenance made simple\nService is performed by Volvo trained technicians, using the latest procedures, specialized tools and Volvo Genuine Parts.\n\nService Operations Performed:\n• Engine oil and filter: replace\n• Service Reminder Indicator (SRI): reset\n• Fuel lines and filter: check\n• Engine air cleaner: clean/replace filter\n• Coolant level: check/adjust\n• Power steering fluid level: check/adjust\n• Steering, suspensions: check wear/alignments\n• Transmission, driveshaft, differential: check\n• Washer fluid level: check/adjust\n• Wiper blades and washers: check/adjust\n• External lighting: check\n• Headlights, fog lights: check/adjust\n• Horn, parking brake, seatbelts: check function\n• Cabin air filter: replace\n• Windshield and front camera: clean\n• Brake fluid: replace\n• Brake pads/discs, lines, hoses: check\n• Wheels and tires: check pressure/wear/condition\n• Spare tire: check","created_at":"2018-02-16T22:54:40.000Z","updated_at":"2018-07-08T16:23:42.000Z","category":"routine_maintenance_by_distance"},{"id":5,"name":"50,000 mile check-up","description":"Maintenance made simple\nService is performed by Volvo trained technicians, using the latest procedures, specialized tools and Volvo Genuine Parts.\n\nService Operations Performed:\n• Engine oil and filter: replace\n• Service Reminder Indicator (SRI): reset\n• Coolant level: check/adjust\n• Power steering fluid level: check/adjust\n• Transmission fluid: check/adjust\n• Washer fluid level: check/adjust\n• Wiper blades and washers: check/adjust\n• External lighting: check\n• Horn, parking brake, seatbelts: check function\n• Windshield and front camera: clean\n• Brake fluid level: check/adjust\n• Brake pads/discs: check\n• Wheels and tires: check pressure/wear/condition\n• Spare tire: check","created_at":"2018-02-16T22:54:40.000Z","updated_at":"2018-07-08T16:23:43.000Z","category":"routine_maintenance_by_distance"},{"id":6,"name":"60,000 mile check-up","description":"Maintenance made simple\nService is performed by Volvo trained technicians, using the latest procedures, specialized tools and Volvo Genuine Parts.\n\nService Operations Performed:\n• Engine oil and filter: replace\n• Engine, transmission, timing gear: check\n• Service Reminder Indicator (SRI), reset\n• Spark plugs: replace\n• Coolant level, check/adjust\n• Power steering fluid level, check/adjust\n• Washer fluid level, check/adjust\n• Wiper blades and washers, check/adjust\n• External lighting: check\n• Headlights, fog lights: check/adjust\n• Horn, parking brake, seatbelts: check function\n• Cabin air filter: replace\n• Windshield and front camera: clean\n• Brake fluid level, check/adjust\n• Brake pads/discs, check\n• Wheels and tires, check pressure/wear/condition\n• Spare tire: check","created_at":"2018-02-16T22:54:40.000Z","updated_at":"2018-07-08T16:23:45.000Z","category":"routine_maintenance_by_distance"},{"id":7,"name":"100,000 mile check-up","description":"Maintenance made simple\nService is performed by Volvo trained technicians, using the latest procedures, specialized tools and Volvo Genuine Parts.\n\nService Operations Performed:\n• Engine oil and filter: replace\n• Engine, transmission, timing gear: check\n• Service Reminder Indicator (SRI): reset\n• Fuel lines and filter: check\n• Engine air cleaner: clean/replace filter\n• Coolant level: check/adjust\n• Power steering fluid level: check/adjust\n• Transmission fluid: check/adjust\n• Washer fluid level: check/adjust\n• Wiper blades and washers: check/adjust\n• External lighting: check\n• Headlights, fog lights: check/adjust\n• Horn, parking brake, seatbelts: check function\n• Cabin air filter: replace\n• Windshield and front camera: clean\n• Brake fluid level: check/adjust\n• Brake pads/discs: check\n• Wheels and tires: check pressure/wear/condition\n• Spare tire: check","created_at":"2018-02-16T22:54:40.000Z","updated_at":"2018-07-08T16:22:14.000Z","category":"routine_maintenance_by_distance"},{"id":8,"name":"Other warranties or milestone services…","description":"Maintenance made simple\nService is performed by Volvo trained technicians, using the latest procedures, specialized tools and Volvo Genuine Parts. \n\nFor information about other warranties or milestone services not listed previously, book your service here, and check with the dealership for service details.","created_at":"2018-07-06T22:26:37.000Z","updated_at":"2018-07-08T16:22:35.000Z","category":"routine_maintenance_by_distance"},{"id":9,"name":"Recall","description":"Warranty recall","created_at":"2018-11-14T03:28:13.000Z","updated_at":"2018-11-14T03:28:13.000Z","category":"other"},{"id":10,"name":"Battery Replacement","description":"Battery Replacement (1000kWh)","created_at":"2018-11-14T03:28:45.000Z","updated_at":"2018-11-14T03:28:45.000Z","category":"other"}]}
     
     */
    
    private enum CodingKeys: String, CodingKey {
        case id
        case bookingId = "booking_id"
        case dealershipRepairOrderId = "dealership_repair_order_id"
        case notes
        case state
        case vehicleDrivable = "vehicle_drivable" //TODO check nested object parsin
        case repairOrderType = "dealership_repair_order.repair_order_type"
        case name = "dealership_repair_order.repair_order_type.name"
        case title
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
    }
    
    static func getDrivabilityTitle(isDrivable: Bool?) -> String {
        if let drivable = isDrivable {
            if drivable {
                return .Yes
            } else {
                return .No
            }
        } else {
            return .ImNotSure
        }
    }
    
    func getTitle() -> String {
        if let title = title {
            return title
        } else {
            if let repairOrderType = repairOrderType, let typeName = repairOrderType.name {
                return typeName
            }
        }
        return ""
    }
}
