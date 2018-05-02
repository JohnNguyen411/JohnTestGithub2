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
/*
    func imageUrl(scale: Int) -> String! {
        let baseURL = Constants.VehicleImageBaseUrl
        let trimLevel = trim != nil ? trim!.lowercased().replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "-", with: "_") : ""
        let model = self.model != nil ? self.model! : ""
        let scaleFragment = "@\(scale)x/"

        let imageFragment = "\(model.lowercased())_\(trimLevel.lowercased())_\(colorCode()).jpg"
        let imageUrl = baseURL + scaleFragment + imageFragment
        return imageUrl
    }
 */
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func vehicleDescription() -> String {
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

        // TODO https://github.com/volvo-cars/ios/issues/86
        // remove code to only use real photoURL
        imageView.image = UIImage(named: localImageName())
//        if var imageUrl = photoUrl, !imageUrl.isEmpty {
//            if imageUrl.contains("http://") {
//                imageUrl = imageUrl.replacingOccurrences(of: "http://", with: "https://")
//            }
//            let url = URL(string: imageUrl)
//            imageView.kf.setImage(with: url)
//        } else {
//            imageView.image = UIImage(named: localImageName())
//        }
    }
}
