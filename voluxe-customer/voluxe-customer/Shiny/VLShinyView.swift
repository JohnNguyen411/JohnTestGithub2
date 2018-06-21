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
        Gyro.observe {
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

    override func stopUpdates() {
        super.stopUpdates()
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
        self.updateLayerMaskFrame()
    }

    // Convenience function to apply a mask (based on a CGImage)
    // to the view.  The specified mask image must be RGBA where
    // the alpha is used to determine which pixels are visible.
    func setMask(image: UIImage?) {
        if image == nil {
            self.layer.mask = nil
        } else {
            let mask = CALayer()
            mask.contents = image?.cgImage
            self.layer.mask = mask
        }
    }

    // MARK:- Animation

    var alphaForFadeIn = CGFloat(1.0)

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
}
