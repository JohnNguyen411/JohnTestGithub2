//
//  Vehicle.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift
import Kingfisher

@objcMembers class Vehicle: Object, Codable {

    public static let vehicleImageHeight: CGFloat = 190

    var id: Int = -1
    var ownerId: Int = -1
    var vin: String?
    var licensePlate: String?
    var make: String?
    var model: String?
    var drive: String?
    var engine: String?
    var trim: String?
    var year: Int = 2018
    var baseColor: String?
    var color: String?
    var photoUrl: String?
    var transmission: String?
    var createdAt: Date?
    var updatedAt: Date?

    // Use Only for SwiftEventBus
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
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
        case createdAt = "created_at" //TODO: VLISODateTransform?
        case updatedAt = "updated_at" //TODO: VLISODateTransform?
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func vehicleDescription() -> String {
        if let color = color, color.count > 0 {
            return "\(color.capitalizingFirstLetter()) \(year) \(model ?? "")"
        }
        return "\(baseColor?.capitalizingFirstLetter() ?? "") \(year) \(model ?? "")"
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
