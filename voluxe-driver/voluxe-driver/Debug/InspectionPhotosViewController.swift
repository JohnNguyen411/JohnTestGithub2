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
        self.inspectionCameraView.showOverlay(for: type)
    }

    override func loadView() {
        self.view = self.inspectionCameraView
    }

    // TODO load inspection photos of current request

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inspectionCameraView.cameraView.open()
    }

    // MARK: Actions

    private func addActions() {

        self.inspectionCameraView.photoWasTaken = {
            photo in
            // TODO send to RequestManager
            // TODO hide overlay image?\
            RequestManager.shared.addInspection(photo: photo, type: .document)
        }

        self.inspectionCameraView.shutterView.doneButton.addTarget(self, action: #selector(doneButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func doneButtonTouchUpInside() {
        self.navigationController?.popViewController(animated: true)
    }
}
