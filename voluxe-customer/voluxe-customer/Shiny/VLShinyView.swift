//
//  VLShinyView.swift
//  voluxe-customer
//
//  Created by Christoph on 6/11/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

/// To allow tweaking of the ShinyView algorithm for our needs,
/// it has been directly integrated into the project and this
/// class created.  Unfortunately the framework does not have
/// all the controls we need, so this is the easiest way to
/// modify it.  Ultimately this framework should be replaced by
/// our own implementation because it is not complete.
class VLShinyView: ShinyView {

    private var updating = false
    private let gyro = GyroManager()

    // TODO this IS being called, need to double check
    deinit {
        NSLog("\n\nVLShinyView.deinit\n\n")
        self.stopUpdates()
    }

    // Tweaked implementation that inverts the direction of the
    // vertical gradient so that it matches how the lights are
    // reflected in the device screen.
    //
    // This is a little more defensive about when updating can
    // occur (like a non-zero frame) and prevents multiple calls.
    override func startUpdates() {

        self.updateLayerMaskFrame()

        guard self.frame.equalTo(CGRect.zero) == false else { return }
        guard self.updating == false else { return }
        self.updating = true

        sceneView.image = GradientSnapshotter.snapshot(frame: self.bounds, colors: colors, locations: locations, scale: scale)
        self.gyro.observe {
            [weak self] roll, pitch, yaw in
            guard let `self` = self else { return }

            // TODO these calculations are based on when the device is flat
            // when the device becomes vertical the roll needs to become yaw
            if self.axis.contains(.vertical) {
                self.sceneView.cameraNode.eulerAngles.x = -Float(pitch - .pi / 2)
            }
            if self.axis.contains(.horizontal) {
                self.sceneView.cameraNode.eulerAngles.z = -Float(roll)
            }
        }
    }

    /// Completely overrides the ShinyView implementation to manage
    /// the updating flag and gyro object.
    override func stopUpdates() {
        self.gyro.stopDeviceMotionUpdates()
        self.updating = false
    }

    // MARK:- Layout

    /// Syncs the mask layer's frame to the current view bounds.
    /// Layer frames are not updated when view bounds change, so
    /// this makes it easy.  This is also called in layoutSubviews()
    /// so it may not be necessary to call directly either.
    func updateLayerMaskFrame() {
        self.layer.mask?.frame = self.layer.bounds
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.startUpdates()
    }

    // Convenience function to apply a mask (based on a CGImage)
    // to the view.  The specified mask image must be RGBA where
    // the alpha is used to determine which pixels are visible.
    func setMask(image: UIImage?) {
        if image == nil {
            self.layer.mask = nil
            self.layer.masksToBounds = true
        } else {
            let mask = CALayer()
            mask.contents = image?.cgImage
            self.layer.mask = mask
            self.layer.masksToBounds = false
        }
    }

    // MARK:- Animation

    var alphaForFadeIn = CGFloat(1)
    var delayForFadeIn = TimeInterval(3)
    var durationForFadeIn = TimeInterval(1)

    // TODO does this need arguments?
    func fadeIn() {
        UIView.animate(withDuration: 1) {
            self.alpha = self.alphaForFadeIn
        }
    }
}

// MARK:- Specific color patterns

extension VLShinyView {

    static let luxeColors: [UIColor] = [UIColor(hex6: 0x243986, alpha: 1),
                                        UIColor(hex6: 0x221f20, alpha: 1),
                                        UIColor(hex6: 0x243986, alpha: 1)]

    static let iridescentColors: [UIColor] = [.white, .red, .green, .blue,
                                              .clear,
                                              .blue, .green, .red, .white]

    static let highlightColors: [UIColor] = [.clear,
                                             .white,
                                             .clear,
                                             .white,
                                             .clear]

//    static func colors(from color)

    // TODO func to generate array of base color + highlight color
//    static func highlightColors(for color: UIColor) -> [UIColor] {
//        return [color, .white, color, .white, color]
//    }
}

// MARK:- Specific configurations

extension ShinyView {

    // basic view with useful defaults
    fileprivate static func base() -> VLShinyView {
        let view = VLShinyView(frame: CGRect.zero)
        view.alpha = 0.5
        view.axis = .all
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.scale = 3
        view.isUserInteractionEnabled = false
        return view
    }

    static func metallic() -> VLShinyView {
        let view = self.base()
        view.alpha = 0.1
        view.colors = VLShinyView.highlightColors
        return view
    }

    static func glossy(on color: UIColor) -> VLShinyView {
        let view = self.base()
        view.alpha = 1.0
        view.colors = [.red]//[color, .white, color, .white, color]
        return view
    }

    static func rainbow() -> VLShinyView {
        let view = self.base()
        view.alpha = 1.0
        view.colors = [.white, .red, .green, .blue,
                       .clear,
                       .blue, .green, .red, .white]
        return view
    }
}

// MARK:- Luxe configurations

extension VLShinyView {

    static func withLuxeColors() -> VLShinyView {
        let view = self.base()
        view.alpha = 1
        view.colors = VLShinyView.luxeColors
        return view
    }

    static func forLuxeButtons() -> VLShinyView {
        return VLShinyView.metallic()
    }
}
