//
//  InspectionPhotosViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 1/8/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class InspectionPhotosViewController: UIViewController {

    // MARK: Data

    private var type: InspectionType = .document
  
    // MARK: Layout

    private let inspectionCameraView = InspectionCameraView()

    // MARK: Lifecycle

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Inspection Photos"
        self.addActions()
    }

    convenience init(type: InspectionType) {

        self.init()
        self.type = type
        self.inspectionCameraView.update(for: type)

        switch type {
            case .document: self.navigationItem.title = "Photo License, Insurance"
            case .loaner: self.navigationItem.title = "Photo Loaner"
            case .vehicle: self.navigationItem.title = "Photo Customer Vehicle"
            default: self.navigationItem.title = "Inspection Photos"
        }
    }

    override func loadView() {
        self.view = self.inspectionCameraView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inspectionCameraView.cameraView.open()
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
        self.navigationController?.popViewController(animated: true)
    }
}
