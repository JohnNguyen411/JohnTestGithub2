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
    
    private static let dbVersion: UInt64 = 14
    
    public static func realmMigration(callback: @escaping (Realm?, Swift.Error?) -> Void) {
        
        let config = Realm.Configuration(schemaVersion: dbVersion, migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: DealershipTimeSlotRealm.className()) { oldObject, newObject in
                    newObject!["availableLoanerVehicleCount"] = 0
                }
            }
            
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: DealershipTimeSlotRealm.className()) { oldObject, newObject in
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
                    let bookingFeedback = BookingFeedback()
                    newObject!["bookingFeedback"] = bookingFeedback
                }
            }
            
            if oldSchemaVersion < 5 {
                var id = 1
                migration.enumerateObjects(ofType: BookingFeedback.className()) { oldObject, newObject in
                    if newObject!["id"] as! Int == -1 {
                        newObject!["id"] = id
                        id = id + 1
                    }
                }
            }
            
            if oldSchemaVersion < 6 {
                migration.enumerateObjects(ofType: DealershipRealm.className()) { oldObject, newObject in
                    newObject!["email"] = ""
                }
            }
            
            if oldSchemaVersion < 7 {
                migration.enumerateObjects(ofType: CustomerAddressRealm.className()) { oldObject, newObject in
                    newObject!["luxeCustomerId"] = UserManager.sharedInstance.customerId() ?? -1
                }
            }
            
            if oldSchemaVersion < 8 {
                migration.enumerateObjects(ofType: RepairOrder.className()) { oldObject, newObject in
                    if let oldObject = oldObject {
                        newObject!["title"] = oldObject["name"]
                        newObject!["vehicleDrivable"] = RealmOptional<Bool>()
                    }
                }
            }
            
            if oldSchemaVersion < 9 {
                migration.enumerateObjects(ofType: DealershipRealm.className()) { oldObject, newObject in
                    newObject!["hoursOfOperation"] = ""
                }
            }
            
            if oldSchemaVersion < 10 {
                migration.enumerateObjects(ofType: CustomerRealm.className()) { oldObject, newObject in
                    newObject!["credit"] = oldObject?["credit"] ?? 0
                    newObject!["currencyId"] = oldObject?["currencyId"] ?? 1
                }
            }
            
            if oldSchemaVersion < 11 {
                migration.enumerateObjects(ofType: LocationRealm.className()) { oldObject, newObject in
                    newObject!["accuracy"] = 0.0
                }
                migration.enumerateObjects(ofType: DealershipRealm.className()) { oldObject, newObject in
                    newObject!["currencyId"] = oldObject?["currencyId"] ?? 1
                }
            }
            
            if oldSchemaVersion < 12 {
                migration.enumerateObjects(ofType: Booking.className()) { oldObject, newObject in
                    newObject!["loanerVehicleId"] = oldObject?["loanerVehicleId"] ?? -1
                    newObject!["pickupRequestId"] = oldObject?["pickupRequestId"] ?? -1
                    newObject!["dropoffRequestId"] = oldObject?["dropoffRequestId"] ?? -1
                    newObject!["bookingFeedbackId"] = oldObject?["bookingFeedbackId"] ?? -1
                }
                
                migration.enumerateObjects(ofType: RequestRealm.className()) { oldObject, newObject in
                    newObject!["timeslotId"] = oldObject?["timeslotId"] ?? -1
                }
                
                migration.enumerateObjects(ofType: DealershipTimeSlotRealm.className()) { oldObject, newObject in
                    newObject!["availableLoanerVehicleCount"] = oldObject?["availableLoanerVehicleCount"] ?? 0
                    newObject!["availableAssignmentCount"] = oldObject?["availableAssignmentCount"] ?? 0
                }
            }
            
            if oldSchemaVersion < 13 {
                migration.enumerateObjects(ofType: BookingFeedback.className()) { oldObject, newObject in
                    newObject!["rating"] = oldObject?["rating"] ?? RealmOptional<Int>()
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
