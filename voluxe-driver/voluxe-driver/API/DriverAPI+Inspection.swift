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
        guard let path = self.api.path(for: request) else { return }
        let route = "v1/\(path)/\(request.id)/vehicle-inspection"
        self.api.put(route: route) {
            response in
            completion(response?.asInspection(), response?.asErrorCode())
        }
    }

    static func createDocumentInspection(for request: Request,
                                         completion: @escaping ((Inspection?, LuxeAPIError.Code?) -> Void))
    {
        let route = "v1/driver-pickup-requests/\(request.id)/documents"
        self.api.post(route: route) {
            response in
            completion(response?.asInspection(), response?.asErrorCode())
        }
    }

    static func createLoanerInspection(for request: Request,
                                       completion: @escaping ((Inspection?, LuxeAPIError.Code?) -> Void))
    {
        guard let path = self.api.path(for: request) else { return }
        let route = "v1/\(path)/\(request.id)/loaner-vehicle-inspection"
        self.api.put(route: route) {
            response in
            completion(response?.asInspection(), response?.asErrorCode())
        }
    }

    static func upload(photo: UIImage,
                       inspection: Inspection,
                       request: Request,
                       completion: @escaping ((String?, LuxeAPIError.Code?) -> Void))
    {
        let route = "/v1/driver-pickup-requests/\(request.id)/documents/\(inspection.id)/photos"
        self.api.upload(route: route, image: photo) {
            response in
            completion(response?.asDocumentURL(), response?.asErrorCode())
        }
    }

    static func update(_ request: Request,
                       loanerMileage: UInt,
                       units: String,   // TODO need enum
                       completion: @escaping ((LuxeAPIError.Code?) -> Void))
    {
        guard let path = self.api.path(for: request) else { return }
        let route = "/v1/\(path)/\(request.id)/loaner-vehicle-odometer-reading"
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
