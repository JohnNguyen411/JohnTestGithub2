//
//  XCTest+Voluxe.swift
//  voluxe-customerUITests
//
//  Created by Christoph on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {

    // Convenience function to pause a script for a bit of time.  This internally
    // uses the waitForExpectations() construct, but doesn't require littering
    // the script code with expectations.  If the expectation times out, the test
    // will fail.
    func wait(for duration: TimeInterval = 2, label description: String = "wait") {
        let expectation = self.expectation(description: description)
        let deadline = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: deadline) { expectation.fulfill() }
        self.waitForExpectations(timeout: duration + 0.1)
    }
}
