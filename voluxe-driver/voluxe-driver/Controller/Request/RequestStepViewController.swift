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
    
    // MARK: Layout
    var scrollView: UIScrollView?
    var contentView: UIView?
    
    let titleLabel = Label.taskTitle()
    let titleNumber = Label.taskTitleNumber()

    let nextLabel = Label.taskTitle()
    let nextTitleNumber = Label.taskNextNumber()

    let leftLine = UIView()

    
    // MARK: Data
    var request: Request?
    var requestStepDelegate: RequestStepDelegate?
    var task: Task?
    var screenName: AnalyticsEnums.Name.Screen?

    init(request: Request?, step: StepTask?, task: Task?) {
        self.task = task
        super.init(step: step)
        if let request = request {
            fillWithRequest(request: request)
            if let task = step?.task {
                self.screenName = analyticScreenName(task: task, request: request)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        self.scrollView = Layout.scrollView(in: self)
        self.contentView = Layout.verticalContentView(in: scrollView!)
        self.contentView!.clipsToBounds = true
        
        self.contentView!.addSubview(self.titleLabel)
        self.titleLabel.pinToSuperviewTop(spacing: 30)
        self.titleLabel.pinLeadingToSuperView(constant: 65)
        self.titleLabel.pinTrailingToSuperView(constant: -30)
        
        self.leftLine.translatesAutoresizingMaskIntoConstraints = false
        self.contentView!.addSubview(self.leftLine)
        
        self.contentView!.addSubview(self.titleNumber)
        self.titleNumber.leadingAnchor.constraint(equalTo: self.contentView!.leadingAnchor, constant: 25).isActive = true
        self.titleNumber.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor).isActive = true
        self.titleNumber.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.titleNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true

        self.nextLabel.textColor = UIColor.Volvo.slate
        
        self.leftLine.backgroundColor = UIColor.Volvo.fog
        self.leftLine.constrain(width: 1)
        self.leftLine.centerXAnchor.constraint(equalTo: self.titleNumber.centerXAnchor).isActive = true

        guard let stepTask = step as? StepTask else {
            return
        }
        
        if stepTask.taskNumber == 1 {
            // start line at titleLabel
            self.leftLine.pinTopToBottomOf(view: self.titleLabel)
        } else {
            self.leftLine.pinTopToSuperview()
        }
        
        self.titleNumber.text = "\(stepTask.taskNumber)"

        if let nextTitle = stepTask.nextTitle {
            
            self.contentView!.addSubview(self.nextLabel)
            self.nextLabel.pinBottomToSuperviewBottom(spacing: -30)
            self.nextLabel.pinLeadingToView(peerView: self.titleLabel)
            
            self.contentView!.addSubview(self.nextTitleNumber)
            self.nextTitleNumber.centerYAnchor.constraint(equalTo: self.nextLabel.centerYAnchor).isActive = true
            self.nextTitleNumber.pinLeadingToView(peerView: self.titleNumber)
            self.nextTitleNumber.widthAnchor.constraint(equalToConstant: 25).isActive = true
            self.nextTitleNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
            self.nextTitleNumber.text = "\(stepTask.taskNumber+1)"
            
            self.nextLabel.text = nextTitle
            self.leftLine.pinBottomToBottomOf(view: self.nextLabel)
        } else {
            self.leftLine.pinBottomToBottomOf(view: self.titleLabel)
        }
        
    }
    
    func addViews(_ views: [UIView]) {
        
        guard let contentView = self.contentView else { return }
        
        var previousView: UIView = self.titleLabel
        for view in views {
            contentView.addSubview(view)
            
            view.pinTopToBottomOf(view: previousView, spacing: 5)
            view.pinLeadingToView(peerView: previousView)
            view.pinTrailingToSuperView(constant: -20)
            
            previousView = view
        }
    }
    
    func addView(_ view: UIView, below: UIView, spacing: CGFloat) {
        guard let contentView = self.contentView else { return }
        contentView.addSubview(view)
        
        view.pinTopToBottomOf(view: below, spacing: spacing)
        view.pinLeadingToView(peerView: below)
        view.pinTrailingToSuperView(constant: -20)
        
    }
    
    func setTitle(attributedString: NSAttributedString) {
        self.titleLabel.attributedText = attributedString
        self.titleLabel.sizeToFit()
    }
    
    func hideLeftLine() {
        self.scrollView?.isHidden = true
        self.contentView?.isHidden = true
        self.leftLine.isHidden = true
        self.titleNumber.isHidden = true
        self.nextTitleNumber.isHidden = true
        self.nextLabel.isHidden = true
    }
    
    func intermediateMediumFont() -> UIFont {
        return Font.Intermediate.medium
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
    
    func getStepTask() -> Task? {
        if let stepTask = step as? StepTask {
            return stepTask.task
        }
        return nil
    }
    
    /***
     * Called when the Flow controller wants to progress to next
     * Call the completion block with true to continue, false otherwise
     * Need to override in subclass, always progress by default
     ***/
    func swipeNext(completion: ((Bool) -> ())?) {
        if let task = self.getStepTask(), let request = self.request {
            self.updateRequest(with: Task.nextTask(for: task, request: request), completion: completion)
        } else {
            completion?(true)
        }
    }
    
    
    //MARK: - Analytics
    private func analyticScreenName(task: Task, request: Request) -> AnalyticsEnums.Name.Screen {
        return AnalyticsEnums.screen(for: task, request: request)
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
    func showToast(message: String)
}
