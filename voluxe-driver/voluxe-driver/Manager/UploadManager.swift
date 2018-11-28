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
    var startOnUpload = true

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
    }

    private var status: Status = .idle {
        didSet {
            self.statusChangeClosure?(status, "")
        }
    }

    private func set(status: Status, text: String) {
        self.status = status
        self.statusChangeClosure?(self.status, text)
    }

    var statusChangeClosure: ((Status, String) -> ())?

    // MARK:- Upload interface

    func upload(_ image: UIImage, to route: String) {
        guard let realm = self.realm else { return }
        let upload = Upload(route: route, image: image)
        try? realm.write { realm.add(upload) }
        if self.startOnUpload { self.start() }
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
        try? realm.write { realm.deleteAll() }
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
        guard let data = upload.data else { return }
        DriverAPI.api.upload(route: upload.route,
                             data: data,
                             dataName: "data",
                             fileName: "whatever",
                             mimeType: "image/jpeg")
        {
            [weak self] response in
            if response?.error == nil && response?.asError() == nil {
                self?.complete(upload)
                self?.start()
            } else {
                self?.pause()
            }
        }
    }

    private func pause(for seconds: TimeInterval = 5) {
        guard self.status != .waiting else { return }
        self.set(status: .waiting, text: "Upload failed, retry in \(seconds) seconds")
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
    }

    private func uploads() -> Results<Upload>? {
        guard let realm = self.realm else { return nil }
        let uploads = realm.objects(Upload.self).sorted(byKeyPath: "date")
        return uploads
    }

    // TODO queue or stack?
    private func nextUpload() -> Upload? {
        let uploads = self.uploads()
        return uploads?.first
    }
}

// MARK:- Upload class (realm compatible)

class Upload: Object {

    @objc dynamic var date = Date()
    @objc dynamic var route: String = ""
    @objc dynamic var data: Data?

    convenience init(route: String, image: UIImage) {
        self.init()
        self.route = route
        self.data = image.jpegData(compressionQuality: 0.5)
    }
}
