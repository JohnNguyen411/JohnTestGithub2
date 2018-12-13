//
//  DriverAPI+Inspection.swift
//  voluxe-driver
//
//  Created by Christoph on 10/29/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension DriverAPI {

    static func createVehicleInspection(for request: Request,
                                        completion: @escaping ((Inspection?, LuxeAPIError.Code?) -> Void))
    {
        let route = "\(request.route)/vehicle-inspection"
        self.api.put(route: route) {
            response in
            completion(response?.asInspection(), response?.asErrorCode())
        }
    }

    // NOTE this only supports requests where type = .pickup
    // hence not using the self.api.path(for: request)
    static func createDocumentInspection(for request: Request,
                                         completion: @escaping ((Inspection?, LuxeAPIError.Code?) -> Void))
    {
        // TODO https://app.asana.com/0/858610969087925/935159618076286/f
        // TODO assert if not pickup
        guard request.isPickup else { return }
        let route = "\(request.route)/documents"
        self.api.post(route: route) {
            response in
            completion(response?.asInspection(), response?.asErrorCode())
        }
    }

    static func createLoanerInspection(for request: Request,
                                       completion: @escaping ((Inspection?, LuxeAPIError.Code?) -> Void))
    {
        let route = "\(request.route)/loaner-vehicle-inspection"
        self.api.put(route: route) {
            response in
            completion(response?.asInspection(), response?.asErrorCode())
        }
    }

    static func update(_ request: Request,
                       loanerMileage: UInt,
                       units: String,   // TODO need enum
                       completion: @escaping ((LuxeAPIError.Code?) -> Void))
    {
        let route = "\(request.route)/loaner-vehicle-odometer-reading"
        let parameters: RestAPIParameters = ["value": loanerMileage,
                                             "unit": units]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            completion(response?.asErrorCode())
        }
    }
}

fileprivate extension RestAPIResponse {

    struct InspectionResponse: Codable {
        let data: Inspection
    }

    func asInspection() -> Inspection? {
        let response: InspectionResponse? = self.decode()
        return response?.data
    }

    struct DocumentUpload: Codable {
        let request_document_id: Int
        let url: String
    }

    struct DocumentUploadResponse: Codable {
        let data: DocumentUpload
    }

    func asDocumentURL() -> String? {
        let response: DocumentUploadResponse? = self.decode()
        return response?.data.url
    }
}
