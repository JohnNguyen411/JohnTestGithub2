//
//  OfflineInspection.swift
//  voluxe-driver
//
//  Created by Christoph on 1/30/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

/// This class represents the intent to add an inspection
/// of a specific type to a request.  Since the intent can
/// occur when the app is offline, this allows the intent
/// to be serialized, then handled when connectivity returns.
/// `RequestManager` uses this when the UI makes the intent
/// know, and uses it's `refresh` cycle to check for any
/// offline inspections to handle.
///
/// This class is effectively managing the state of an offline
/// inspection, and the pending Inspection request.  Because it
/// is serialized to realm, the RequestManager needs the queue
/// never gets stalled with invalid or failed offline inspections,
/// hence the markAsExpired() and markAsFailed() functions.
class OfflineInspection: Object {

    @objc dynamic var typeString = InspectionType.unknown.rawValue
    var type: InspectionType {
        return InspectionType(rawValue: self.typeString) ?? InspectionType.unknown
    }

    // MARK: Request

    @objc dynamic var requestData: Data?
    private var _request: Request?
    @objc dynamic var requestId: Int = -1 // -1 if not init yet

    var request: Request? {
        if let request = self._request { return request }
        guard let data = self.requestData else { return nil }
        self._request = try? JSONDecoder().decode(Request.self, from: data)
        return self._request
    }

    // MARK: Inspection

    @objc dynamic var inspectionData: Data?
    @objc dynamic var inspectionId: Int = -1 // -1 if not init yet

    private var _inspection: Inspection? {
        didSet {
            guard let realm = try? Realm() else { return }
            try? realm.write {
                self.inspectionId = _inspection?.id ?? -1
                self.inspectionData = try? JSONEncoder().encode(_inspection)
            }
        }
    }

    var inspection: Inspection? {
        if let inspection = self._inspection { return inspection }
        guard let data = self.inspectionData else { return nil }
        self._inspection = try? JSONDecoder().decode(Inspection.self, from: data)
        return self._inspection
    }

    // MARK: Data and state

    @objc dynamic var data = Data()
    @objc dynamic var isUploaded: Bool = false
    @objc dynamic var failedCount: Int = 0
    @objc dynamic var isRequestingInspection: Bool = false

    var isPreparing: Bool {
        return self.isRequestingInspection
    }

    var needsToBeUploaded: Bool {
        return self.isUploaded == false && self.data.isEmpty == false
    }

    var canBeRemoved: Bool {
        guard let realm = try? Realm() else { return true }
        if let requestState = realm.objects(RequestState.self).filter("id = %@", self.requestId).first {
            if let state = Request.State(rawValue: requestState.state),
                state == .completed || state == .canceled {
            
                return self.isUploaded || self.data.isEmpty || self.failedCount > 5
            } else {
                return false
            }
        }
        
        return self.isUploaded || self.data.isEmpty || self.failedCount > 5
    }

    // MARK: Lifecycle

    convenience init(request: Request,
                     type: InspectionType,
                     photo: UIImage)
    {
        self.init()
        self.typeString = type.rawValue
        self._request = request
        self.requestId = request.id
        self.requestData = try? JSONEncoder().encode(request)
        if let data = photo.jpegDataForPhotoUpload() {
            self.data = data
        }
    }

    func markAsPreparing() {
        guard let realm = try? Realm() else { return }
        try? realm.write { self.isRequestingInspection = true }
    }

    func markAsWaiting() {
        guard let realm = try? Realm() else { return }
        try? realm.write { self.isRequestingInspection = false }
    }

    func markAsFailed(_ error: LuxeAPIError? = nil) {
        if let error = error, error.code != nil {
            OSLog.info("marking offline inspection as failed")
            return
        }
        guard let realm = try? Realm() else { return }
        try? realm.write { self.failedCount += 1 }
    }

    func markAsExpired() {
        guard let realm = try? Realm() else { return }
        try? realm.write { self.failedCount = 100 }
    }

