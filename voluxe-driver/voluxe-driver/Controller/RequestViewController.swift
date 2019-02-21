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
    
    // MARK: Analytics
    private var screen: AnalyticsEnums.Name.Screen?

    // MARK: Data
    private var request: Request
    private var localTask: Task? // current Task
    private var requestTask: Task? // latest request Task
    
    private var navigationStack: [Task] = []

    // MARK: Layout

    private let swipeNextView = SwipeNextView()
    private let subcontainer = UIView()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppController.shared.requestLocationPermissions()
    }
    
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
            if request.task != nil {
                self.localTask = failedTask
            }
        }
        
        let tempSteps = RequestViewController.stepsForTask(task: self.localTask ?? .schedule, request: request)
        
        super.init(steps: tempSteps.0, direction: .vertical)
        
        self.currentIndex = tempSteps.1
        self.currentIndex -= 1 // -1 because pushNextStep will add 1
        
        self.swipeNextView.title = self.steps.first?.swipeTitle
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
        
        guard let stepTask = step as? StepTask else { return nil }
        
        var stepVC: RequestStepViewController?

        // special case for inspection
        if let inspectionStep = step as? InspectionPhotosStep,
            let inspectionType = inspectionStep.inspectionType,
            stepTask.controllerName == InspectionPhotosViewController.className {
            let inspectionVC = InspectionPhotosViewController(request: request, step: stepTask, task: self.localTask, type: inspectionType)
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
                stepVC = ReviewServiceViewController(request: request, step: stepTask, task: self.localTask)
            } else if step.controllerName == LoanerPaperworkViewController.className {
                stepVC = LoanerPaperworkViewController(request: request, step: stepTask, task: self.localTask)
            } else if step.controllerName == RecordMileageViewController.className {
                stepVC = RecordMileageViewController(request: request, step: stepTask, task: self.localTask)
            } else if step.controllerName == DriveToCustomerViewController.className {
                stepVC = DriveToCustomerViewController(request: request, step: stepTask, task: self.localTask)
            } else if step.controllerName == MeetCustomerViewController.className {
                stepVC = MeetCustomerViewController(request: request, step: stepTask, task: self.localTask)
            } else if step.controllerName == InspectionNotesViewController.className {
                stepVC = InspectionNotesViewController(request: request, step: stepTask, task: self.localTask)
            } else if step.controllerName == ExchangeKeysViewController.className {
                stepVC = ExchangeKeysViewController(request: request, step: stepTask, task: self.localTask)
            } else if step.controllerName == ReturnToDealershipViewController.className {
                stepVC = ReturnToDealershipViewController(request: request, step: stepTask, task: self.localTask)
            } else if step.controllerName == ReceiveLoanerViewController.className {
                stepVC = ReceiveLoanerViewController(request: request, step: stepTask, task: self.localTask)
            }
        }
        stepVC?.flowDelegate = self
        stepVC?.requestStepDelegate = self
        return stepVC
    }
    

    override func updateTitle() {
        super.updateTitle()
        let step = steps[currentIndex]
        self.swipeNextView.title = step.swipeTitle
        
        // Analytics
        if let task = self.localTask {
            let screen = AnalyticsEnums.screen(for: task, request: self.request)
            Analytics.trackView(screen: screen)
            self.screen = screen
        }

    }
    
    // MARK: Actions

    private func addActions() {
        self.swipeNextView.nextClosure = { [weak self] in
            // Analytic
            
            if let task = self?.localTask {
                Analytics.trackSlide(task: task.rawValue, screen: self?.screen)
            }
            
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
        Analytics.trackClick(navigation: .back, screen: self.screen)
        
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
    
    private static func stepByStep(for task: Task, request: Request) -> [StepTask] {
        var newSteps: [StepTask] = []
            
        if task == .retrieveLoanerVehicleFromDealership || task == .retrieveVehicleFromDealership || task == .retrieveForms {
            newSteps = firstStepsForRequest(request: request)
        } else {
            newSteps = [StepTask.buildStepTask(for: task, with: request)]
        }
            
        return newSteps
    }
    
    private static func stepsForTask(task: Task, request: Request) -> ([StepTask], Int) {
        OSLog.info("stepsForTask \(task.rawValue)")
        
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
        
        var position = 1

        OSLog.info("stepsForTask allSteps: \(allSteps.count)")

        for step in allSteps {
            OSLog.info("stepsForTask allSteps: \(step.task.rawValue)")
            step.taskNumber = position
            // if it's inspection, leave it
            if step.task == .inspectLoanerVehicle || step.task == .inspectVehicle || step.task == .inspectDocuments || step.task == .inspectNotes {
                strippedSteps.append(step)
            } else if taskReached {
                strippedSteps.append(step)
            } else if !taskReached && step.task == targetTask {
                taskReached = true
                strippedSteps.append(step)
            }
            position += 1
        }
        
        
        OSLog.info("stepsForTask strippedSteps: \(strippedSteps.count)")
        
        var index = 0
        for step in strippedSteps {
            OSLog.info("stepsForTask strippedSteps: \(step.task.rawValue)")
            if step.task == targetTask {
                break
            } else {
                index += 1
            }
        }
        
        OSLog.info("stepsForTask \(task.rawValue), count \(strippedSteps.count), index \(index)")
        return (strippedSteps, index)
    }
    
    private static func firstStepsForRequest(request: Request) -> [StepTask] {
        var newSteps: [StepTask] = []
        
        if request.isPickup {
            if request.hasLoaner {
                newSteps.append(StepTask.buildStepTask(for: .retrieveLoanerVehicleFromDealership, with: request))
                //newSteps.append(StepTask.buildStepTask(for: .recordLoanerMileage, with: request))
            } else {
                newSteps.append(StepTask.buildStepTask(for: .retrieveForms, with: request))
            }
            
        } else {
            newSteps.append(StepTask.buildStepTask(for: .retrieveVehicleFromDealership, with: request))
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
    
    func showToast(message: String) {
        self.view.showToast(toastMessage: message, duration: 3, font: Font.Medium.regular, position: .bottom)
    }
    
    // MARK: InspectionPhotoDelegate

    func done(inspectionType: InspectionType) {
        self.next()
    }
}


class StepTask: Step {
    let task: Task
    var taskNumber: Int = 1// position in flow (!= position in stack)

    init(title: String, controllerName: String, swipeTitle: String? = nil, nextTitle: String? = nil, task: Task) {
        self.task = task
        super.init(title: title, controllerName: controllerName, swipeTitle: swipeTitle, nextTitle: nextTitle)
    }
    
    static func buildStepTask(for task: Task, with request: Request) -> StepTask {
        
        var title = ""
        var swipe = ""
        var next: String?
        var controllerName = ""
        
        if task == .schedule {
            
            title = .localized(request.isDropOff ? .viewStartRequestDropoff : .viewStartRequestPickup)
            controllerName = ReviewServiceViewController.className
            swipe = .localized(.viewStartRequestSwipeButtonTitle)
            if request.isPickup {
                if request.hasLoaner {
                    next = .localized(.viewStartRequestRetrieveLoaner)
                } else {
                    next = .localized(.viewStartRequestRetrieveForms)
                }
            } else {
                next = .localized(.viewStartRequestRetrieveCustomerVehicle)
            }
        } else if task == .retrieveLoanerVehicleFromDealership {
            
            title = .localized(.viewRetrieveVehicleLoaner)
            controllerName = LoanerPaperworkViewController.className
            swipe = .localized(.viewRetrieveVehicleLoanerSwipeTitle)
            next = .localized(.viewRecordLoanerMileage)
            
        } else if task == .retrieveVehicleFromDealership {
            
            title = .localized(.viewRetrieveVehicleCustomer)
            controllerName = LoanerPaperworkViewController.className
            swipe = .localized(.viewRetrieveVehicleCustomerSwipeTitle)
            next = .localized(.viewRetrieveVehicleCustomerInfoNext)
            
        } else if task == .retrieveForms {
            
            title = .localized(.viewRetrieveForms)
            controllerName = LoanerPaperworkViewController.className
            swipe = .localized(.viewRetrieveFormsSwipeTitle)
            next = .localized(.viewRetrieveFormsInfoNext)
            
        } else if task == .driveLoanerVehicleToCustomer || task == .driveVehicleToCustomer || task == .getToCustomer {
            
            title = .localized(.viewDrivetoCustomer)
            controllerName = DriveToCustomerViewController.className
            swipe = .localized(.viewGettoCustomerSwipeButtonTitle)
            next = .localized(.viewGettoCustomerArriveatCustomer)
            
            if task == .getToCustomer {
                title = .localized(.viewGettoCustomer)
                swipe = .localized(.viewGettoCustomerSwipeButtonTitle)
                next = .localized(.viewGettoCustomerArriveatCustomer)
            }
        }
        
        else if task == .meetWithCustomer {
            
            title = .localized(.viewArrivedatCustomer)
            controllerName = MeetCustomerViewController.className
            swipe = .localized(.viewArrivedatPickupSwipeButtonTitle)
            next = .localized(.inspectVehicles)
            
            if request.isPickup {
                if !request.hasLoaner {
                    next = .localized(.inspectVehicle)
                }
            } else {
                next = .localized(.viewArrivedatDeliveryInspectVehicles)
                swipe = .localized(.viewArrivedatDeliverySwipeButtonTitle)
            }
            
        } else if task == .receiveLoanerVehicle {
            
            title = .localized(.viewReceiveVehicleLoaner)
            controllerName = ReceiveLoanerViewController.className
            swipe = .localized(.viewReceiveVehicleLoanerSwipeButtonTitle)
            next = .localized(.viewReceiveVehicleLoanerNext)
            
        } else if task == .inspectLoanerVehicle {
            
            return InspectionPhotosStep(task: task, type: .loaner)
            
        } else if task == .inspectVehicle {
            
            return InspectionPhotosStep(task: task, type: .vehicle)

        } else if task == .inspectDocuments {
            
            return InspectionPhotosStep(task: task, type: .document)
            
        } else if task == .inspectNotes {
            
            title = .localized(.viewInspectNotes)
            controllerName = InspectionNotesViewController.className
            swipe = .localized(.viewInspectNotesSwipeButtonTitle)
            next = .localized(.exchangeKeys)
            
        } else if task == .exchangeKeys {
            
            title = .localized(.exchangeKeys)
            controllerName = ExchangeKeysViewController.className
            swipe = .localized(.viewExchangeKeysPickupSwipeTitle)
            next = .localized(.returnToDealership)
            
        } else if task == .driveVehicleToDealership || task == .driveLoanerVehicleToDealership || task == .getToDealership {
            
            title = .localized(.returnToDealership)
            controllerName = ReturnToDealershipViewController.className
            swipe = .localized(.viewGettoDealershipSwipeButtonTitle)
            next = nil
            
            if request.isDropOff && request.hasLoaner {
                next = .localized(.viewRecordLoanerMileage)
            }
            
        } else if task == .recordLoanerMileage {
            
            title = .localized(.viewRecordLoanerMileage)
            controllerName = RecordMileageViewController.className
            swipe = .localized(.viewRecordLoanerMileagePickupSwipeButtonTitle)
            next = .localized(.viewDrivetoCustomer)
            
            if request.isDropOff {
                swipe = .localized(.viewRecordLoanerMileageDropoffSwipeButtonTitle)
                next = nil
            }
        }
        return StepTask(title: title, controllerName: controllerName, swipeTitle: swipe, nextTitle: next, task: task)
    }
}
