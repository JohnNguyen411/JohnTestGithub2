//
//  RealmManager.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift

/// RealmManager is use to run Realm Migrations
class RealmManager {
    
    private static let dbVersion: UInt64 = 4
    
    public static func realmMigration(callback: @escaping (Realm?, Swift.Error?) -> Void) {
        
        let config = Realm.Configuration(schemaVersion: dbVersion, migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: DealershipTimeSlot.className()) { oldObject, newObject in
                    newObject!["availableLoanerVehicleCount"] = 0
                }
            }
            
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: DealershipTimeSlot.className()) { oldObject, newObject in
                    newObject!["availableAssignmentCount"] = 0
                }
            }
            
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: Booking.className()) { oldObject, newObject in
                    newObject!["bookingFeedbackId"] = -1
                }
            }
            
            if oldSchemaVersion < 4 {
                migration.enumerateObjects(ofType: Booking.className()) { oldObject, newObject in
                    newObject!["bookingFeedback"] = BookingFeedback()
                }
            }
            
            
        })
        
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen(configuration: config) { realm, error in
            if let _ = realm {
                Logger.print("Realm Migration Success")
            } else if let error = error {
                Logger.print("Realm Migration Error \(error)")
            }
            callback(realm, error)
        }
    }
    
}
