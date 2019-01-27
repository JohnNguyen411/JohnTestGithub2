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

    func initRealm() {

        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1,
                                                                       migrationBlock:
        {
            migration, oldSchemaVersion in
            // nothing to do yet!
        })

        do {
            let _ = try Realm()
        } catch {
            Log.fatal(.missingValue, "realm could not be initialized, likely due to schema change")
        }
    }
}
