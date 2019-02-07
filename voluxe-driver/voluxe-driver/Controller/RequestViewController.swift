//
//  RequestViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class RequestViewController: FlowViewController, RequestStepDelegate, InspectionPhotoDelegate {
    
    // MARK: Data
    private var request: Request
    private var localTask: Task? // current Task
    private var requestTask: Task? // latest request Task
    
    private var navigationStack: [Task] = []

    // MARK: Layout

    private let swipeNextView = SwipeNextView()
    private let subcontainer = UIView()


    // MARK: Lifecycle

    // TODO should not be allowed to start service unless day of
    init(with request: Request) {
        // todo generate steps
        self.request = request
        if let requestTask = request.task {
            self.localTask = requestTask
        } else {
            if self.localTask == nil {
                self.localTask = .schedule
            }
        }
        
        // check offline update task
        if let failedTask = OfflineTaskManager.shared.lastFailedTask(for: request.id) {
            self.localTask = failedTask
        }
        
        let tempSteps = RequestViewController.stepsForTask(task: self.localTask ?? .schedule, request: request)
        
        super.init(steps: tempSteps.0, direction: .vertical)
        
        self.currentIndex = tempSteps.1
        self.currentIndex -= 1 // -1 because pushNextStep will add 1
        
        self.swipeNextView.title = self.steps.first?.nextTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_chevron"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(backButtonTouchUpInside))
        self.addActions()
        
        
        RequestManager.shared.select(request: request)
        RequestManager.shared.requestDidChangeClosure = {
            [weak self] request in
            if let updatedRequest = request {
                if updatedRequest.state == .canceled || updatedRequest.state == .completed {
                    RequestManager.shared.requestDidChangeClosure = nil
                    self?.navigationController?.popViewController(animated: true)
                    return
                }
                self?.request = updatedRequest
                if let requestTask = updatedRequest.task {
                    self?.requestTask = requestTask
                    //self?.refreshUI()
                }
            }
        }
    }
    
    deinit {
        RequestManager.shared.requestDidChangeClosure = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        Layout.add(subview: self.swipeNextView, pinnedToBottomOf: self.view)
        self.swipeNextView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.swipeNextView.addBottomSafeAreaCoverView()
        self.swipeNextView.layer.zPosition = .greatestFiniteMagnitude
        
        Layout.add(subview: self.subcontainer, pinnedToTopOf: self.view)
        self.subcontainer.bottomAnchor.constraint(equalTo: self.swipeNextView.topAnchor).isActive = true
        self.subcontainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.subcontainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.containerView = self.subcontainer

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
    }
    

    // MARK: Stack navigation
    
    override func controllerForStep(step: Step) -> RequestStepViewController? {
        var stepVC: RequestStepViewController?

        // special case for inspection
        if let inspectionStep = step as? InspectionPhotosStep,
            let inspectionType = inspectionStep.inspectionType,
            step.controllerName == InspectionPhotosViewController.className {
            let inspectionVC = InspectionPhotosViewController(request: request, step: step, task: self.localTask, type: inspectionType)
            inspectionVC.inspectionDelegate = self
            stepVC = inspectionVC
            self.containerView = self.view
            if !self.swipeNextView.isHidden {
                self.swipeNextView.isHidden = true
            }
        } else {
            // not inspection
            self.containerView = self.subcontainer
            
            if self.swipeNextView.isHidden {
                self.swipeNextView.isHidden = false
            }

            if step.controllerName == ReviewServiceViewController.className {
                stepVC = ReviewServiceViewController(request: request, step: step, task: self.localTask)
            } else if step.controllerName == LoanerPaperworkViewController.className {
                stepVC = LoanerPaperworkViewController(request: request, step: step, task: self.localTask)
            } else if step.controllerName == RecordMileageViewController.className {
                stepVC = RecordMileageViewController(request: request, step: step, task: self.localTask)
            } else if step.controllerName == DriveToCustomerViewController.className {
                stepVC = DriveToCustomerViewController(request: request, step: step, task: self.localTask)
            } else if step.controllerName == MeetCustomerViewController.className {
                stepVC = MeetCustomerViewController(request: request, step: step, task: self.localTask)
            } else if step.controllerName == InspectionNotesViewController.className {
                stepVC = InspectionNotesViewController(request: request, step: step, task: self.localTask)
            } else if step.controllerName == ExchangeKeysViewController.className {
                stepVC = ExchangeKeysViewController(request: request, step: step, task: self.localTask)
            } else if step.controllerName == ReturnToDealershipViewController.className {
                stepVC = ReturnToDealershipViewController(request: request, step: step, task: self.localTask)
            } else if step.controllerName == ReceiveLoanerViewController.className {
                stepVC = ReceiveLoanerViewController(request: request, step: step, task: self.localTask)
            }
        }
        stepVC?.requestStepDelegate = self
        return stepVC
    }
    

    override func updateTitle() {
        super.updateTitle()
        let step = steps[currentIndex]
        self.swipeNextView.title = step.nextTitle

    }
    
    // MARK: Actions
    /*
    override func popStep() -> Bool {
        let hasPrevious = super.popStep()
        if !hasPrevious, let previousTask = navigationStack.last {
            self.localTask = previousTask
            self.steps = RequestViewController.stepsForTask(task: self.localTask, request: self.request)
            self.currentIndex = self.steps.count - 1
            
            // try to pop again with previous task, if failed, fuck it then
            navigationStack.removeLast()
            if self.steps.count > 0 {
                return super.pop(step: self.steps[currentIndex])
            }
        }
        return hasPrevious
    }*/

    private func addActions() {
        self.swipeNextView.nextClosure = { [weak self] in
            self?.next()
        }
    }
    
    private func next() {
        if let currentVC = self.currentVC as? RequestStepViewController {
            currentVC.swipeNext(completion: { success in
                guard self.pushNextStep() == false else { return }
                RequestManager.shared.requestDidChangeClosure = nil
                self.navigationController?.popViewController(animated: true)
            })
        }
    }

    @objc func backButtonTouchUpInside() {
        guard self.popStep() == false else { return }
        if let currentVC = self.currentVC {
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
            currentVC.didMove(toParent: nil)
        }
        RequestManager.shared.requestDidChangeClosure = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Steps
    
    override func refreshSteps() {
        /*
        var updatedTask = false
        // TODO: HANDLE TASK CHANGE FROM BACKEND
        if let requestTask = request.task, let localTask = self.localTask {
            if Task.isGreater(requestTask, than: localTask) {
                self.updateLocalTask(task: requestTask)
                updatedTask = true
            }
        }
         */
 
        
        // need to refresh task everytime to discard the previous task if necessary
        let tempSteps = RequestViewController.stepsForTask(task: self.localTask ?? .schedule, request: self.request)
        self.steps = tempSteps.0
        self.currentIndex = tempSteps.1
        self.currentIndex -= 1
        
    }
    
    private static func stepByStep(for task: Task?, request: Request) -> [StepTask] {
        var newSteps: [StepTask] = []
        if let task = task {
            if task == .schedule {
                newSteps = [StepTask(title: .localized(request.isDropOff ? .viewStartRequestDropoff : .viewStartRequestPickup),
                                 controllerName: ReviewServiceViewController.className,
                                 nextTitle: .localized(.viewStartRequestSwipeButtonTitle), task: task)]
            } else if task == .retrieveLoanerVehicleFromDealership || task == .retrieveVehicleFromDealership || task == .retrieveForms {
                newSteps = firstStepsForRequest(request: request)
            } else if task == .driveLoanerVehicleToCustomer || task == .driveVehicleToCustomer || task == .getToCustomer {
                newSteps = [StepTask(title: .localized(.viewDrivetoCustomer), controllerName: DriveToCustomerViewController.className, nextTitle: .localized(.viewGettoCustomerSwipeButtonTitle), task: task)]
            } else if task == .meetWithCustomer {
                newSteps = [StepTask(title: .localized(.viewArrivedatCustomer), controllerName: MeetCustomerViewController.className, nextTitle: .localized(.viewArrivedatDeliverySwipeButtonTitle), task: task)]
            } else if task == .receiveLoanerVehicle {
                newSteps = [StepTask(title: .localized(.viewReceiveVehicleLoaner), controllerName: ReceiveLoanerViewController.className, nextTitle: .localized(.viewReceiveVehicleLoanerSwipeButtonTitle), task: task)]
            } else if task == .inspectLoanerVehicle {
                newSteps = [InspectionPhotosStep(task: task, type: .loaner)]
            } else if task == .inspectVehicle {
                newSteps = [InspectionPhotosStep(task: task, type: .vehicle)]
            } else if task == .inspectDocuments {
                newSteps = [InspectionPhotosStep(task: task, type: .document)]
            } else if task == .inspectNotes {
                newSteps = [StepTask(title: .localized(.viewInspectNotes), controllerName: InspectionNotesViewController.className, nextTitle: .localized(.viewInspectNotesSwipeButtonTitle), task: task)]
            } else if task == .exchangeKeys {
                newSteps = [StepTask(title: .localized(.exchangeKeys), controllerName: ExchangeKeysViewController.className, nextTitle: .localized(.viewExchangeKeysPickupSwipeTitle), task: task)]
            } else if task == .driveVehicleToDealership || task == .driveLoanerVehicleToDealership || task == .getToDealership {
                newSteps = [StepTask(title: .localized(.returnToDealership), controllerName: ReturnToDealershipViewController.className, nextTitle: .localized(.viewGettoDealershipSwipeButtonTitle), task: task)]
            } else if task == .recordLoanerMileage {
                newSteps = [StepTask(title: .localized(.viewRecordLoanerMileage), controllerName: RecordMileageViewController.className, nextTitle: .localized(.viewRecordLoanerMileagePickupSwipeButtonTitle), task: task)]
            }
        }
        return newSteps
    }
    
    private static func stepsForTask(task: Task, request: Request) -> ([StepTask], Int) {

        var currentTask: Task = .schedule
        var allSteps: [StepTask] = RequestViewController.stepByStep(for: currentTask, request: request)
        var targetTask: Task
        if let firstTask = allSteps.first,  task == .schedule {
            targetTask = firstTask.task
        } else {
            targetTask = task
        }
        
        while currentTask != .null {
            currentTask = Task.nextTask(for: currentTask, request: request)
            allSteps.append(contentsOf: RequestViewController.stepByStep(for: currentTask, request: request))
        }
        
        var strippedSteps: [StepTask] = []
        var taskReached = false
        
        for step in allSteps {
            // if it's inspection, leave it
            if step.task == .inspectLoanerVehicle || step.task == .inspectVehicle || step.task == .inspectDocuments || step.task == .inspectNotes {
                strippedSteps.append(step)
            } else if taskReached {
                strippedSteps.append(step)
            } else if !taskReached && step.task == targetTask {
                taskReached = true
                strippedSteps.append(step)
            }
        }
        
        var index = 0
        for step in strippedSteps {
            if step.task == targetTask {
                break
            } else {
                index += 1
            }
        }
        return (strippedSteps, index)
    }
    
    private static func firstStepsForRequest(request: Request) -> [StepTask] {
        var newSteps: [StepTask] = []
        
        if request.isPickup {
            if request.hasLoaner {
                newSteps.append(StepTask(title: .localized(.viewRetrieveVehicleLoaner), controllerName: LoanerPaperworkViewController.className, nextTitle: .localized(.viewRetrieveVehicleLoanerSwipeTitle), task: .retrieveLoanerVehicleFromDealership))
                newSteps.append(StepTask(title: .localized(.viewRecordLoanerMileage), controllerName: RecordMileageViewController.className, nextTitle: .localized(.viewRecordLoanerMileagePickupSwipeButtonTitle), task: .recordLoanerMileage))
            } else {
                newSteps.append(StepTask(title: .localized(.viewRetrieveForms), controllerName: LoanerPaperworkViewController.className, nextTitle: .localized(.viewRetrieveFormsInfoNext), task: .retrieveForms))
            }
            
            
        } else {
            newSteps.append(StepTask(title: .localized(.viewRetrieveVehicleCustomer), controllerName: LoanerPaperworkViewController.className, nextTitle: .localized(.viewRetrieveVehicleCustomerSwipeTitle), task: .retrieveVehicleFromDealership))
        }
        return newSteps
    }
    

    // MARK: RequestStepDelegate

    func updateLocalTask(task: Task) {
        // add task to backstack
        if let copyTask = self.localTask {
            if let queueTask = Task(rawValue: copyTask.rawValue) {
                self.navigationStack.append(queueTask)
            }
        }
        self.localTask = task
    }
    
    // MARK: InspectionPhotoDelegate

    func done(inspectionType: InspectionType) {
        self.next()
    }
}


class StepTask: Step {
    let task: Task
    
    init(title: String, controllerName: String, nextTitle: String?, task: Task) {
        self.task = task
        super.init(title: title, controllerName: controllerName, nextTitle: nextTitle)
    }
}
