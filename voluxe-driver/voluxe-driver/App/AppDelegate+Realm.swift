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

        // TODO https://app.asana.com/0/858610969087925/892091539851886/f
        // TODO should a realm error be logged somewhere?
        do {
            let _ = try Realm()
        } catch {
            NSLog("REALM INIT ERROR: \(error)")
        }
    }
}
