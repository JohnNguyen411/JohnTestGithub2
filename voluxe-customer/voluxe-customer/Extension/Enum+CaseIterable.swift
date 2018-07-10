//
//  Enum+CaseIterable.swift
//  voluxe-customer
//
//  Created by Christoph on 6/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/// Convenience protocol to allow iterating through an Enum.
/// Swift 4.2 defines CaseIterable so this extension is temporary.
/// https://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type
#if swift(>=4.2)
#else
public protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: AllCases { get }
}
extension CaseIterable where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}
#endif
