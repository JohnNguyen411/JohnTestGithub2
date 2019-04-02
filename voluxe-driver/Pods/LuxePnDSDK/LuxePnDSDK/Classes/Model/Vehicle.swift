//
//  Vehicle.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation

@objcMembers public class Vehicle: NSObject, Codable {

    public static let vehicleImageHeight: CGFloat = 190

    public dynamic var id: Int = -1
    public dynamic var vin: String?
    public dynamic var licensePlate: String?
    public dynamic var make: String?
    public dynamic var model: String?
    public dynamic var drive: String?
    public dynamic var engine: String?
    public dynamic var trim: String?
    public dynamic var year: Int = 2018
    public dynamic var baseColor: String?
    public dynamic var color: String?
    public dynamic var photoUrl: String?
    public dynamic var transmission: String?
    public dynamic var keyTagCode: String?
    public dynamic var latestOdometerReading: OdometerReading?
    public dynamic var createdAt: Date?
    public dynamic var updatedAt: Date?

    // Use Only for SwiftEventBus
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vin
        case licensePlate = "license_plate"
        case make
        case model
        case drive
        case engine
        case trim
        case year
        case baseColor = "base_color"
        case color
        case photoUrl = "photo_url"
        case transmission
        case latestOdometerReading = "latest_odometer_reading"
        case keyTagCode = "key_tag_code"
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }

    
    convenience required public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.vin = try container.decodeIfPresent(String.self, forKey: .vin)
        self.licensePlate = try container.decodeIfPresent(String.self, forKey: .licensePlate)
        self.make = try container.decodeIfPresent(String.self, forKey: .make)
        self.model = try container.decodeIfPresent(String.self, forKey: .model)
        self.drive = try container.decodeIfPresent(String.self, forKey: .drive)
        self.engine = try container.decodeIfPresent(String.self, forKey: .engine)
        self.trim = try container.decodeIfPresent(String.self, forKey: .trim)
        self.year = try container.decodeIfPresent(Int.self, forKey: .year) ?? 2018
        self.baseColor = try container.decodeIfPresent(String.self, forKey: .baseColor)
        self.color = try container.decodeIfPresent(String.self, forKey: .color)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.transmission = try container.decodeIfPresent(String.self, forKey: .transmission)
        self.keyTagCode = try container.decodeIfPresent(String.self, forKey: .keyTagCode)
        self.latestOdometerReading = try container.decodeIfPresent(OdometerReading.self, forKey: .latestOdometerReading)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }

    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(vin, forKey: .vin)
        try container.encodeIfPresent(licensePlate, forKey: .licensePlate)
        try container.encodeIfPresent(make, forKey: .make)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(drive, forKey: .drive)
        try container.encodeIfPresent(engine, forKey: .engine)
        try container.encodeIfPresent(trim, forKey: .trim)
        try container.encodeIfPresent(year, forKey: .year)
        try container.encodeIfPresent(baseColor, forKey: .baseColor)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(transmission, forKey: .transmission)
        try container.encodeIfPresent(keyTagCode, forKey: .keyTagCode)
        try container.encodeIfPresent(latestOdometerReading, forKey: .latestOdometerReading)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
}
