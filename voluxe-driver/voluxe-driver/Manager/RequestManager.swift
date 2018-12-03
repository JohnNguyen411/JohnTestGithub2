//
//  RequestManager.swift
//  voluxe-driver
//
//  Created by Christoph on 11/27/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import UIKit

class RequestManager {

    // MARK:- Singleton support

    static let shared = RequestManager()
    private init() {}

    // MARK:- Driver context

    private var driver: Driver?

    // TODO guard different driver
    // TODO clear realm but what happens to pending inspections?
    // TODO get today
    // TODO get upcoming
    // TODO start polling for requests
    // TODO what else needs to happen if driver == nil?
    func set(driver: Driver) {
        self.driver = driver
        self.refreshRequests()
    }

    // MARK:- Request context

    // TODO needs to be let and private
    var request: Request? {
        didSet {
            self.notifyRequestDidChange()
        }
    }

    private func notifyRequestDidChange() {
        self.requestDidChangeClosure?(self.request)
    }

    var requestDidChangeClosure: ((Request?) -> ())?

    // TODO start polling for request object
    func select(request: Request) {
        self.request = request
        self.notifyRequestDidChange()
    }

    // TODO is this needed?
    func isSelected(request: Request) -> Bool {
        return self.request?.id == request.id
    }

    // TODO rename
    // TODO polling
    var requests: [Request] = [] {
        didSet {
            self.requestsDidChangeClosure?(requests)
        }
    }

    var requestsDidChangeClosure: (([Request]) -> ())?

    // MARK:- Inspections

    func addDocumentInspection(photo: UIImage) {
        self.addInspection(photo: photo, type: .document)
    }

    func addLoanerInspection(photo: UIImage) {
        self.addInspection(photo: photo, type: .loaner)
    }

    func addVehicleInspection(photo: UIImage) {
        self.addInspection(photo: photo, type: .vehicle)
    }

    // TODO assert if no request
    func addInspection(photo: UIImage,
                       type: OfflineInspection.InspectionType)
    {
        guard let request = self.request else { return }
        request.inspection(for: type) {
            [weak self] inspection in
            self?.upload(request: request,
                         inspection: inspection,
                         type: type,
                         photo: photo)
        }
    }

    // TODO assert on fails?
    private func upload(request: Request,
                        inspection: Inspection?,
                        type: OfflineInspection.InspectionType,
                        photo: UIImage)
    {
        guard let realm = try? Realm() else { return }
        let offlineInspection = OfflineInspection(request: request,
                                                  inspection: inspection,
                                                  type: type,
                                                  photo: photo)
        try? realm.write { realm.add(offlineInspection) }
        self.startUploading()
        self.notifyOfflineInspectionsDidChange()
    }

    // TODO assert on fails?
    // TODO what happens if a route is bad?
    // TODO what happens if nothing to upload?
    private func startUploading() {
        guard let realm = try? Realm() else { return }
        let inspections = realm.objects(OfflineInspection.self).filter { $0.isUploaded == false }
        guard let inspection = inspections.first else { return }
        self.route(for: inspection) {
            route in
            guard let route = route else { return }
            guard inspection.data.isEmpty == false else { return }
            UploadManager.shared.upload(inspection.data, to: route)
            inspection.markAsUploaded()
        }
    }

    // Offline inspections may not have a route because the
    // inspection ID is missing, so ask the API to create an
    // inspection, then generate the route.  Note that this
    // will update the backing store for the offline inspection.
    private func route(for OfflineInspection: OfflineInspection,
                       completion: @escaping ((String?) -> ()))
    {
        guard let request = OfflineInspection.request else {
            completion(nil)
            return
        }

        // TODO need to create different inspections based on type
        guard let inspection = OfflineInspection.inspection else {
            DriverAPI.createVehicleInspection(for: request) {
                inspection, error in
                guard let inspection = inspection else { completion(nil); return }
                let route = DriverAPI.routeToUploadPhoto(inspection: inspection, request: request)
                completion(route)
            }
            return
        }

        let route = DriverAPI.routeToUploadPhoto(inspection: inspection, request: request)
        completion(route)
    }

    func clear() {
        guard let realm = try? Realm() else { return }
        let objects = realm.objects(OfflineInspection.self)
        try? realm.write { realm.delete(objects) }
        self.notifyOfflineInspectionsDidChange()
    }

    private func cleanup() {
        guard let realm = try? Realm() else { return }
        let objects = realm.objects(OfflineInspection.self).filter { $0.canBeRemoved }
        try? realm.write { realm.delete(objects) }
        self.notifyOfflineInspectionsDidChange()
    }

    func offlineInspections() -> [OfflineInspection] {
        guard let realm = try? Realm() else { return [] }
        let objects = realm.objects(OfflineInspection.self)
        return Array(objects)
    }

