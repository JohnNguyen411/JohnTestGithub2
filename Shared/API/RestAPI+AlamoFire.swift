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

    /// The lowest level network call that connects directly with Alamofire.
    /// Note that both body parameters and data can be specified, but that
    /// body data will overwrite any body parameters that may have been encoded.
    private func send(method: Alamofire.HTTPMethod,
                      route: RestAPIRoute,
                      headers: RestAPIHeaders,
                      queryParameters: RestAPIParameters? = nil,
                      bodyParameters: RestAPIParameters? = nil,
                      bodyData: Data? = nil,
                      completion: RestAPICompletion? = nil)
    {
        Thread.assertIsMainThread()

        let url = self.urlFromHost(for: route)

        guard let request = try? URLRequest(url: url, method: method, headers: Self.convertToAlamoFireHeaders(headers: headers)) else {
            Log.fatal(.missingValue, "could not convert headers to Alamofire headers, dropping request")
            return
        }

        guard var encodedRequest = try? URLEncoding.default.encode(request, with: queryParameters) else {
            Log.fatal(.missingValue, "could not encode query parameters, dropping request")
            return
        }

        if let bodyParameters = bodyParameters {
            encodedRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options:[])
            encodedRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }

        if let bodyData = bodyData {
            encodedRequest.httpBody = bodyData
            encodedRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }

        // injected responses do not make an actual request
        if let injectedResponse = self.injectResponse() {
            self.inspect(urlResponse: nil, apiResponse: injectedResponse)
            DispatchQueue.main.async { completion?(injectedResponse) }
            return
        }

        let sentRequest = Alamofire.AF.request(encodedRequest)
        sentRequest.responseData {
            response in
            // TODO: for some reason, with empty body even with 204 or 205, it returns an error, which it should not.
            // So, manual workaround for now:
            var error = response.error
            let emptyResponseCodes = DataResponseSerializer.defaultEmptyResponseCodes
        
            if let statusCode = response.response?.statusCode, error != nil && emptyResponseCodes.contains(statusCode) {
                error = nil
            }
            let apiResponse = RestAPIResponse(data: response.result.value, error: error, statusCode: response.response?.statusCode)
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

    func upload(route: RestAPIRoute,
                image: UIImage,
                completion: @escaping RestAPICompletion)
    {
        guard let data = image.jpegDataForPhotoUpload() else {
            Log.fatal(.incorrectValue, "Image needs to be JPEG compatible")
            return
        }
        let tuple = [(data, RestAPIMimeType.jpeg)]
        self.upload(route: route, datasAndMimeTypes: tuple, completion: completion)
    }

    func upload(route: RestAPIRoute,
                datasAndMimeTypes: [(Data, RestAPIMimeType)],
                completion: @escaping RestAPICompletion)
    {
        let url = self.urlFromHost(for: route)
        let request = Alamofire.AF.upload(multipartFormData: {
            multiPartFormData in
            for (data, mimeType) in datasAndMimeTypes {
                multiPartFormData.append(data,
                                         withName: mimeType.name,
                                         fileName: mimeType.filename,
                                         mimeType: mimeType.rawValue)
            }
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
