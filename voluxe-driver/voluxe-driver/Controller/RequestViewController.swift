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
        
        super.init(steps: RequestViewController.stepsForTask(task: self.localTask, request: request), direction: .vertical)
        
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
        var updatedTask = false
        // if task change, reset index
        if let requestTask = request.task, let localTask = self.localTask {
            if Task.isGreater(requestTask, than: localTask) {
                self.updateLocalTask(task: requestTask)
                updatedTask = true
            }
        }
        
        if (self.currentIndex >= 0 && self.currentIndex == self.steps.count-1) || updatedTask  {
            self.currentIndex = -1
            
            self.steps = RequestViewController.stepsForTask(task: self.localTask, request: self.request)
        }
    }
    
    private static func stepsForTask(task: Task?, request: Request) -> [Step] {
   
        
        var newSteps: [Step] = []
        if let task = task {
            if task == .schedule {
                newSteps = [Step(title: .localized(request.isDropOff ? .viewStartRequestPickup : .viewStartRequestDropoff) ,
                      controllerName: ReviewServiceViewController.className,
                      nextTitle: .localized(.viewStartRequestSwipeButtonTitle))]
            } else if task == .retrieveLoanerVehicleFromDealership || task == .retrieveVehicleFromDealership {
                newSteps = firstStepsForRequest(request: request)
            } else if task == .driveLoanerVehicleToCustomer || task == .driveVehicleToCustomer {
                newSteps = [Step(title: .localized(.viewDrivetoCustomer), controllerName: DriveToCustomerViewController.className, nextTitle: .localized(.viewGettoCustomerSwipeButtonTitle))]
            } else if task == .meetWithCustomer {
                newSteps = [Step(title: .localized(.viewArrivedatCustomer), controllerName: MeetCustomerViewController.className, nextTitle: .localized(.viewArrivedatDeliverySwipeButtonTitle))]
            } else if task == .receiveLoanerVehicle {
                newSteps = [Step(title: .localized(.viewReceiveVehicleLoaner), controllerName: ReceiveLoanerViewController.className, nextTitle: .localized(.viewReceiveVehicleLoanerSwipeButtonTitle))]
            } else if task == .inspectLoanerVehicle {
                newSteps = [InspectionPhotosStep(type: .loaner)]
            } else if task == .inspectVehicle {
                newSteps = [InspectionPhotosStep(type: .vehicle)]
            } else if task == .inspectDocuments {
                newSteps = [InspectionPhotosStep(type: .document)]
            } else if task == .inspectNotes {
                newSteps = [Step(title: .localized(.viewInspectNotes), controllerName: InspectionNotesViewController.className, nextTitle: .localized(.viewInspectNotesSwipeButtonTitle))]
            } else if task == .exchangeKeys {
                newSteps = [Step(title: .localized(.exchangeKeys), controllerName: ExchangeKeysViewController.className, nextTitle: .localized(.viewExchangeKeysPickupSwipeTitle))]
            } else if task == .driveVehicleToDealership || task == .driveLoanerVehicleToDealership {
                newSteps = [Step(title: .localized(.returnToDealership), controllerName: ReturnToDealershipViewController.className, nextTitle: .localized(.viewGettoDealershipSwipeButtonTitle))]
            } else if task == .recordLoanerMileage {
                newSteps = [Step(title: .localized(.viewRecordLoanerMileage), controllerName: RecordMileageViewController.className, nextTitle: .localized(.viewRecordLoanerMileagePickupSwipeButtonTitle))]
            }
            
        } else {
            newSteps = firstStepsForRequest(request: request)
        }
        
        return newSteps
    }
    
    private static func firstStepsForRequest(request: Request) -> [Step] {
        var newSteps: [Step] = []
        
        if request.isPickup {
            if request.hasLoaner {
                newSteps.append(Step(title: .localized(.viewRetrieveVehicleLoaner), controllerName: LoanerPaperworkViewController.className, nextTitle: .localized(.viewRetrieveVehicleLoanerSwipeTitle)))
                newSteps.append(Step(title: .localized(.viewRecordLoanerMileage), controllerName: RecordMileageViewController.className, nextTitle: .localized(.viewRecordLoanerMileagePickupSwipeButtonTitle)))
            } else {
                newSteps.append(Step(title: .localized(.viewRetrieveForms), controllerName: LoanerPaperworkViewController.className, nextTitle: .localized(.viewRetrieveFormsInfoNext)))
            }
            
            
        } else {
            newSteps.append(Step(title: .localized(.viewRetrieveVehicleCustomer), controllerName: LoanerPaperworkViewController.className, nextTitle: .localized(.viewRetrieveVehicleCustomerSwipeTitle)))
        }
        return newSteps
    }

    // MARK: RequestStepDelegate

    func updateLocalTask(task: Task) {
        self.localTask = task
    }
    
    // MARK: InspectionPhotoDelegate

    func done(inspectionType: InspectionType) {
        self.next()
    }
}
