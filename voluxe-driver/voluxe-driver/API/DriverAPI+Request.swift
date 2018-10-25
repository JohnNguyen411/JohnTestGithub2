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

    // TODO throw error if no path?
    static func update(_ request: Request,
                       task: Task,
                       completion: @escaping ((LuxeAPIError.Code?) -> Void))
    {
        guard let path = self.api.path(for: request) else { return }
        let route = "v1/\(path)/\(request.id)/task"
        let parameters: RestAPIParameters = ["task": task.rawValue]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            completion(response?.asErrorCode())
        }
    }

    // TODO should this only update the pickup notes?
    // TODO are dropoff notes not applicable?
    static func update(_ request: Request,
                       notes: String,
                       completion: @escaping ((LuxeAPIError.Code?) -> Void))
    {
        let route = "v1/driver-pickup-requests/\(request.id)/notes"
        let parameters: RestAPIParameters = ["notes": notes]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            completion(response?.asErrorCode())
        }
    }

    // TODO return the numbers separately or in a struct?
    static func contactCustomer(_ request: Request,
                                completion: @escaping ((String?, String?, LuxeAPIError.Code?) -> Void))
    {
        guard let path = self.api.path(for: request) else { return }
        let route = "v1/\(path)/\(request.id)/contact-customer"
        let parameters: RestAPIParameters = ["mode": "text_only"]
        self.api.put(route: route, bodyParameters: parameters) {
            response in
            let (textNumber, phoneNumber) = response?.asPhoneNumbers() ?? (nil, nil)
            completion(textNumber, phoneNumber, response?.asErrorCode())
        }
    }

    private func path(for request: Request) -> String? {
        switch request.type {
            case .dropoff: return "driver-dropoff-requests"
            case .pickup: return "driver-pickup-requests"
            default: return nil
        }
    }
}

fileprivate extension RestAPIResponse {

    private struct TodayResponse: Codable {
        let data: [Request]
    }

    func asRequests() -> [Request] {
        let response: TodayResponse? = self.decode()
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
