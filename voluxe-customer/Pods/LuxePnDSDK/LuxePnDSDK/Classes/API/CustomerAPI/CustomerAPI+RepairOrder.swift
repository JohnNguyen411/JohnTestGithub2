//
//  CustomerAPI+RepairOrder.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 11/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension CustomerAPI {

    /**
     Get all the available Repair Order Types
     - parameter completion: A closure which is called with an array of RepairOrderType Object or LuxeAPIError if an error occured
     */
    public static func repairOrderTypes(completion: @escaping (([RepairOrderType], LuxeAPIError?) -> Void)) {
        
        self.api.get(route: "v1/repair-order-types") {
            response in
            let repairOrderTypes = response?.decodeRepairOrderTypes() ?? []
            completion(repairOrderTypes, response?.asError())
        }
    }
    
    /**
     Get all dealership repair orders
     - parameter completion: A closure which is called with an array of DealershipRepairOrder Object or LuxeAPIError if an error occured
     */
    public static func dealershipRepairOrder(dealerships: [Dealership], repairOrderTypeId: Int?,
                                      completion: @escaping (([DealershipRepairOrder], LuxeAPIError?) -> Void)) {
        
        var ids: [Int] = []
        for dealership in dealerships {
            ids.append(dealership.id)
        }
        return dealershipRepairOrder(dealershipIds: ids, repairOrderTypeId: repairOrderTypeId, completion: completion)
    }
    
    /**
     Get all dealership repair orders
     - parameter completion: A closure which is called with an array of DealershipRepairOrder Object or LuxeAPIError if an error occured
     */
    public static func dealershipRepairOrder(dealershipIds: [Int], repairOrderTypeId: Int?,
                                      completion: @escaping (([DealershipRepairOrder], LuxeAPIError?) -> Void)) {
        
        var params = LuxeAPI.encodeParamsArray(array: dealershipIds, key: "dealership_id__in")
        
        if let repairOrderTypeId = repairOrderTypeId {
            params += "&repair_order_type_id=\(repairOrderTypeId)"
        }
        
        self.api.get(route: "v1/dealership-repair-orders?\(params)") {
            response in
            let dealershipRepairOrders = response?.decodeDealershipRepairOrders() ?? []
            completion(dealershipRepairOrders, response?.asError())
        }
    }
    
    /**
     Create RepairOrder for Customer
     - parameter customerId: Customer's Id
     - parameter bookingId: The booking Id associated with the Repair Order
     - parameter dealershipRepairOrderId: The dealershipRepairOrderId selected by the customer
     - parameter notes: The notes added by the customer for the repair
     - parameter completion: A closure which is called with the created RepairOrder Object or LuxeAPIError if an error occured
     */
    public static func createRepairOrder(customerId: Int, bookingId: Int, dealershipRepairOrderId: Int, title: String, notes: String, vehicleDrivable: Bool?,
                                    completion: @escaping ((RepairOrder?, LuxeAPIError?) -> Void)) {
        
        var params: [String : Any] = [
            "notes": notes,
            "title": title,
            "dealership_repair_order_id": dealershipRepairOrderId
            ]
        
        if let vehicleDrivable = vehicleDrivable {
            params["vehicle_drivable"] = vehicleDrivable
        }
        
        self.api.post(route: "v1/customers/\(customerId)/bookings/\(bookingId)/repair-order-requests", bodyParameters: params) {
            response in
            let repairOrder = response?.decodeRepairOrder()
            completion(repairOrder, response?.asError())
        }
    }
    
}


fileprivate extension RestAPIResponse {
    
    private struct RepairOrderResponse: Codable {
        let data: RepairOrder
    }
    
    func decodeRepairOrder() -> RepairOrder? {
        let repairOrderResponse: RepairOrderResponse? = self.decode()
        return repairOrderResponse?.data
    }
    
    private struct RepairOrderTypesResponse: Codable {
        let data: [RepairOrderType]
    }
    
    func decodeRepairOrderTypes() -> [RepairOrderType]? {
        let repairOrderTypesResponse: RepairOrderTypesResponse? = self.decode()
        return repairOrderTypesResponse?.data
    }
    
    private struct DealershipRepairOrdersResponse: Codable {
        let data: [DealershipRepairOrder]
    }
    
    func decodeDealershipRepairOrders() -> [DealershipRepairOrder]? {
        let dealershipRepairOrdersResponse: DealershipRepairOrdersResponse? = self.decode()
        return dealershipRepairOrdersResponse?.data
    }
    
}
