//
//  DriverAPI+Request.swift
//  voluxe-driver
//
//  Created by Christoph on 10/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

extension DriverAPI {

    static func today(for driver: Driver,
                      completion: @escaping (([Request], LuxeAPIError.Code?) -> Void)) {
        let route = "v1/drivers/\(driver.id)/requests/today"
        self.api.get(route: route) {
            response in
            let requests = response?.asRequests() ?? []
            completion(requests, response?.asErrorCode())
        }
    }

    static func requests(for driver: Driver,
                         from fromDate: Date,
                         to toDate: Date,
                         completion: @escaping (([Request], LuxeAPIError?) -> Void))
    {
        let route = "v1/drivers/\(driver.id)/requests"
        let fromString = DateFormatter.utcISO8601.string(from: fromDate)
        let toString = DateFormatter.utcISO8601.string(from: toDate)
        let parameters: RestAPIParameters = ["start": fromString,
                                             "end": toString]
        self.api.get(route: route, queryParameters: parameters) {
            response in
            let requests = response?.asRequests() ?? []
            completion(requests, response?.asError())
        }
    }

    static func refresh(_ request: Request,
                        completion: @escaping ((Request?, LuxeAPIError.Code?) -> Void))
    {
        self.api.get(route: request.route) {
            response in
            completion(response?.asRequest(), response?.asErrorCode())
        }
    }

    static func update(_ request: Request,
                       task: Task,
                       completion: @escaping ((LuxeAPIError.Code?) -> Void))
    {
        let route = "\(request.route)/task"
        let parameters: RestAPIParameters = ["task": task == .null ? NSNull() : task.rawValue]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            completion(response?.asErrorCode())
        }
    }

    static func update(_ request: Request,
                       notes: String,
                       completion: @escaping ((LuxeAPIError.Code?) -> Void))
    {
        let route = "\(request.route)/notes"
        let parameters: RestAPIParameters = ["notes": notes]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            completion(response?.asErrorCode())
        }
    }

    static func contactCustomer(_ request: Request,
                                completion: @escaping ((String?, String?, LuxeAPIError.Code?) -> Void))
    {
        let route = "\(request.route)/contact-customer"
        let parameters: RestAPIParameters = ["mode": "text_only"]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            let (textNumber, phoneNumber) = response?.asPhoneNumbers() ?? (nil, nil)
            completion(textNumber, phoneNumber, response?.asErrorCode())
        }
    }
}

// MARK:- Extension for request path

extension Request {

    var route: String {
        switch self.type {
            case .advisorPickup: return "v1/advisor-pickup-requests/\(self.id)"
            case .advisorDropoff: return "v1/advisor-dropoff-requests/\(self.id)"
            case .dropoff: return "v1/driver-dropoff-requests/\(self.id)"
            case .pickup: return "v1/driver-pickup-requests/\(self.id)"
        }
    }
}

// MARK:- Decoding extensions

fileprivate extension RestAPIResponse {

    private struct RequestResponse: Codable {
        let data: Request
    }

    func asRequest() -> Request? {
        let response: RequestResponse? = self.decode()
        return response?.data
    }

    private struct RequestsResponse: Codable {
        let data: [Request]
    }

    func asRequests() -> [Request] {
        let response: RequestsResponse? = self.decode()
        return response?.data ?? []
    }

    private struct TextMessages: Codable {
        let phone_number: String?
    }

    private struct VoiceCalls: Codable {
        let phone_number: String?
    }

    private struct TextMessagesAndVoiceCalls: Codable {
        let text_messages: TextMessages
        let voice_calls: VoiceCalls
    }

    private struct ContactCustomerResponse: Codable {
        let data: TextMessagesAndVoiceCalls
    }

    func asPhoneNumbers() -> (textNumber: String?, voiceNumber: String?) {
        let response: ContactCustomerResponse? = self.decode()
        return (response?.data.text_messages.phone_number,
                response?.data.voice_calls.phone_number)
    }
}
