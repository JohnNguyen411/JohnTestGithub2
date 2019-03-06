//
//  ShutterView.swift
//  voluxe-driver
//
//  Created by Christoph on 1/4/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ShutterView: UIView {

    // MARK: Data

    var numberOfPhotosRequired: Int = 1 {
        didSet {
            self.updateControls()
        }
    }

    private var _numberOfPhotosTaken: Int = 0 {
        didSet {
            self.updateControls()
        }
    }

    var numberOfPhotosTaken: Int {
        return self._numberOfPhotosTaken
    }

    /// Allows control over when the remaining count is decremented.
    /// When true, the count is immediately updated when the shutter
    /// button is tapped.  If false, the count will only be updated
    /// if incrementNumberOfPhotosTaken() is called.
    var incrementNumberOfPhotosTakenOnShutter: Bool = false

    /// Manually update the remaining count.  This is useful if the
    /// photo taking process is slow (like when auto focus is enabled)
    /// so it allows the UI to be updated at the appropriate time when
    /// the photo finishes being captured.
    func incrementNumberOfPhotosTaken() {
        guard self.incrementNumberOfPhotosTakenOnShutter == false else { return }
        self._numberOfPhotosTaken += 1
    }

    // MARK: Associations

    /// Connects this view with a specific CameraView instance.
    /// This allows the buttons to control the camera.  Clients
    /// can opt to keep the CameraView and ShutterView instances
    /// disconnected for specialized behaviour, but this is
    /// provided as a convenience for the two common uses.
    weak var cameraView: CameraView? {
        didSet {
            self.updateControls()
        }
    }

    // MARK: Layout

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return view
    }()

    let flashButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setImage(UIImage(named: "flash"), for: .selected)
        button.setImage(UIImage(named: "flash-disabled"), for: .normal)
        button.imageView?.contentMode = .center
        return button
    }()

    let resetButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setImage(UIImage(named: "camera_reset_active"), for: .normal)
        button.imageView?.contentMode = .center
        return button
    }()

    let shutterButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setImage(UIImage(named: "shutter-button"), for: .normal)
        button.imageView?.contentMode = .center
        return button
    }()

    private let shutterImageView: UIImageView = {
        let image = UIImage(named: "shutter-ring")
        let imageView = UIImageView(image: image).usingAutoLayout()
        imageView.contentMode = .center
        return imageView
    }()

    let doneButton: UIButton = {
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setImage(UIImage(named: "camera_done_active"), for: .normal)
        button.imageView?.contentMode = .center
        return button
    }()

    private let countImageView: UIImageView = {
        let image = UIImage(named: "camera-button-background")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }()

    // Label to go inside countImageView
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.textColor = UIColor.Volvo.white
        label.font = Font.Volvo.button
        return label
    }()
    
    // MARK: Delegates
    var delegate: ShutterViewProtocol?

    // MARK: Lifecycle

    convenience init() {
        self.init(frame: CGRect.zero)
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.addSubviews()
        self.addActions()
        self.updateControls()
    }

    private func addSubviews() {

        Layout.fill(view: self, with: self.backgroundView)

        self.addSubview(self.flashButton)
        self.flashButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.flashButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.flashButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.flashButton.widthAnchor.constraint(equalTo: self.flashButton.heightAnchor).isActive = true

        self.addSubview(self.resetButton)
        self.resetButton.matchConstraints(to: self.flashButton)

        self.addSubview(self.shutterButton)
        self.shutterButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.shutterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.shutterButton.widthAnchor.constraint(equalTo: self.shutterButton.heightAnchor).isActive = true
        self.shutterButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        self.addSubview(self.shutterImageView)
        self.shutterImageView.matchConstraints(to: self.shutterButton)

        self.addSubview(self.doneButton)
        self.doneButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.doneButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.doneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.doneButton.widthAnchor.constraint(equalTo: self.doneButton.heightAnchor).isActive = true

        self.addSubview(self.countImageView)
        self.countImageView.matchConstraints(to: self.doneButton)
        Layout.fill(view: self.countImageView, with: self.countLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView.layer.cornerRadius = self.bounds.size.height / 2
    }

    // MARK: Actions

    private func addActions() {
        self.flashButton.addTarget(self, action: #selector(flashButtonTouchUpInside), for: .touchUpInside)
        self.resetButton.addTarget(self, action: #selector(resetButtonTouchUpInside), for: .touchUpInside)
        self.shutterButton.addTarget(self, action: #selector(shutterButtonTouchUpInside), for: .touchUpInside)
    }

    @objc func flashButtonTouchUpInside() {
        guard let cameraView = self.cameraView else { return }
        cameraView.useFlash = !cameraView.useFlash
        self.flashButton.isSelected = cameraView.useFlash
        if let delegate = delegate {
            delegate.flashButtonClick(enabled: self.flashButton.isSelected)
        }
    }

    @objc func resetButtonTouchUpInside() {
        if let delegate = delegate {
            delegate.resetButtonClick()
        }
        self.cameraView?.reset()
        self._numberOfPhotosTaken = 0
    }

    @objc func shutterButtonTouchUpInside() {
        if let delegate = delegate {
            delegate.shutterButtonClick()
        }
        self.cameraView?.capture()
        guard self.incrementNumberOfPhotosTakenOnShutter else { return }
        self._numberOfPhotosTaken += 1
    }

    func updateControls() {

        let remainingCount = self.numberOfPhotosRequired - self.numberOfPhotosTaken
        self.countLabel.text = "\(remainingCount)"

        self.flashButton.isSelected = self.cameraView?.useFlash ?? false

        if let mode = self.cameraView?.mode, mode == .multiple {
            self.updateControlsForCameraViewMultipleMode()
        } else {
            self.updateControlsForCameraViewSingleMode()
        }
    }

    /// Updates the buttons suitable for a camera view in single photo mode.
    /// While the camera may be in single mode, the view itself may require
    /// a number of photos which will also impact which buttons are available.
    private func updateControlsForCameraViewSingleMode() {
        let remainingCount = self.numberOfPhotosRequired - self.numberOfPhotosTaken
        self.flashButton.isHidden = remainingCount < 1
        self.resetButton.isHidden = remainingCount > 0
        self.doneButton.isHidden = self.numberOfPhotosRequired > 1 && remainingCount > 0
        self.doneButton.isEnabled = remainingCount < 1
        self.countImageView.isHidden = self.numberOfPhotosRequired <= 1 || remainingCount < 1
        self.shutterButton.isEnabled = remainingCount > 0
        self.shutterImageView.alpha = self.shutterButton.isEnabled ? 1 : 0.5
    }

    /// Updates the buttons suitable for a camera view in multiple photo mode.
    private func updateControlsForCameraViewMultipleMode() {
        let remainingCount = self.numberOfPhotosRequired - self.numberOfPhotosTaken
        self.flashButton.isHidden = false
        self.resetButton.isHidden = true
        self.doneButton.isHidden = remainingCount > 0
        self.doneButton.isEnabled = true
        self.countImageView.isHidden = remainingCount < 1
        self.shutterButton.isEnabled = true
        self.shutterImageView.alpha = 1
    }
}

protocol ShutterViewProtocol {
    func resetButtonClick()
    func shutterButtonClick()
    func flashButtonClick(enabled: Bool)

}
