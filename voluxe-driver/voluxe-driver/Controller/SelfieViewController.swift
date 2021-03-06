//
//  SelfieViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/20/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class SelfieViewController: StepViewController, ShutterViewProtocol {

    // MARK: Data

    private var image: UIImage?
    private var error: CameraView.OptionError?

    // MARK: Layout

    private let cameraView: CameraView = {
        let view = CameraView(position: .front)
        view.cropColor = UIColor.Volvo.white.withAlphaComponent(0.4)
        view.cropTopLeft = CGPoint(x: 16, y: 36)
        view.showTakenPhoto = true
        view.requireFaceDetection = true
        view.useFlash = false
        return view
    }()

    private let shutterView: ShutterView = {
        let view = ShutterView()
        view.numberOfPhotosRequired = 1
        view.incrementNumberOfPhotosTakenOnShutter = false
        return view
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.Volvo.granite
        label.font = Font.Volvo.body1
        return label
    }()

    // MARK: Lifecycle

    override init(step: Step?) {
        super.init(step: step)
        self.addActions()
    }
    
    convenience init() {
        self.init(title: Unlocalized.photographYourself)
        self.addActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        
        Analytics.trackView(screen: .profilePhoto)

        let gridView = self.view.addGridLayoutView(with: GridLayout.volvoAgent(), useSafeArea: false)

        Layout.fill(view: gridView, with: self.cameraView, useSafeArea: false)

        gridView.add(subview: self.errorLabel, from: 1, to: 6)
        self.errorLabel.topAnchor.constraint(equalTo: self.cameraView.cropLayoutGuide.bottomAnchor,
                                             constant: 20).isActive = true

        gridView.add(subview: self.shutterView, from: 1, to: 6)
        self.shutterView.pinBottomToSuperviewBottom(spacing: -30)
        
        shutterView.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cameraView.close()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cameraView.open(animated: animated)
        self.updateControls()
    }

    // MARK: Animations

    private func updateControls() {

        self.shutterView.flashButton.isSelected = self.cameraView.useFlash

        if let _ = self.error {
            self.showErrorLabel(text: Unlocalized.faceNotDetected)
        } else {
            self.hideErrorLabel()
        }
    }

    private func hideControls() {
        self.hideErrorLabel()
    }

    private func setShutterView(visible: Bool, animated: Bool = true) {
        self.shutterView.isHidden = !visible
    }


    private func showErrorLabel(text: String) {
        self.errorLabel.alpha = 0
        self.errorLabel.text = text
        UIView.animate(withDuration: 0.25) { self.errorLabel.alpha = 1 }
    }

    private func hideErrorLabel() {
        UIView.animate(withDuration: 0.25) { self.errorLabel.alpha = 0 }
    }

    // MARK: Actions

    private func addActions() {

        self.shutterView.cameraView = self.cameraView

        self.cameraView.photoWasTaken = {
            [weak self] photo, error in
            guard let me = self else { return }
            me.error = error
            me.updateControls()
            guard error == nil else { return }
            me.image = photo
            me.shutterView.incrementNumberOfPhotosTaken()
            Analytics.trackView(screen: .confirmProfilePhoto)
        }

        self.shutterView.doneButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
    }

    @objc override func nextButtonTouchUpInside() {
        
        guard let image = self.image else { return }
        AppController.shared.lookBusy()
        DriverManager.shared.set(image: image) {
            [weak self] success in
            AppController.shared.lookNotBusy()
            if success {
                if let flowDelegate = self?.flowDelegate {
                    if !flowDelegate.pushNextStep() {
                        AppController.shared.mainController(push: MyScheduleViewController(),
                                                            animated: true,
                                                            asRootViewController: true,
                                                            prefersProfileButton: true)
                    }
                } else {
                    if let navigationController = self?.navigationController {
                        navigationController.popToRootViewController(animated: true)
                    } else {
                        AppController.shared.mainController(push: MyScheduleViewController(),
                                                            animated: true,
                                                            asRootViewController: true,
                                                            prefersProfileButton: true)
                    }
                }
            } else {
                AppController.shared.alert(title: Unlocalized.photoUploadFailed.capitalized,
                                           message: Unlocalized.pleaseTryAgain)
            }
        }
    }
    
    // MARK: ShutterViewDelegate
    func resetButtonClick() {
        Analytics.trackClick(button: .retry, screen: .confirmProfilePhoto)
    }
    
    func shutterButtonClick() {
        Analytics.trackClick(button: .capturePhoto, screen: .profilePhoto)

    }
    
    func flashButtonClick(enabled: Bool) {
        Analytics.trackClick(button: enabled ? .flashOn : .flashOff, screen: .profilePhoto)
    }
}
