//
//  Vehicle.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import RealmSwift
import Kingfisher

class Vehicle: Object, Mappable {
    
    public static let vehicleImageHeight: CGFloat = 190

    @objc dynamic var id: Int = -1
    @objc dynamic var ownerId: Int = -1
    @objc dynamic var vin: String?
    @objc dynamic var licensePlate: String?
    @objc dynamic var make: String?
    @objc dynamic var model: String?
    @objc dynamic var drive: String?
    @objc dynamic var engine: String?
    @objc dynamic var trim: String?
    @objc dynamic var year: Int = 2018
    @objc dynamic var baseColor: String?
    @objc dynamic var color: String?
    @objc dynamic var photoUrl: String?
    @objc dynamic var transmission: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var updatedAt: Date?

    // Use Only for SwiftEventBus
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        ownerId <- map["owner_id"]
        vin <- map["vin"]
        licensePlate <- map["license_plate"]
        make <- map["make"]
        model <- map["model"]
        drive <- map["drive"]
        engine <- map["engine"]
        trim <- map["trim"]
        year <- map["year"]
        baseColor <- map["base_color"]
        color <- map["color"]
        photoUrl <- map["photo_url"]
        transmission <- map["transmission"]
        createdAt <- (map["created_at"], VLISODateTransform())
        updatedAt <- (map["updated_at"], VLISODateTransform())
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