    func markAsUploaded() {
        guard let realm = try? Realm() else { return }
        try? realm.write { self.isUploaded = true }
    }
}

extension OfflineInspection {

    /// This MUST be called before upload() to ensure
    /// that there is a real Inspection associated to
    /// Request for the upload to succeed.
    func prepareForUpload() -> Bool {

        // nothing to do if there is already an inspection
        if self.inspection != nil { return true }

        // prevent over calling if already pending
        // this will need to be UNSET on the next manager
        // launch otherwise this will never complete
        if self.isPreparing { return false }
        self.markAsPreparing()

        // this should never happen as the class requires
        // a non-optional Request to be serialized, however
        // if the Request model changes and no longer can be
        // deserialized, then this needs to be marked so that
        // it can be removed and not stall the queue
        guard let request = self.request else {
            self.markAsExpired()
            return false
        }

        // Note that self, not weak self, is used because
        // self will fall out of scope while the closure is
        // executing, so the closure needs to capture self.
        // This does mean that the object could be removed
        // before the closure is called, so self.invalidated
        // is used to prevent editing the object when deleted
        request.inspection(for: self.type) {
            inspection, error in
            if self.isInvalidated { return }
            self._inspection = inspection
            self.markAsWaiting()
            self.markAsFailed(error)
        }

        return false
    }

    func upload() -> Upload? {
        guard let request = self.request else { return nil }
        guard let inspection = self.inspection else { return nil }
        let (route, parameters) = request.uploadRoute(for: inspection, of: self.type)
        let upload = Upload(route: route,
                            parameters: parameters,
                            data: self.data,
                            mimeType: RestAPIMimeType.jpeg)
        return upload
    }
}

// MARK:- Request extension to get/create inspection by type

fileprivate extension Request {

    /// It is important to note that there may not be a returned
    /// inspection.  If this is unexpectedly nil, check that the
    /// request supports the type of inspection.  For example,
    /// asking for a loaner inspection when the request does not
    /// have an attached loaner will return a nil inspection, the
    /// API will not allow it.
    ///
    /// Another important distinction is that for loaner and vehicle
    /// type, the existing Inspection will be used.  For documents,
    /// a new Inspection is created for each one.  This is most visible
    /// when viewing the Request model.
    func inspection(for type: InspectionType,
                    completion: @escaping ((Inspection?, LuxeAPIError?) -> ()))
    {
        // return any embedded inspections first
        if let inspection = self.inspection(for: type) {
            completion(inspection, nil)
            return
        }
        
        // return refreshed request inspections
        if let request = RequestManager.shared.request(for: self.id) {
            if let inspection = request.inspection(for: type) {
                completion(inspection, nil)
                return
            }
        }
        
        // check Realm now
        if let cachedInspection = RequestState.inspection(for: type, requestId: self.id) {
            completion(cachedInspection, nil)
            return
        }

        // document inspections are always created
        if type == .document {
            DriverAPI.createDocumentInspection(for: self) {
                inspection, error in
                completion(inspection, error)
            }
        }

        else if type == .loaner {
            DriverAPI.createLoanerInspection(for: self) {
                inspection, error in
                completion(inspection, error)
            }
        }

        else if type == .vehicle {
            DriverAPI.createVehicleInspection(for: self) {
                inspection, error in
                completion(inspection, error)
            }
        }

        else {
            Log.unexpected(.incorrectValue, "unknown inspection type '\(type)'")
            completion(nil, nil)
        }
    }

    /// Convenience func to get the embedded inspection of
    /// the specified type.  Note that document inspections
    /// are always created when needed, so there is no need
    /// to reuse one, unlike loaner and vehicle inspections.
    func inspection(for type: InspectionType) -> Inspection? {
        switch type {
            case .loaner: return self.loanerInspection
            case .vehicle: return self.vehicleInspection
            default: return nil
        }
    }
}
