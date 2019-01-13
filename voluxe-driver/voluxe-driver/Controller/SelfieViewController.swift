//
//  SelfieViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/20/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class SelfieViewController: StepViewController {

    // MARK: Data

    private var image: UIImage?
    private var error: CameraView.OptionError?

    // MARK: Layout

    private let nextButton: UIButton = {
        let button = UIButton.Volvo.primary(title: Localized.looksGood)
        button.isHidden = true
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton.Volvo.secondary(title: Localized.tryAgain)
        button.isHidden = true
        return button
    }()

    private let cameraView: CameraView = {
        let view = CameraView(position: .front)
        view.cropColor = UIColor.Volvo.white.withAlphaComponent(0.4)
        view.cropTopLeft = CGPoint(x: 16, y: 36)
        view.showTakenPhoto = true
        view.requireFaceDetection = true
        view.useFlash = true
        return view
    }()

    private let shutterView = ShutterView()

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

    convenience init() {
        self.init(title: Localized.photographYourself)
        self.addActions()
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light

        let gridView = self.view.addGridLayoutView(with: GridLayout.volvoAgent(), useSafeArea: false)

        Layout.fill(view: gridView, with: self.cameraView, useSafeArea: false)

        gridView.add(subview: self.errorLabel, from: 1, to: 6)
        self.errorLabel.topAnchor.constraint(equalTo: self.cameraView.cropLayoutGuide.bottomAnchor,
                                             constant: 20).isActive = true

        gridView.add(subview: self.cancelButton, from: 1, to: 2)
        self.cancelButton.pinBottomToSuperviewBottom(spacing: -40)

        gridView.add(subview: self.nextButton, from: 3, to: 4)
        self.nextButton.pinBottomToSuperviewBottom(spacing: -40)

        gridView.addSubview(self.shutterView.usingAutoLayout())
        self.shutterView.leftAnchor.constraint(equalTo: gridView.leftAnchor, constant: 16).isActive = true
        self.shutterView.rightAnchor.constraint(equalTo: gridView.centerXAnchor, constant: 25).isActive = true
        self.shutterView.pinBottomToSuperviewBottom(spacing: -30)
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
        self.setShutterView(visible: self.image == nil)
        self.setButtons(visible: self.image != nil)
        self.shutterView.flashButton.isSelected = self.cameraView.useFlash

        if let _ = self.error {
            self.showErrorLabel(text: Localized.faceNotDetected)
        } else {
            self.hideErrorLabel()
        }
    }

    private func hideControls() {
        self.setShutterView(visible: false)
        self.setButtons(visible: false)
        self.hideErrorLabel()
    }

    private func setShutterView(visible: Bool, animated: Bool = true) {
        self.shutterView.isHidden = !visible
    }

    private func setButtons(visible: Bool, animated: Bool = true) {
        self.cancelButton.isHidden = !visible
        self.nextButton.isHidden = !visible
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

        self.cameraView.photoWasTaken = {
            [weak self] photo, error in
            self?.image = photo
            self?.error = error
            self?.updateControls()
        }

        self.shutterView.flashButton.addTarget(self, action: #selector(flashButtonTouchUpInside), for: .touchUpInside)
        self.shutterView.shutterButton.addTarget(self, action: #selector(shutterButtonTouchUpInside), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextButtonTouchUpInside), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func flashButtonTouchUpInside() {
        self.cameraView.useFlash = !self.cameraView.useFlash
        self.shutterView.flashButton.isSelected = self.cameraView.useFlash
    }

    @objc func shutterButtonTouchUpInside() {
        self.cameraView.capture()
        self.hideControls()
    }

    @objc func nextButtonTouchUpInside() {
        guard let image = self.image else { return }
        AppController.shared.lookBusy()
        DriverManager.shared.set(image: image) {
            [weak self] success in
            AppController.shared.lookNotBusy()
            if success {
                self?.navigationController?.popToRootViewController(animated: true)
            } else {
                AppController.shared.alert(title: Localized.photoUploadFailed.capitalized,
                                           message: Localized.pleaseTryAgain)
            }
        }
    }

    @objc func cancelButtonTouchUpInside() {
        self.cameraView.reset()
        self.image = nil
        self.error = nil
        self.updateControls()
    }
}
