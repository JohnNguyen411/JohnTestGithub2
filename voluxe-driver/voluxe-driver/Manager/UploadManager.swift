//
//  UploadManager.swift
//  voluxe-driver
//
//  Created by Christoph on 11/15/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class UploadManager {

    // MARK:- Upload context

    private let realm: Realm?
    private var currentUpload: Upload?
    var startOnUpload = true {
        didSet {
            if startOnUpload { self.start() }
        }
    }

    // MARK:- Singleton service support

    static let shared = UploadManager()
    private init() {
        self.realm = try? Realm()
    }

    // MARK:- Status

    enum Status: String {
        case idle
        case waiting
        case uploading
        case newUpload
    }

    private var status: Status = .idle {
        didSet {
            self.notifyStatusChanged()
        }
    }

    var statusChangeClosure: ((Status, String) -> ())?

    private func notifyStatusChanged() {
        self.statusChangeClosure?(self.status, "")
    }

    // MARK:- Upload interface

    var uploadsDidChangeClosure: (([Upload]) -> ())?

    private func notifyUploadsDidChange() {
        self.uploadsDidChangeClosure?(self.currentUploads())
    }

    func upload(_ upload: Upload) {
        guard let realm = self.realm else { return }
        try? realm.write { realm.add(upload) }
        if self.startOnUpload { self.start() }
        self.notifyUploadsDidChange()
    }

    func start() {

        guard self.status != .waiting else { return }

        guard self.currentUpload == nil else { return }

        guard let upload = self.nextUpload() else {
            self.status = .idle
            return
        }

        self.status = .uploading
        self.currentUpload = upload
        self._upload(upload)
    }

    func stop() {
        self.status = .idle
        self.currentUpload = nil
    }

    func clear() {
        self.stop()
        guard let realm = self.realm else { return }
        let objects = realm.objects(Upload.self)
        try? realm.write { realm.delete(objects) }
        self.notifyUploadsDidChange()
    }

    func count() -> Int {
        return self.uploads()?.count ?? 0
    }

    // MARK:- Private helpers

    private func restart() {
        guard let upload = self.currentUpload else { return }
        self.status = .uploading
        self._upload(upload)
    }

    // Note that any error response will pause() and then retry
    // the upload later.  This could cause the queue to stall
    // completely if an API logic change would reject an upload.
    private func _upload(_ upload: Upload) {
        DriverAPI.api.upload(route: upload.route,
                             datasAndMimeTypes: upload.datasAndMimeTypes())
        {
            // TODO https://app.asana.com/0/858610969087925/935159618076285/f
            // TODO consider mechanism to discard repeatedly failing uploads
            [weak self] response in
            if response?.error == nil && response?.asError() == nil {
                self?.complete(upload)
                self?.start()
            } else {
                self?.pause()
            }
        }
    }

    // TODO https://app.asana.com/0/0/923498218319323/f
    // TODO this could be part of a polling mechanism for managers
    private func pause(for seconds: TimeInterval = 5) {
        guard self.status != .waiting else { return }
        self.status = .waiting
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) {
            [weak self] timer in
            guard self?.status == .waiting else { return }
            self?.restart()
        }
    }

    private func complete(_ upload: Upload) {
        guard let realm = self.realm else { return }
        try? realm.write { realm.delete(upload) }
        self.currentUpload = nil
        self.notifyUploadsDidChange()
    }

    private func uploads() -> Results<Upload>? {
        guard let realm = self.realm else { return nil }
        let uploads = realm.objects(Upload.self).sorted(byKeyPath: "date")
        return uploads
    }

    func currentUploads() -> [Upload] {
        guard let uploads = self.uploads() else { return [] }
        return Array(uploads)
    }

    private func nextUpload() -> Upload? {
        let uploads = self.uploads()
        return uploads?.first
    }
}

// MARK:- Upload class (realm compatible)

// IMPORTANT do not use this class directly
class Upload: Object {

    @objc dynamic var date = Date()
    @objc dynamic var route = ""
    let datas = List<Data>()
    let mimeTypeStrings = List<String>()

    convenience init?(route: String, parameters: RestAPIParameters? = nil, image: UIImage) {
        guard let data = image.jpegDataForPhotoUpload() else { return nil }
        self.init(route: route, parameters: parameters, data: data, mimeType: RestAPIMimeType.jpeg)
    }

    convenience init(route: String, data: Data, mimeType: RestAPIMimeType) {
        self.init()
        self.route = route
        self.datas.append(data)
        self.mimeTypeStrings.append(mimeType.rawValue)
    }

    convenience init(route: String, parameters: RestAPIParameters? = nil, data: Data, mimeType: RestAPIMimeType) {
        self.init(route: route, data: data, mimeType: mimeType)
        guard let parameters = parameters else { return }
        guard let pdata = try? JSONSerialization.data(withJSONObject: parameters, options:[]) else { return }
        self.datas.append(pdata)
        self.mimeTypeStrings.append(RestAPIMimeType.json.rawValue)
    }

    func datasAndMimeTypes() -> [(Data, RestAPIMimeType)] {
        assert(self.datas.count == self.mimeTypeStrings.count, "Data and mime type arrays must be equal count")
        var tuples: [(Data, RestAPIMimeType)] = []
        for i in 0..<self.datas.count {
            let type = RestAPIMimeType(rawValue: self.mimeTypeStrings[i]) ?? RestAPIMimeType.invalid
            tuples += [(self.datas[i], type)]
        }
        return tuples
    }
}
