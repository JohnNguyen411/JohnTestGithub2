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
    
    // MARK: Analytics
    
    private var latestTask: Task?
    
    // MARK: Singleton support
    static let shared = RequestManager()
    
    // Any pending offline inspections need to be marked
    // such that the next refresh() cycle continues trying
    // to get the correct Inspection.  If this is not done,
    // then any offline inspection that `isPreparing` but
    // does not actually have an API inspection request in
    // progress will stall the queue.
    private init() {
        self.markOfflineInspectionsAsWaiting()
    }
    
    // MARK: Driver context
    private var driver: Driver?
    
    func set(driver: Driver?) {
        self.driver = driver
        self.refreshRequests()
    }
    
    // MARK: Request (active or selected)
    private var _request: Request? {
        didSet {
            self.notifyRequestDidChange()
        }
    }
    
    var request: Request? {
        return self._request
    }
    
    private func notifyRequestDidChange() {
        self.requestDidChangeClosure?(self.request)
    }
    
    var requestDidChangeClosure: ((Request?) -> ())?
    
    func select(request: Request) {
        self._request = request
    }
    
    func isSelected(request: Request) -> Bool {
        return self.request?.id == request.id
    }
    
    // MARK: Current requests
    var requests: [Request] = [] {
        didSet {
            self.requestsDidChangeClosure?(requests)
            let current = requests.filter { $0.state == .started && Calendar.current.isDateInToday($0.dealershipTimeSlot.from) }
            
            // Active requests, do start location updates
            if current.count > 0 {
                DriverManager.shared.startLocationUpdates()
            } else {
                // stop location updates
                DriverManager.shared.stopLocationUpdates()
            }
        }
    }
    
    var requestsDidChangeClosure: (([Request]) -> ())?
    
    // MARK: Mileage
    var recentMileage: [Int: UInt] = [:]
    
    // MARK: Inspections
    func addDocumentInspection(photo: UIImage) {
        self.addInspection(photo: photo, type: .document)
    }
    
    func addLoanerInspection(photo: UIImage) {
        self.addInspection(photo: photo, type: .loaner)
    }
    
    func addVehicleInspection(photo: UIImage) {
        self.addInspection(photo: photo, type: .vehicle)
    }
    
    func addInspection(photo: UIImage,
                       type: InspectionType)
    {
        guard let request = self.request else {
            Log.unexpected(.missingValue, "Cannot add inspection without active Request")
            return
        }
        
        self.upload(request: request,
                    type: type,
                    photo: photo)
    }
    
    private func upload(request: Request,
                        type: InspectionType,
                        photo: UIImage)
    {
        guard let realm = try? Realm() else {
            Log.fatal(.missingValue, "Realm not inited, cannot create offline inspection")
            return
        }
        
        let offlineInspection = OfflineInspection(request: request,
                                                  type: type,
                                                  photo: photo)
        try? realm.write { realm.add(offlineInspection) }
        self.startUploading()
        self.notifyOfflineInspectionsDidChange()
    }
    
    private func startUploading() {
        guard let realm = try? Realm() else { return }
        let inspections = realm.objects(OfflineInspection.self).filter { $0.isUploaded == false }
        guard let inspection = inspections.first else { return }
        guard inspection.prepareForUpload() else { return }
        guard let upload = inspection.upload() else { return }
        UploadManager.shared.upload(upload)
        inspection.markAsUploaded()
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
    
    /// For any serialized inspection, marks each as waiting
    /// so that it can be attempted to upload again.  This is
    /// necessary in case any offline inspection was waiting
    /// to get an inspection and the app restarted.  The state
    /// `isPreparing` would prevent any further attempts to get
    /// an inspection, and stall the queue.
    private func markOfflineInspectionsAsWaiting() {
        let inspections = self.offlineInspections()
        for inspection in inspections { inspection.markAsWaiting() }
    }
    
    func offlineInspections() -> [OfflineInspection] {
        guard let realm = try? Realm() else { return [] }
        let objects = realm.objects(OfflineInspection.self)
        return Array(objects)
    }
    
    func offlineInspections(for requestId: Int, type: InspectionType) -> [OfflineInspection] {
        guard let realm = try? Realm() else { return [] }
        let objects = realm.objects(OfflineInspection.self).filter("requestId = %@ AND typeString = %@", requestId, type.rawValue)
        return Array(objects)
    }
    
    private func notifyOfflineInspectionsDidChange() {
        let inspections = self.offlineInspections()
        self.offlineInspectionsDidChangeClosure?(inspections)
    }
    
    var offlineInspectionsDidChangeClosure: (([OfflineInspection]) -> ())?
    
    // MARK: Timers and polling
    // TODO https://app.asana.com/0/858610969087925/931551431894069/f
    // TODO create a refresh timer protocol and implementation
    private var refreshTimer: Timer?
    private var refreshing = false
    var isStarted: Bool {
        guard let timer = self.refreshTimer else { return false }
        return timer.isValid
    }
    
    func forceRefresh() {
        if refreshing { return }
        guard self.refreshTimer != nil else {
            self.start()
            return
        }
        self.refresh()
    }
    
    func start() {
        guard self.refreshTimer == nil else { return }
        self.refreshTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) {
            [weak self] timer in
            self?.refresh()
        }
        self.refresh()
        Log.info("RequestManager started")
    }
    
    func stop() {
        self.refreshTimer?.invalidate()
        self.refreshTimer = nil
        Log.info("RequestManager stopped")
    }
    
    func request(for requestId: Int) -> Request? {
        for request in requests {
            if request.id == requestId {
                return request
            }
        }
        return nil
    }
    
    private func refresh() {
        self.startUploading()
        self.cleanup()
        guard self.refreshing == false else { return }
        self.refreshing = true
        self.refreshRequests {
            [weak self] in
            self?.refreshing = false
        }
    }
    
    private func refreshRequest(completion: (() -> ())) {
        guard let request = self.request else { return }
        DriverAPI.refresh(request) {
            [weak self] request, error in
            guard error == nil else { return }
            self?._request = request
            if let request = request {
                self?.updateRequestsState(requests: [request])
            }
        }
    }
    
    private func refreshRequests(completion: (() -> ())? = nil) {
        guard let driver = self.driver else {
            completion?()
            return
        }
        if !DriverManager.shared.readyForUse {
            completion?()
            return
        }
        
        let today = Date.earliestToday()
        let weekFromToday = Date.oneWeekFromToday()
        DriverAPI.requests(for: driver, from: today, to: weekFromToday) {
            [weak self] requests, error in
            if error == nil {
                self?.requests = requests
                self?.updateRequest(from: requests)
            }
            completion?()
        }
    }
    
    private func updateRequest(from requests: [Request]) {
        // update all request state in DB
        self.updateRequestsState(requests: requests)
        guard let request = self.request else { return }
        if let task = request.task, task != self.latestTask {
            Analytics.trackChangeTask(task: task.rawValue, id: request.id)
        }
        let filteredRequests = requests.filter { $0.id == request.id }
        guard filteredRequests.count == 1 else { return }
        self._request = filteredRequests.first
    }
    
    private func updateRequestsState(requests: [Request]) {
        guard let realm = try? Realm() else { return }
        guard let driver = self.driver else { return }

        try? realm.write {
            realm.add(RequestState.requestToRequestState(requests: requests, driverId: driver.id), update: true)
        }
    }
}
