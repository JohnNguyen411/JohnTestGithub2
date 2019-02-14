//
//  DriveAPI+Driver.swift
//  voluxe-driver
//
//  Created by Christoph on 10/22/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

extension DriverAPI {

    static func me(completion: @escaping ((Driver?, LuxeAPIError?) -> Void)) {
        self.api.get(route: "v1/users/me") {
            response in
            let user = response?.decodeDriver()
            completion(user, response?.asError())
        }
    }

    static func dealerships(for driver: Driver,
                            completion: @escaping (([Dealership], LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driver.id)/dealerships"
        self.api.get(route: route) {
            response in
            let dealerships = response?.decodeDealerships() ?? []
            completion(dealerships, response?.asError())
        }
    }

    static func update(photo: UIImage,
                       for driver: Driver,
                       completion: @escaping ((LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driver.id)/photo"
        self.api.upload(route: route, image: photo) {
            response in
            completion(response?.asError())
        }
    }

    static func update(location: CLLocationCoordinate2D,
                       for driver: Driver, completion: @escaping ((LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driver.id)/location"
        let location = RestAPIResponse.APILocation(with: location)
        let data = try? JSONEncoder().encode(location)
        self.api.put(route: route, bodyJSON: data) {
            response in
            completion(response?.asError())
        }
    }

    static func register(device token: String,
                         for driver: Driver,
                         completion: @escaping ((LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driver.id)/devices/current"
        let identifier = UIDevice.current.identifierForVendor?.uuidString ?? "UDID unavailable"
        let parameters: RestAPIParameters = ["unique_identifier": identifier,
                                             "address": token,
                                             "os": "ios",
                                             "os_version": UIDevice.current.systemVersion]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            completion(response?.asError())
        }
    }

    // MARK:- Phone number updating

    static func update(phoneNumber: String,
                       for driver: Driver,
                       completion: @escaping ((LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driver.id)"
        let parameters: RestAPIParameters = ["work_phone_number": phoneNumber]
        self.api.patch(route: route, bodyParameters: parameters) {
            response in
            completion(response?.asError())
        }
    }

    static func requestPhoneNumberVerification(for driver: Driver,
                                               completion: @escaping ((LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driver.id)/work-phone-number/request-verification"
        self.api.put(route: route) {
            response in
            completion(response?.asError())
        }
    }

    static func verifyPhoneNumber(with code: String,
                                  for driver: Driver,
                                  completion: @escaping ((LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driver.id)/work-phone-number/verify"
        let parameters: RestAPIParameters = ["verification_code": code]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            completion(response?.asError())
        }
    }

    // MARK:- Password updating

    static func update(tempPassword: String,
                       newPassword: String,
                       for driver: Driver,
                       completion: @escaping ((LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driver.id)/password/change"
        let parameters: RestAPIParameters = ["password": tempPassword, "new_password": newPassword]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            completion(response?.asError())
        }
    }
}

// MARK:- Custom response decoding

private extension RestAPIResponse {

    private struct EncodedDriver: Codable {
        let data: Driver
    }

    func decodeDriver() -> Driver? {
        let driver: EncodedDriver? = self.decode()
        return driver?.data
    }

    private struct EncodedDealerships: Codable {
        let data: [Dealership]
    }

    func decodeDealerships() -> [Dealership] {
        let dealerships: EncodedDealerships? = self.decode()
        return dealerships?.data ?? []
    }

    struct APILocation: Codable {
        let location: Location
        init(with location: CLLocationCoordinate2D) {
            self.location = Location(address: "", latitude: location.latitude, longitude: location.longitude)
        }
    }
}
