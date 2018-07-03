//
//  DeeplinkManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SwiftEventBus

final class DeeplinkManager {
    
    private static let channelDealershipSignup = "DealershipSignup"
    
    static let sharedInstance = DeeplinkManager()
    
    private var deeplinkObject: BranchDeeplink?
    private var prefillSignup: Bool = false
    var prefillSignupContinue: Bool = false // automatically go to next if possible
    
    convenience init(deeplinkObject: BranchDeeplink) {
        self.init()
        handleDeeplink(deeplinkObject: deeplinkObject)
    }
    
    init() {
    }
    
    func handleDeeplink(deeplinkObject: BranchDeeplink?) {
        self.deeplinkObject = deeplinkObject
        // clicked
        if let deeplinkObject = self.deeplinkObject, let clickedBranchLink = deeplinkObject.clickedBranchLink, let channel = deeplinkObject.channel, clickedBranchLink {
            // If the channel is DealershipSignup and user not logged in, got to account creation and prefill fields
            if channel == DeeplinkManager.channelDealershipSignup, !UserManager.sharedInstance.isLoggedIn() {
                self.prefillSignup = true
                self.prefillSignupContinue = true
                SwiftEventBus.post("channelDealershipSignup")
                Analytics.trackView(app: .deeplinkSignup)
            }
        }
    }
    
    func getDeeplinkObject() -> BranchDeeplink? {
        return deeplinkObject
    }
    
    func isPrefillSignup() -> Bool {
        return prefillSignup
    }
    
    
}
