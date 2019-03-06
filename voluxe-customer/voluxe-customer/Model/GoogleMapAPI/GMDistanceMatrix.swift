//
//  GMDistanceMatrix.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class GMDistanceMatrix: Codable {
    
    let rows: [GMRows]?
    let status: String?

    private enum CodingKeys: String, CodingKey {
        case rows
        case status
    }
    
    func getEta() -> GMTextValueObject? {
        guard let rows = rows else { return nil}
        if rows.count == 0 { return nil }
        
        guard let elements = rows[0].elements else { return nil}
        if elements.count == 0 { return nil }
        
        guard let duration = elements[0].duration else { return nil}
        return duration
    }
    
    static func decode<T: Decodable>(data: Data?, reportErrors: Bool = true) -> T? {
        guard let data = data else { return nil }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.localISO8601)
            
            let jsonString = String(data: data, encoding: .utf8)
            print("data: \(jsonString ?? "")")
            
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            // TODO log to console?
            if reportErrors { NSLog("\n\nDECODE ERROR: \(error)\n\n") }
            return nil
        }
    }
}
