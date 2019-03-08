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
    @objc dynamic var mileage: Int = -1
    @objc dynamic var mileageUnit: String? = nil

    
    convenience init(requestId: Int, requestRoute: String, task: Task, mileage: Int? = nil, mileageUnit: String? = nil) {
        self.init()
        self.requestId = requestId
        self.requestRoute = requestRoute
        self.taskString = task.rawValue
        self.createdAt = Date()
        self.failedCount = 1 //if it's here, it failed already
        self.mileage = mileage ?? -1
        self.mileageUnit = mileageUnit
    }
    
}
