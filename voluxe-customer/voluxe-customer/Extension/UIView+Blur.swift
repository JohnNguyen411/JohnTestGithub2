//
//  UIView+Blur.swift
//  voluxe-customer
//
//  Created by Christoph on 6/7/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

/// Convenience extension to enable blur support for any UIView.
extension UIView {

    // MARK:- Associated object support

    fileprivate struct AssociatedKeys {
        static var BlurEffectKey = "BlurEffectKey"
    }

    fileprivate var blurEffect: BlurEffect? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.BlurEffectKey) as? BlurEffect
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.BlurEffectKey,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// Convenience method to insert a view below the currently
    /// visible blur.  If no blur is present, the view is added
    /// to the top of the view stack.
    func addSubviewBelowBlurredView(subview: UIView) {
        if let effect = self.blurEffect, effect.isBlurred {
            self.insertSubview(subview, belowSubview: effect.view)
        } else {
            self.addSubview(subview)
        }
    }

    /// Blurs the current view stack, but is not a stacking effect.
    /// Subsequent calls will not do anything until unblur() is called.
    /// To immediately blur, use a duration = 0.
    func blur(style: UIBlurEffect.Style, tint: UIColor, duration: TimeInterval) {
        guard self.blurEffect == nil else { return }
        let effect = BlurEffect(style: .light, tint: UIColor.luxeBlurTint)
        effect.blur(superview: self, duration: duration)
        self.blurEffect = effect
    }

    /// Removes the blur effect from the current view stack.  Subsequent
    /// calls will not do anything until the initial call finishes the
    /// specified duration.  To immediately remove, use a duration = 0.
    func unblur(duration: TimeInterval) {
        guard let effect = self.blurEffect else { return }
        effect.unblur(duration: duration) {
            [unowned self] in
            self.blurEffect = nil
        }
    }
}

/// Luxe specific blur including style, tint and duration.
extension UIView {

    func blurByLuxe(duration: TimeInterval = 0.25) {
        self.blur(style: .light, tint: UIColor.luxeBlurTint, duration: duration)
    }

    func unblurByLuxe(duration: TimeInterval = 0.25) {
        self.unblur(duration: duration)
    }
}
