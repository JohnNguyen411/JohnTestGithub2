//
//  RepairOrderAPI.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures

/// Class regrouping all the methods related to Repair Orders
class RepairOrderAPI: NSObject {
    
    
    /**
     Get all the available Repair Order Types
     
     - Returns: A Future ResponseObject containing a RepairOrderType, or an AFError if an error occured
     */
    func getRepairOrderTypes() -> Future<ResponseObject<MappableDataArray<RepairOrderType>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataArray<RepairOrderType>>?, Errors>()
        
        
        NetworkRequest.request(url: "/v1/repair-order-types", queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataArray<RepairOrderType>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }
    
    /**
     Get all dealership repair orders
     
     - Returns: A Future ResponseObject containing a RepairOrderType, or an AFError if an error occured
     */
    func getDealershipRepairOrder(dealerships: [Dealership], repairOrderTypeId: Int?) -> Future<ResponseObject<MappableDataArray<DealershipRepairOrder>>?, Errors> {
        var ids: [Int] = []
        for dealership in dealerships {
            ids.append(dealership.id)
        }
        return getDealershipRepairOrder(dealershipIds: ids, repairOrderTypeId: repairOrderTypeId)
    }
    
    /**
     Get all dealership repair orders
     
     - Returns: A Future ResponseObject containing a RepairOrderType, or an AFError if an error occured
     */
    func getDealershipRepairOrder(dealershipIds: [Int], repairOrderTypeId: Int?) -> Future<ResponseObject<MappableDataArray<DealershipRepairOrder>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataArray<DealershipRepairOrder>>?, Errors>()
        
        var params = NetworkRequest.encodeParamsArray(array: dealershipIds, key: "dealership_id__in")
        
        if let repairOrderTypeId = repairOrderTypeId {
            params += "&repair_order_type_id=\(repairOrderTypeId)"
        }
        
        NetworkRequest.request(url: "/v1/dealership-repair-orders?\(params)", queryParameters: nil, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataArray<DealershipRepairOrder>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        
        }
        return promise.future
    }
    
    
    /**
     Create RepairOrderType for Customer
     - parameter customerId: Customer's Id
     - parameter bookingId: The booking Id associated with the Repair Order
     - parameter dealershipRepairOrderId: The dealershipRepairOrderId selected by the customer
     - parameter notes: The notes added by the customer for the repair
     
     - Returns: A Future ResponseObject containing a RepairOrder, or an AFError if an error occured
     */
    func createRepairOrder(customerId: Int, bookingId: Int, dealershipRepairOrderId: Int, title: String, notes: String, vehicleDrivable: Bool?) -> Future<ResponseObject<MappableDataObject<RepairOrder>>?, Errors> {
        let promise = Promise<ResponseObject<MappableDataObject<RepairOrder>>?, Errors>()

        var params: Parameters = [
            "notes": notes,
            "title": title,
            "dealership_repair_order_id": dealershipRepairOrderId
            ]
        
        if let vehicleDrivable = vehicleDrivable {
            params["vehicle_drivable"] = vehicleDrivable
        }
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings/\(bookingId)/repair-order-requests", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSONErrorCheck { response in
            
            let responseObject = ResponseObject<MappableDataObject<RepairOrder>>(json: response.result.value, allowEmptyData: false)
            
            if response.error == nil && responseObject.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors(dataResponse: response, apiError: responseObject.error))
            }
        }
        return promise.future
    }
    
    
}

