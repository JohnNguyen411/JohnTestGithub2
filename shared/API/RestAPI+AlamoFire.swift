//
//  RestAPI+AlamoFire.swift
//  voluxe-driver
//
//  Created by Christoph on 10/17/18.
//  Copyright © 2018 Volvo Valet. All rights reserved.
//

import Alamofire
import Foundation

extension RestAPI {

    func get(route: RestAPIRoute,
             queryParameters: RestAPIParameters? = nil,
             completion: RestAPICompletion? = nil)
    {
        self.send(method: .get,
                  route: route,
                  headers: self.headers,
                  queryParameters: queryParameters,
                  completion: completion)
    }

    func patch(route: RestAPIRoute,
               bodyParameters: RestAPIParameters?,
               completion: RestAPICompletion?)
    {
        self.send(method: .patch,
                  route: route,
                  headers: self.headers,
                  bodyParameters: bodyParameters,
                  completion: completion)
    }
    
    func delete(route: RestAPIRoute,
               bodyParameters: RestAPIParameters? = nil,
               completion: RestAPICompletion?)
    {
        self.send(method: .delete,
                  route: route,
                  headers: self.headers,
                  bodyParameters: bodyParameters,
                  completion: completion)
    }

    func put(route: RestAPIRoute,
             bodyParameters: RestAPIParameters? = nil,
             bodyJSON: Data? = nil,
             completion: RestAPICompletion? = nil)
    {
        self.send(method: .put,
                  route: route,
                  headers: self.headers,
                  queryParameters: nil,
                  bodyParameters: bodyParameters,
                  bodyData: bodyJSON,
                  completion: completion)
    }

    func post(route: RestAPIRoute,
              queryParameters: RestAPIParameters? = nil,
              bodyParameters: RestAPIParameters? = nil,
              completion: RestAPICompletion? = nil)
    {
        self.send(method: .post,
                  route: route,
                  headers: self.headers,
                  queryParameters: queryParameters,
                  bodyParameters: bodyParameters,
                  completion: completion)
    }

    private func send(method: Alamofire.HTTPMethod,
                      route: RestAPIRoute,
                      headers: RestAPIHeaders,
                      queryParameters: RestAPIParameters? = nil,
                      bodyParameters: RestAPIParameters? = nil,
                      bodyData: Data? = nil,
                      completion: RestAPICompletion? = nil)
    {
        let url = self.urlFromHost(for: route)

        // TODO guard should return RestAPIResponse.error()
        guard let request = try? URLRequest(url: url, method: method, headers: Self.convertToAlamoFireHeaders(headers: headers)) else { return }
        guard var encodedRequest = try? URLEncoding.default.encode(request, with: queryParameters) else { return }

        // TODO move to utility func?
        if let bodyParameters = bodyParameters {
            encodedRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options:[])
            encodedRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }

        // TODO move to utility func?
        // TODO what happens if both body params and data are supplied?
        if let bodyData = bodyData {
            encodedRequest.httpBody = bodyData
            encodedRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }

        // injected responses do not make an actual request
        if let injectedResponse = self.injectResponse() {
            DispatchQueue.main.async { completion?(injectedResponse) }
            return
        }

        // TODO need to tap into response.error for status codes?
        let sentRequest = Alamofire.AF.request(encodedRequest)
        sentRequest.responseData {
            response in
            let apiResponse = RestAPIResponse(data: response.result.value, error: response.error, statusCode: response.response?.statusCode)
            self.inspect(urlResponse: response.response, apiResponse: apiResponse)
            completion?(apiResponse)
        }
    }

    // This is wrapped in a DEBUG clause to reduce overhead in production builds.
    // Since no debug menu is available, there is no way to inject responses so
    // no need to continually check the UserDefaults (which is not performant).
    private func injectResponse() -> RestAPIResponse? {
        #if DEBUG
            let defaults = UserDefaults.standard
            if defaults.injectLoginRequired {
                let error = LuxeAPIError(code: .E2001, message: "injected", statusCode: 401)
                let data = try? JSONEncoder().encode(error)
                let response = RestAPIResponse(data: data, error: nil, statusCode: 401)
                return response
            }
            else if defaults.injectUpdateRequired {
                let error = LuxeAPIError(code: .E3006, message: "injected", statusCode: 426)
                let data = try? JSONEncoder().encode(error)
                let response = RestAPIResponse(data: data, error: nil, statusCode: 426)
                return response
            }
            else {
                return nil
            }
        #else
            return nil
        #endif
    }

    // TODO this might be too restrictive as an API
    @available(*, deprecated)
    func upload(route: RestAPIRoute,
                image: UIImage,
                completion: @escaping RestAPICompletion)
    {
        // TODO need to return error if failed data
        guard let data = image.jpegDataForPhotoUpload() else { return }
        self.upload(route: route,
                    data: data,
                    dataName: "photo",
                    fileName: "photo.jpg",
                    mimeType: "image/jpeg",
                    completion: completion)
    }

    // TODO is dataName and fileName appropriate?
    func upload(route: RestAPIRoute,
                data: Data,
                dataName: String,
                fileName: String,
                mimeType: String,
                completion: @escaping RestAPICompletion)
    {
        let url = self.urlFromHost(for: route)
        let request = Alamofire.AF.upload(multipartFormData: {
            multiPartFormData in
            multiPartFormData.append(data, withName: dataName, fileName: fileName, mimeType: mimeType)
        },
                                          to: url,
                                          method: .put,
                                          headers: Self.convertToAlamoFireHeaders(headers: self.headers))
        request.responseData {
            response in
            let apiResponse = RestAPIResponse(data: response.result.value, error: response.error, statusCode: response.response?.statusCode)
            self.inspect(urlResponse: response.response, apiResponse: apiResponse)
            completion(apiResponse)
        }
    }
    
    static func convertToAlamoFireHeaders(headers: RestAPIHeaders?) -> HTTPHeaders? {
        guard let apiHeaders = headers else {
            return nil
        }
        var alamoFireHeaders = HTTPHeaders()
        for header in apiHeaders {
            alamoFireHeaders.add(HTTPHeader(name: header.key, value: header.value))
        }
        return alamoFireHeaders
    }
}
