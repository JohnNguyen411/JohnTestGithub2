//
//  OdometerReading.swift
//  LuxePnDSDK
//
//  Created by Johan Giroux on 4/1/19.
//

import Foundation

@objcMembers public class OdometerReading: NSObject, Codable {

    public let id: Int
    public let value: Int
    public let unit: String
    let taken_by_id: Int
    let taken_by_type: String
    
}
