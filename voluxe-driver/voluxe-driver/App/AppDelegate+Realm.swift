//
//  AppDelegate+Realm.swift
//  voluxe-driver
//
//  Created by Christoph on 11/15/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import RealmSwift

extension AppDelegate {
    
    static let schemaVersion: UInt64 = 2

    func initRealm() {

        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: AppDelegate.schemaVersion,
                                                                       migrationBlock:
        {
            migration, oldSchemaVersion in
            // nothing to do yet!
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: OfflineTaskUpdate.className()) { oldObject, newObject in
                    newObject!["mileage"] = -1
                    newObject!["mileageUnit"] = nil

                }
            }
            
        })

        do {
            let _ = try Realm()
        } catch {
            Log.fatal(.missingValue, "realm could not be initialized, likely due to schema change")
        }
    }
}
