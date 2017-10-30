//
//  Vehicle.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 05/04/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import Foundation
import ObjectMapper

class Vehicle: NSObject, Mappable {

    var vin: String?
    var vinForAnalytics: String?
    var licensePlate: String?
    var model: String?
    var year: Int?
    var color: String?
    var baseColor: String?
    var transmission: TransmissionType?
    var trim: String?
    var image: UIImage?

    override init() {
        super.init()
    }

    init(vin: String, licensePlate: String?, model: String?, year: Int?, color: String?, transmission: TransmissionType?) {
        self.vin = vin
        self.licensePlate = licensePlate
        self.model = model
        self.year = year
        self.color = color
        self.transmission = transmission
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        vin <- map["vin"]
        licensePlate <- map["licensePlate"]
        model <- map["model"]
        year <- map["year"]
        color <- map["color"]
        baseColor <- map["baseColor"]
        transmission <- map["transmission"]
        trim <- map["trim"]
        vinForAnalytics <- map["vinForAnalytics"]
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

    func imageUrl(scale: Int) -> String! {
        let baseURL = Constants.VehicleImageBaseUrl
        let trimLevel = trim != nil ? trim!.lowercased().replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "-", with: "_") : ""
        let model = self.model != nil ? self.model! : ""
        let scaleFragment = "@\(scale)x/"

        let imageFragment = "\(model.lowercased())_\(trimLevel.lowercased())_\(colorCode()).jpg"
        let imageUrl = baseURL + scaleFragment + imageFragment
        return imageUrl
    }

}
