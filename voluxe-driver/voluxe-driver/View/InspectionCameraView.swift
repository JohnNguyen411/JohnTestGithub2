//
//  InspectionCameraView.swift
//  voluxe-driver
//
//  Created by Christoph on 1/14/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

/// Composite view that combines all the components necessary
/// for an inspection photo flow.  This allows the view to be
/// used as the primary view in a view controller or as part
/// of another layout.
class InspectionCameraView: UIView {

    // MARK: Layout

    let filmstripView = FilmstripView()
    let cameraView = CameraView(mode: .multiple)
    let shutterView = ShutterView()

    private let overlayView = UIView.forAutoLayout()

    private let overlayImageView: UIImageView = {
        let view = UIImageView(image: nil).usingAutoLayout()
        view.contentMode = .center
        return view
    }()

    private let overlayLabel: UILabel = {
        let label = UILabel.forAutoLayout()
        label.font = Font.Volvo.caption
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.Volvo.white
        return label
    }()

    // MARK: Lifecycle

    convenience init() {
        self.init(frame: CGRect.zero)
        self.addSubviews()
        self.addActions()
    }

    private func addSubviews() {

        let gridView = self.addGridLayoutView(with: GridLayout.volvoAgent(), useSafeArea: false)

        Layout.fill(view: gridView, with: self.cameraView, useSafeArea: false)

        self.overlayView.addSubview(self.overlayImageView)
        self.overlayImageView.pinTopToSuperview()
        self.overlayImageView.pinLeftToSuperview()
        self.overlayImageView.pinRightToSuperview()

        self.overlayView.addSubview(self.overlayLabel)
        self.overlayLabel.pinTopToBottomOf(view: self.overlayImageView)
        self.overlayLabel.pinLeftToSuperview()
        self.overlayLabel.pinBottomToSuperview()
        self.overlayLabel.pinRightToSuperview()

        gridView.add(subview: self.overlayView, from: 1, to: 6)
        self.overlayView.centerYAnchor.constraint(equalTo: gridView.centerYAnchor,
                                                  constant: -20).isActive = true
        self.overlayView.heightAnchor.constraint(equalToConstant: 140).isActive = true

        gridView.add(subview: self.filmstripView, from: 1, to: 6)
        self.filmstripView.pinTopToSuperview(spacing: 16)

        gridView.add(subview: self.shutterView, from: 1, to: 6)
        self.shutterView.pinBottomToSuperview(spacing: -30)
    }

    // MARK: Actions

    private func addActions() {

        self.shutterView.cameraView = self.cameraView

        self.cameraView.photoWasTaken = {
            [weak self] photo, error in
            guard let photo = photo else { return }
            guard let me = self else { return }
            me.filmstripView.add(photo: photo)
            me.shutterView.incrementNumberOfPhotosTaken()
            me.photoWasTaken?(photo)
        }

        self.shutterView.shutterButton.addTarget(self, action: #selector(shutterButtonTouchUpInside), for: .touchUpInside)
    }

    @objc private func shutterButtonTouchUpInside() {
        self.hideOverlay()
    }

    // MARK: Animations

    private func hideOverlay() {
        UIView.animate(withDuration: 0.5) {
            self.overlayView.alpha = 0
        }
    }

    // MARK: Notifications

    var photoWasTaken: ((UIImage) -> ())?
}

extension InspectionCameraView {

    convenience init(for type: InspectionType) {
        self.init()
        self.update(for: type)
    }

    func update(for type: InspectionType) {
        self.showOverlay(for: type)
        switch type {
            case .document: self.shutterView.numberOfPhotosRequired = 2
            default: self.shutterView.numberOfPhotosRequired = 6
        }
    }

    private func showOverlay(for type: InspectionType) {
        switch type {
            case .document:
                self.overlayImageView.image = UIImage(named: "documents")
                self.overlayLabel.text = Localized.doNotPhotoCreditCard
            case .loaner:
                self.overlayImageView.image = UIImage(named: "car")
                self.overlayLabel.text = Localized.captureVehicle
            default:
                self.overlayImageView.image = nil
                self.overlayLabel.text = nil
        }
    }
}
