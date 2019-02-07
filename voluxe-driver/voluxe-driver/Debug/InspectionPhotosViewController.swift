//
//  InspectionPhotosViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 1/8/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class InspectionPhotosViewController: RequestStepViewController {

    // MARK: Data

    private var type: InspectionType = .document
    var inspectionDelegate: InspectionPhotoDelegate?
  
    // MARK: Layout

    private let inspectionCameraView = InspectionCameraView()

    // MARK: Lifecycle

    deinit {
        self.inspectionCameraView.removeFromSuperview()
    }
    
    convenience init(type: InspectionType) {
        self.init(request: nil, step: nil, task: nil, type: type)
    }
    
    convenience init(request: Request?, step: Step?, task: Task?, type: InspectionType) {
        self.init(request: request, step: step, task: task)
        self.type = type
        self.inspectionCameraView.update(for: type)
        
        switch type {
            case .document: self.navigationItem.title = "Photo License, Insurance"
            case .loaner: self.navigationItem.title = "Photo Loaner"
            case .vehicle: self.navigationItem.title = "Photo Customer Vehicle"
            default: self.navigationItem.title = "Inspection Photos"
        }
        
        self.addActions()
        
    }

    override func loadView() {
        self.view = self.inspectionCameraView
    }
    
    override func viewDidLoad() {
        self.request = RequestManager.shared.request
        super.viewDidLoad()
        self.loadPhotos()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inspectionCameraView.cameraView.open()
    }
    
    private func loadPhotos() {
        
        guard let request = RequestManager.shared.request else { return }
        let inspections = RequestManager.shared.offlineInspections(for: request.id, type: self.type)
        
        if inspections.count > 0 {
            // populate photos
            self.inspectionCameraView.populate(with: inspections)
        }
        
    }

    // MARK: Actions

    private func addActions() {

        self.inspectionCameraView.photoWasTaken = {
            photo in
            RequestManager.shared.addInspection(photo: photo, type: self.type)
        }

        self.inspectionCameraView.shutterView.doneButton.addTarget(self, action: #selector(doneButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func doneButtonTouchUpInside() {
        if let inspectionDelegate = self.inspectionDelegate {
            inspectionDelegate.done(inspectionType: self.type)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

protocol InspectionPhotoDelegate {
    func done(inspectionType: InspectionType)
}


class InspectionPhotosStep: StepTask {
    var inspectionType: InspectionType?
    
    init(task: Task, type: InspectionType) {
        var title = "Inspect Loaner"
        if type == .vehicle {
            title = "Inspect Vehicle"
        } else if type == .document {
            title = "Photo License, Insurance"
        }
        super.init(title: title, controllerName: InspectionPhotosViewController.className, nextTitle: nil, task: task)
        self.inspectionType = type
    }
}
