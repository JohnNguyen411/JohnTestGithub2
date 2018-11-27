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

    // NOTE this only supports requests where type = .pickup
    // hence not using the self.api.path(for: request)
    static func createDocumentInspection(for request: Request,
                                         completion: @escaping ((Inspection?, LuxeAPIError.Code?) -> Void))
    {
        // TODO does this need to confirm request.type == .pickup?
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

    // TODO how does this relate to UploadManager?
    static func upload(photo: UIImage,
                       inspection: Inspection,
                       request: Request,
                       completion: @escaping ((String?, LuxeAPIError.Code?) -> Void))
    {
        guard let path = self.api.path(for: request) else { return }
        let route = "/v1/\(path)/\(request.id)/documents/\(inspection.id)/photos"
        self.api.upload(route: route, image: photo) {
            response in
            completion(response?.asDocumentURL(), response?.asErrorCode())
        }
    }

    // TODO find a better place for this
    static func routeToUploadPhoto(inspection: Inspection,
                                   request: Request) -> String?
    {
        guard let path = self.api.path(for: request) else { return nil }
        let route = "/v1/\(path)/\(request.id)/documents/\(inspection.id)/photos"
        return route
    }

    // TODO find a better place for this
    static func urlToUploadPhoto(inspection: Inspection,
                                 request: Request) -> String?
    {
        guard let route = self.routeToUploadPhoto(inspection: inspection, request: request) else { return nil }
        let url = self.api.urlFromHost(for: route)
        return url
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
