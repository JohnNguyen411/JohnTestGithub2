//
//  InspectionPhotosViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 1/8/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class InspectionPhotosViewController: RequestStepViewController {

    //MARK: Rotation
    private var deviceOrientationHelper = DeviceOrientationHelper.shared
    
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
    
    convenience init(request: Request?, step: StepTask?, task: Task?, type: InspectionType) {
        self.init(request: request, step: step, task: task)
        self.type = type
        self.inspectionCameraView.update(for: type)
        self.inspectionCameraView.screenName = self.screenName
        
        switch type {
            case .document: self.navigationItem.title = .localized(.viewInspectDocuments)
            case .loaner: self.navigationItem.title = .localized(.viewInspectLoaner)
            case .vehicle: self.navigationItem.title = .localized(.viewInspectCustomer)
            default: self.navigationItem.title = .localized(.viewInspectDocuments)
        }
        
        self.addActions()
        
    }

    override func loadView() {
        self.view = self.inspectionCameraView
    }
    
    override func viewDidLoad() {
        self.request = RequestManager.shared.request
        super.viewDidLoad()
        
        // we need to rotate the device in Landscape
        self.orientationChanged(deviceOrientation: .landscapeRight)
        
        self.hideLeftLine()
        DispatchQueue.global(qos: .background).async {
            self.loadPhotos()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // check permission
        DispatchQueue.main.async {
            self.checkCameraPermission()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.deviceOrientationHelper.startDeviceOrientationNotifier { (deviceOrientation) in
                self.orientationChanged(deviceOrientation: deviceOrientation)
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.deviceOrientationHelper.stopDeviceOrientationNotifier()
        super.viewWillDisappear(animated)
    }
    
    // MARK: Rotation
    func orientationChanged(deviceOrientation: UIDeviceOrientation) {
        var angle: Double?
        
        switch deviceOrientation {
        case .portrait:
            angle = 0
            break
        case .portraitUpsideDown:
            angle = Double.pi
            break
        case .landscapeLeft:
            angle = -Double.pi / 2
            break
        case .landscapeRight:
            angle = Double.pi / 2
            break
        default:
            break
        }
        
        if let angle = angle {
            // rotate buttons and thumbnails
            self.inspectionCameraView.rotate(angle: angle)
        }
    }
    
    private func checkCameraPermission() {
        let authorisationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorisationStatus == .authorized {
            //already authorized
            self.inspectionCameraView.cameraView.open()
        } else if authorisationStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        //access allowed
                        self.inspectionCameraView.cameraView.open()
                    } else {
                        //access denied
                        self.alertBlockPermission()
                    }
                }
            })
        } else {
            self.alertBlockPermission()
        }
    }
    
    private func alertBlockPermission() {
        AppController.shared.alert(title: .localized(.permissionsCameraDeniedTitle),
                                   message: .localized(.permissionsCameraDeniedMessage),
                                   cancelButtonTitle: .localized(.close),
                                   cancelCompletion: {
                                        DispatchQueue.main.async {
                                            self.checkCameraPermission()
                                        }
                                    },
                                    okButtonTitle: .localized(.openSettings),
                                    okCompletion: {
                                        // open settings
                                        self.openSettings()
                                })
    }
    
    private func openSettings() {
        let string = UIApplication.openSettingsURLString
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url, options: [:])
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
        var title = String.localized(.viewInspectLoaner)
        if type == .vehicle {
            title = String.localized(.viewInspectCustomer)
        } else if type == .document {
            title = String.localized(.viewInspectDocuments)
        }
        super.init(title: title, controllerName: InspectionPhotosViewController.className, nextTitle: nil, task: task)
        self.inspectionType = type
    }
}
