//
//  Vehicle.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation

@objcMembers class Vehicle: NSObject, Codable {

    public static let vehicleImageHeight: CGFloat = 190

    dynamic var id: Int = -1
    dynamic var vin: String?
    dynamic var licensePlate: String?
    dynamic var make: String?
    dynamic var model: String?
    dynamic var drive: String?
    dynamic var engine: String?
    dynamic var trim: String?
    dynamic var year: Int = 2018
    dynamic var baseColor: String?
    dynamic var color: String?
    dynamic var photoUrl: String?
    dynamic var transmission: String?
    dynamic var createdAt: Date?
    dynamic var updatedAt: Date?

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
        case createdAt = "created_at" 
        case updatedAt = "updated_at" 
    }

    
    convenience required init(from decoder: Decoder) throws {
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
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }

    
    func encode(to encoder: Encoder) throws {
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
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
    
    
    func colorCode() -> String {
        if let color = baseColor {
            switch (color.lowercased()) {
            case "black": return "717"
            case "white": return "614"
            case "blue": return trim != nil && trim!.lowercased() == "r-design" ? "720" : "467"
            case "silver": return "711"
            case "grey": return "714"
            case "red": return "612"
            case "beige": return "719"
            case "brown": return "700"
            case "copper": return "700"
            default: return "614"
            }
        }
        return "614"
    }
    
    
    func vehicleDescription() -> String {
        if let color = color, color.count > 0 {
            return "\(color.capitalizingFirstLetter()) \(year) \(model ?? String.localized(.unknown))"
        }
        return "\(baseColor?.capitalizingFirstLetter() ?? "") \(year) \(model ?? String.localized(.unknown))"
    }
    
    func mileage() -> Int {
        return 13605
    }
    
    func localImageName() -> String {
        if model == "XC40" {
            return "image_xc40"
        }
        return "image_auto"
    }
    
    func setVehicleImage(imageView: UIImageView) {

        if let imageUrl = photoUrl, !imageUrl.isEmpty {
            let url = URL(string: imageUrl)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(named: localImageName())
        }
    }
}
