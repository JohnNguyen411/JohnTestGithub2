//
//  InitializationService.swift
//  hse
//
//  Created by Kimmo Lahdenkangas on 06/10/16.
//  Copyright © 2016 Volvo. All rights reserved.
//

import UIKit
import BrightFutures
import SwiftyJSON
import FirebaseRemoteConfig
import CocoaLumberjack
import SwiftEventBus
import Kingfisher

enum InitializationError: Error {
    case CouldNotLoadDefaults
    case CouldNotLoadCustomer
    case CouldNotLoadVehicle
    case CouldNotGetOptedInServices
    case CouldNotGetSchedule
    case CouldNotGetUnconfirmedServices
    case CouldNotGetLocation
    case CouldNotGetLockStatus
    case CouldNotGetFuelData
    case ReverseGeolocationFailed
    case CouldNotRenderMap
    case CouldNotGetQuotes
    case CouldNotLoadCredit
    case CouldNotGetVehicleImage
    case CouldNotGetPushNotificationSettings
    case CouldNotSavePushNotificationSettings
}

enum FutureType {
    case VoidType()
    case CustomerType(Customer)
    case VehicleType(Vehicle?)
}

enum VehicleFutureType {
    case Location(VehicleLocation)
    case LockStatus(VehicleLockStatus)
    case FuelStatus(FuelData)
    case Image(UIImage)
}

class InitializationService: NSObject {

    static let sharedInstance = InitializationService()
    //swiftlint:disable:next force_cast
    weak var appDelegate: AppDelegate! = UIApplication.shared.delegate as! AppDelegate
    let userDefaults = UserDefaults.standard

    //swiftlint:disable:next function_body_length
    func initializeData(vc: UIViewController) -> Future<FutureType, InitializationError> {
        let promise = Promise<FutureType, InitializationError>()
        initializeDefaultsFromJSON().onSuccess {_ in
            self.appDelegate.initialized = true
        }.onFailure {error in
            DDLogInfo("ERROR: initializeData - could not load defaults")
            self.appDelegate.initialized = false
            promise.failure(error)
        }
        return promise.future
    }

   
    func initializeDefaultsFromJSON() -> Future<FutureType, InitializationError> {
        let promise = Promise<FutureType, InitializationError>()

        let file = Bundle(for: self.classForCoder).path(forResource: AppDelegate.getRunConfig(), ofType: "json")
        var json: JSON?
        if let jsonStr = try? NSString(contentsOfFile: file!, encoding: String.Encoding.utf8.rawValue) as String {
            json = JSON(parseJSON: jsonStr)
        }
        if json != nil {
            self.setUserDefaultsFromJson(json: json!)
            DDLogInfo("PROMISE SUCCESS: initializeDefaultsFromJSON")
            userDefaults.setValue(true, forKey: Constants.BetaUserKey)
            promise.success(.VoidType())
        } else {
            DDLogInfo("ERROR: initializeDefaultsFromJSON")
            promise.failure(.CouldNotLoadDefaults)
        }
        return promise.future
    }

    func setUserDefaultsFromJson(json: JSON) {
        userDefaults.setValue(json[Constants.ServerUrlKey].string!, forKey: Constants.ServerUrlKey)
        userDefaults.setValue(json[Constants.AppDynamicsUUIDKey].string!, forKey: Constants.AppDynamicsUUIDKey)
        userDefaults.setValue(false, forKey: Constants.BetaUserKey)
        userDefaults.setValue(false, forKey: Constants.WashServicesKey)
        userDefaults.setValue(false, forKey: Constants.DebugUserKey)
        userDefaults.set(false, forKey: Constants.HasValidSessionKey)
        userDefaults.set(true, forKey: Constants.UserDefaultsInitializedKey)
        userDefaults.setValue(Constants.LoginUrl, forKey: Constants.LoginPathKey)
        userDefaults.setValue(Constants.ValidationUrl, forKey: Constants.ValidationUrlKey)
        userDefaults.synchronize()
    }


    func resetApplicationState() {
        userDefaults.set(false, forKey: Constants.UserRegisteredForPushNotificationsKey)
        userDefaults.set(false, forKey: Constants.NotFirstUseKey)
        userDefaults.set(false, forKey: Constants.AnsweredNotificationRequest)
        userDefaults.set(false, forKey: Constants.AnsweredLocationRequest)
        userDefaults.set(false, forKey: Constants.AnsweredPermissionRequests)
        userDefaults.set(false, forKey: Constants.NotFirstLogin)
        userDefaults.set(false, forKey: Constants.AcceptedTermsAndConditions)
        userDefaults.set(false, forKey: Constants.ShouldShowDemoQuotes)

        appDelegate.initialized = false
    }

}
