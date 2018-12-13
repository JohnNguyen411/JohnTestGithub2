//
//  GMSnappedPoints.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class GMSnappedPoints: Codable {
    
    let snappedPoints: [GMSnappedPoint]?
    
    private enum CodingKeys: String, CodingKey {
        case snappedPoints
    }
    
    static func decode<T: Decodable>(data: Data?, reportErrors: Bool = true) -> T? {
        guard let data = data else { return nil }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.localISO8601)
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            // TODO log to console?
            if reportErrors { NSLog("\n\nDECODE ERROR: \(error)\n\n") }
            return nil
        }
    }
    
}