    private func notifyOfflineInspectionsDidChange() {
        let inspections = self.offlineInspections()
        self.offlineInspectionsDidChangeClosure?(inspections)
    }

    var offlineInspectionsDidChangeClosure: (([OfflineInspection]) -> ())?

    // MARK:- Timers and polling

    // TODO https://app.asana.com/0/858610969087925/931551431894069/f
    // TODO create a refresh timer protocol and implementation
    private var refreshTimer: Timer?
    private var refreshing = false
    var isStarted: Bool {
        guard let timer = self.refreshTimer else { return false }
        return timer.isValid
    }

    func start() {
        guard self.refreshTimer == nil else { return }
        self.refreshTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) {
            [weak self] timer in
            self?.refresh()
        }
    }

    func stop() {
        self.refreshTimer?.invalidate()
        self.refreshTimer = nil
    }

    private func refresh() {
        guard self.refreshing == false else { return }
        self.refreshing = true
        self.refreshRequests {
            [weak self] in
            self?.refreshing = false
        }
    }

    // TODO this may not be needed
    private func refreshRequest(completion: (() -> ())) {
        guard let request = self.request else { return }
        DriverAPI.refresh(request) {
            [weak self] request, error in
            guard error == nil else { return }
            self?.request = request
        }
    }

    // TODO use the correct endpoint to get driver requests
    private func refreshRequests(completion: (() -> ())? = nil) {
        guard let driver = self.driver else { return }
        DriverAPI.today(for: driver) {
            [weak self] requests, error in
            if error == nil {
                self?.requests = requests
                self?.updateRequest(from: requests)
            }
            completion?()
        }
    }

    private func updateRequest(from requests: [Request]) {
        guard let request = self.request else { return }
        let filteredRequests = requests.filter { $0.id == request.id }
        guard filteredRequests.count == 1 else { return }
        self.request = filteredRequests.first
    }
}

// MARK:- Request extension to get/create inspection by type

fileprivate extension Request {

    func inspection(for type: OfflineInspection.InspectionType,
                    completion: @escaping ((Inspection?) -> ()))
    {
        if type == .document {
            DriverAPI.createDocumentInspection(for: self) {
                inspection, error in
                completion(inspection)
            }
        }

        else if type == .loaner {
            if let inspection = self.loanerInspection {
                DispatchQueue.main.async { completion(inspection) }
            } else {
                DriverAPI.createLoanerInspection(for: self) {
                    inspection, error in
                    completion(inspection)
                }
            }
        }

        else if type == .vehicle {
            if let inspection = self.vehicleInspection {
                DispatchQueue.main.async { completion(inspection) }
            } else {
                DriverAPI.createVehicleInspection(for: self) {
                    inspection, error in
                    completion(inspection)
                }
            }
        }

        else {
            completion(nil)
        }
    }
}

// MARK:- OfflineInspection serialized to Realm

// IMPORTANT do not use this class directly
class OfflineInspection: Object {

    // TODO does this belong with inspection?
    // TODO too bad this can't be Type
    enum InspectionType: String {
        case document
        case loaner
        case vehicle
        case unknown
    }

    @objc dynamic var typeString = InspectionType.unknown.rawValue
    var type: InspectionType {
        return InspectionType(rawValue: self.typeString) ?? InspectionType.unknown
    }

    // MARK:- Request

    @objc dynamic var requestData: Data?
    private var _request: Request?
    var request: Request? {
        if let request = self._request { return request }
        guard let data = self.requestData else { return nil }
        self._request = try? JSONDecoder().decode(Request.self, from: data)
        return self._request
    }

    // MARK:- Inspection

    @objc dynamic var inspectionData: Data?
    private var _inspection: Inspection?
    var inspection: Inspection? {
        if let inspection = self._inspection { return inspection }
        guard let data = self.inspectionData else { return nil }
        self._inspection = try? JSONDecoder().decode(Inspection.self, from: data)
        return self._inspection
    }

    // MARK:- Data and state

    @objc dynamic var data = Data()
    @objc dynamic var isUploaded: Bool = false

    var needsToBeUploaded: Bool {
        return self.isUploaded == false && self.data.isEmpty == false
    }

    var canBeRemoved: Bool {
        return self.isUploaded || self.data.isEmpty
    }

    // MARK:- Lifecycle

    convenience init(request: Request,
                     inspection: Inspection? = nil,
                     type: InspectionType,
                     photo: UIImage)
    {
        self.init()
        self.typeString = type.rawValue
        self._request = request
        self.requestData = try? JSONEncoder().encode(request)
        self._inspection = inspection
        self.inspectionData = try? JSONEncoder().encode(inspection)
        if let data = photo.jpegDataForPhotoUpload() { self.data = data }
    }

    func markAsUploaded() {
        guard let realm = try? Realm() else { return }
        try? realm.write { self.isUploaded = true }
    }
}
