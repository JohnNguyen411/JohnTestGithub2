//
//  OfflineTaskManager.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 2/6/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import RealmSwift

class OfflineTaskManager {
    
    private let realm: Realm?
    
    static let shared = OfflineTaskManager()
    
    private init() {
        self.realm = try? Realm()
    }
    
    
    func queue(task: Task, request: Request) {
        guard let realm = self.realm else { return }
        let offline = OfflineTaskUpdate(requestId: request.id, requestRoute: request.route, task: task)
        Log.info("OfflineTaskManager queue task: \(task.rawValue)")

        try? realm.write {
            realm.add(offline)
        }
        
        if !self.isStarted {
            self.start()
        }
    }
    
    func updateNext() {
        guard self.refreshing == false else { return }
        guard let realm = self.realm else { return }
        if let offlineTask = realm.objects(OfflineTaskUpdate.self).sorted(byKeyPath: "createdAt", ascending: true).first {
            if let requestRoute = offlineTask.requestRoute, let taskString = offlineTask.taskString, let task = Task(rawValue: taskString) {
                
                // check cached request state
                if let requestState = realm.objects(RequestState.self).filter("id = %@", offlineTask.requestId).first,
                    let state = Request.State(rawValue: requestState.state), state == .completed || state == .canceled {
                    try? realm.write { realm.delete(offlineTask) }
                    // proceed to next
                    updateNext()
                    return
                }
                
                
                self.refreshing = true
                DriverAPI.update(requestRoute, task: task, completion: { [weak self] error in
                    self?.refreshing = false
                    if let error = error {
                        // wrong state
                        if error.code == .E4021{
                            try? realm.write { realm.delete(offlineTask) }
                            // proceed to next
                            self?.updateNext()
                            return
                        }
                        // re-queue
                        try? realm.write {
                            offlineTask.failedCount += 1
                        }
                    } else {
                        // uploaded
                        try? realm.write { realm.delete(offlineTask) }
                        // proceed to next
                        self?.updateNext()
                    }
                })
            } else {
                try? realm.write { realm.delete(offlineTask) }
                // proceed to next
                updateNext()
            }
        } else {
            // stop
            self.stop()
        }
    }
    
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
            self?.updateNext()
        }
        Log.info("OfflineTaskManager started")
    }
    
    func stop() {
        self.refreshTimer?.invalidate()
        self.refreshTimer = nil
        Log.info("OfflineTaskManager stopped")
    }
    
    @discardableResult
    func lastFailedTask(for requestId: Int) -> Task? {
        guard let realm = self.realm else { return nil }
        
        if let offlineTask = realm.objects(OfflineTaskUpdate.self).filter("requestId = %@", requestId).sorted(byKeyPath: "createdAt", ascending: false).first,
            let taskString = offlineTask.taskString, let task = Task(rawValue: taskString) {
            return task
        }
        
        return nil
    }
}
