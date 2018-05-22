//
//  Int+Test.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension Int {

    static func random(from min: Int32, to max: Int32) -> Int32 {
        guard min != max else { return min }
        assert(max > min)
        let length = UInt32(max - min)
        let random = Int32(arc4random() % (length + 1)) + min
        return random
    }
}
