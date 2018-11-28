//
//  Thread+Assert.swift
//  voluxe-driver
//
//  Created by Christoph on 10/31/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

extension Thread {
    
    static func assertIsMainThread() {
        assert(Thread.isMainThread, "This func must be called on the main thread")
    }
}
