//
//  RepairOrderAPI.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import BrightFutures

/// Class regrouping all the methods related to Repair Orders
class RepairOrderAPI: NSObject {
    
    
    /**
     Get all the available Repair Order Types
     
     - Returns: A Future ResponseObject containing a RepairOrderType, or an AFError if an error occured
     */
    func getRepairOrderTypes() -> Future<ResponseObject<MappableDataArray<RepairOrderType>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<RepairOrderType>>?, AFError>()
        
        
        NetworkRequest.request(url: "/v1/repair-order-types", queryParameters: nil, withBearer: true).responseJSON { response in
            var responseObject: ResponseObject<MappableDataArray<RepairOrderType>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataArray<RepairOrderType>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors.safeAFError(error: response.error!))
            }
        }
        return promise.future
    }
    
    /**
     Get all dealership repair orders
     
     - Returns: A Future ResponseObject containing a RepairOrderType, or an AFError if an error occured
     */
    func getDealershipRepairOrder(dealerships: [Dealership], repairOrderTypeId: Int?) -> Future<ResponseObject<MappableDataArray<DealershipRepairOrder>>?, AFError> {
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
    func getDealershipRepairOrder(dealershipIds: [Int], repairOrderTypeId: Int?) -> Future<ResponseObject<MappableDataArray<DealershipRepairOrder>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataArray<DealershipRepairOrder>>?, AFError>()
        
        var params = NetworkRequest.encodeParamsArray(array: dealershipIds, key: "dealership_id__in")
        
        if let repairOrderTypeId = repairOrderTypeId {
            params += "&repair_order_type_id=\(repairOrderTypeId)"
        }
        
        NetworkRequest.request(url: "/v1/dealership-repair-orders?\(params)", queryParameters: nil, withBearer: true).responseJSON { response in
            var responseObject: ResponseObject<MappableDataArray<DealershipRepairOrder>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataArray<DealershipRepairOrder>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors.safeAFError(error: response.error!))
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
    func createRepairOrder(customerId: Int, bookingId: Int, dealershipRepairOrderId: Int, notes: String) -> Future<ResponseObject<MappableDataObject<RepairOrder>>?, AFError> {
        let promise = Promise<ResponseObject<MappableDataObject<RepairOrder>>?, AFError>()

        let params: Parameters = [
            "notes": notes,
            "dealership_repair_order_id": dealershipRepairOrderId
            ]
        
        NetworkRequest.request(url: "/v1/customers/\(customerId)/bookings/\(customerId)/repair-order-requests", queryParameters: nil, bodyParameters: params, withBearer: true).responseJSON { response in
            var responseObject: ResponseObject<MappableDataObject<RepairOrder>>?
            
            if let json = response.result.value as? [String: Any] {
                responseObject = ResponseObject<MappableDataObject<RepairOrder>>(json: json)
            }
            
            if response.error == nil {
                promise.success(responseObject)
            } else {
                promise.failure(Errors.safeAFError(error: response.error!))
            }
        }
        return promise.future
    }
    
    
}

