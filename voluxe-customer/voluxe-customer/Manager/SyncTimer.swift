//
//  SyncTimer.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

class SyncTimer {
    
    public enum SyncTimerState {
        case suspended
        case resumed
    }
    
    var timer: DispatchSourceTimer?
    let queue = DispatchQueue.main
   
    public var state: SyncTimerState = .suspended
    
    init() {
    }
    
    private func resume() {
        guard let timer = self.timer else { return }
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        guard let timer = self.timer else { return }
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    
    deinit {
        guard let timer = self.timer else { return }
        
        timer.setEventHandler {}
        timer.cancel()
    }
    

}
