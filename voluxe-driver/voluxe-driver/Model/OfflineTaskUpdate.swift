//
//  OfflineTaskUpdate.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/6/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class OfflineTaskUpdate: Object {
    
    @objc dynamic var requestId: Int = -1
    @objc dynamic var taskString: String?
    @objc dynamic var requestRoute: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var failedCount: Int = 0

    
    convenience init(requestId: Int, requestRoute: String, task: Task) {
        self.init()
        self.requestId = requestId
        self.requestRoute = requestRoute
        self.taskString = task.rawValue
        self.createdAt = Date()
        self.failedCount = 1 //if it's here, it failed already
    }
}
