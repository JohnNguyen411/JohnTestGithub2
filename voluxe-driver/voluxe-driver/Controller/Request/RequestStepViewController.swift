//
//  RequestStepViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/24/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class RequestStepViewController: StepViewController {
    
    // MARK: Data
    var request: Request?
    var requestStepDelegate: RequestStepDelegate?
    var task: Task?
    
    init(request: Request?, step: Step?, task: Task?) {
        self.task = task
        super.init(step: step)
        if let request = request {
            fillWithRequest(request: request)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillWithRequest(request: Request) {
        self.request = request
    }
    
    func nextTask() -> Task? { return nil }
    
    func getNextAction() -> String? {
        if let stepTask = step as? StepTask {
            return stepTask.nextTitle
        }
        return nil
    }
    
    func getTaskNumber() -> String? {
        if let stepTask = step as? StepTask {
            return "\(stepTask.taskNumber)"
        }
        return nil
    }
    
    /***
     * Called when the Flow controller wants to progress to next
     * Call the completion block with true to continue, false otherwise
     * Need to override in subclass, always progress by default
     ***/
    func swipeNext(completion: ((Bool) -> ())?) {
        if let task = self.task, let request = self.request {
            self.updateRequest(with: Task.nextTask(for: task, request: request), completion: completion)
        } else {
            completion?(true)
        }
    }

    
    func updateRequest(with task: Task, completion: ((Bool) -> ())?) {
        
        guard let request = self.request else {
            completion?(true)
            return
        }
        
        self.requestStepDelegate?.updateLocalTask(task: task)
        
        if !isBackendTask(task: task) {
            completion?(true)
            return
        }
        
        // check if some task update failed, if yes, queue this update
        // Otherwise proceed to the update
        if OfflineTaskManager.shared.lastFailedTask(for: request.id) != nil {
            OfflineTaskManager.shared.queue(task: task, request: request)
            completion?(true)
            return
        }
        
        //update task
        AppController.shared.lookBusy()
        
        DriverAPI.update(request, task: task, completion: { error in
            
            AppController.shared.lookNotBusy()
            
            if error != nil {
                // TODO check error code
                OfflineTaskManager.shared.queue(task: task, request: request)
            }
            
            completion?(true)
            
        })
    }
    
    func isBackendTask(task: Task) -> Bool {
        if task == .retrieveLoanerVehicleFromDealership ||
            task == .retrieveVehicleFromDealership ||
            task == .driveLoanerVehicleToCustomer ||
            task == .driveVehicleToCustomer ||
            task == .getToCustomer ||
            task == .meetWithCustomer ||
            task == .inspectLoanerVehicle ||
            task == .inspectVehicle ||
            task == .exchangeKeys ||
            task == .driveLoanerVehicleToDealership ||
            task == .driveVehicleToDealership ||
            task == .getToDealership ||
            task == .null {
            return true
        }
        return false
    }
}

protocol RequestStepDelegate {
    func updateLocalTask(task: Task)
}
