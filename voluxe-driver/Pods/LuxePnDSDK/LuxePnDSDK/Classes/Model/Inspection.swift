//
//  Inspection.swift
//  LuxePnDSDK
//
//  Created by Johan Giroux on 4/1/19.
//

import Foundation

@objcMembers public class Inspection: NSObject, Codable {
    
    public dynamic var id: Int
    public dynamic var requestId: Int?
    public dynamic var vehicleId: Int?
    public dynamic var notes: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case requestId = "request_id"
        case vehicleId = "vehicle_id"
        case notes
    }
    
    public init(id: Int, requestId: Int?, vehicleId: Int?, notes: String?) {
        self.id = id
        self.requestId = requestId
        self.vehicleId = vehicleId
        self.notes = notes
    }
}

public enum InspectionType: Int, CaseIterable, CustomStringConvertible {
    
    case document = 0
    case vehicle
    case loaner
    case unknown
    
    public var description: String {
        switch self {
        case .document: return "Document"
        case .loaner: return "Loaner"
        case .vehicle: return "Vehicle"
        case .unknown: return "Unspecified"
        }
    }
}
