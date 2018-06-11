//
//  BlurEffect.swift
//  voluxe-customer
//
//  Created by Christoph on 6/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

/// Composite class that owns a VLBlurEffectView and a tinting UIView.
/// The effect can be created and retained while in use, adding the
/// view to the top of whatever view stack needs to be blurred.
class BlurEffect {

    // Indicates if the effect is in use, which is a combination
    // of whether the container view has a superview and the
    // blur view blur state.
    var isBlurred: Bool {
        return self.containerView.superview != nil && self.blurView.isBlurred
    }

    // Container view to hold the blur and tint views
    // with a public read-only accessor.
    private let containerView = UIView()
    var view: UIView {
        return self.containerView
    }

    private let blurView: VLBlurEffectView

    // need to use a separate tint view because compositing
    // a blur and opacity animation doesn't work on iOS 10
    private let tintView: UIView = {
        let view = UIView()
        view.alpha = 0
        return view
    }()

    // MARK:- Init

    init(style: UIBlurEffectStyle, tint: UIColor?) {
        self.blurView = VLBlurEffectView(style: style)
        self.tintView.backgroundColor = tint
        self.layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Layout

    private func layoutSubviews() {

        self.containerView.addSubview(self.blurView)
        self.blurView.snp.makeConstraints {
            make in
            make.size.equalToSuperview()
        }

        self.containerView.addSubview(self.tintView)
        self.tintView.snp.makeConstraints {
            make in
            make.size.equalToSuperview()
        }
    }

    private func addContainerView(to superview: UIView) {
        self.containerView.snp.removeConstraints()
        superview.addSubview(self.containerView)
        self.containerView.snp.makeConstraints {
            make in
            make.size.equalToSuperview()
        }
    }

    // MARK:- Blur support

    /// Adds the container view to the superview, then animates the
    /// blur view and fades in the tint view.
    func blur(superview: UIView, duration: TimeInterval, completion: (() -> ())? = nil) {
        self.addContainerView(to: superview)
        self.blurView.blurTo(amount: 0.15, duration: duration)
        UIView.animate(withDuration: duration,
                       animations: { self.tintView.alpha = 1 },
                       completion:
            {
                finished in
                completion?()
        })
    }

    /// Animates the blur view and fades out the tint view, then
    /// removes the container view from its superview.
    func unblur(duration: TimeInterval, completion: (() -> ())? = nil) {
        self.blurView.unblurFrom(duration: duration)
        UIView.animate(withDuration: duration,
                       animations: { self.tintView.alpha = 0 },
                       completion:
            {
                finished in
                self.containerView.removeFromSuperview()
                completion?()
        })
    }
}

/// Utility class that adds a CADisplayLink to allow animating
/// the UIBlurEffect.  Strangely, there is no way to control this
/// in a UIVisualEffectView or UIViewPropertyAnimator so this
/// class is needed.  Presumably it will be added to the API later,
/// so this class can be dropped.
///
/// The downside with using the display link is that it is linear,
/// meaning if this animation is paired with another "ease in, ease out"
/// animation, they will start/stop together but their motion will
/// be mildly out of sync.
///
/// Based on vegather/BlurryOverlayView.swift
/// https://gist.github.com/vegather/07993d15c83ffcd5182c8c27f1aa600b
class VLBlurEffectView: UIVisualEffectView {

    // 60Hz is the default for most iOS devices, but may
    // change over time or not even be true for the newer
    // iPad Pro.
    private static let fps = CGFloat(60)

    private var style: UIBlurEffectStyle
    private var animator: UIViewPropertyAnimator!
    private var displayLink: CADisplayLink!
    private var delta: CGFloat = 0
    private var target: CGFloat = 0
    private(set) var isBlurred = false

    init(style: UIBlurEffectStyle) {
        self.style = style
        super.init(effect: nil)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {

        // hides the effect until blur starts
        self.isHidden = true

        // animator has to be created here, not earlier
        self.animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
            self.effect = UIBlurEffect(style: self.style)
        }

        // this is supposedly required to fix a backgrounding bug
        if #available(iOS 11.0, *) {
            self.animator.pausesOnCompletion = true
        }

        // Using a display link to animate animator.fractionComplete
        self.displayLink = CADisplayLink(target: self, selector: #selector(tick))
        self.displayLink.isPaused = true
        self.displayLink.add(to: .main, forMode: .commonModes)
    }

    func blurTo(amount: CGFloat, duration: TimeInterval) {
        guard self.isBlurred == false else { return }
        self.isHidden = false
        self.target = amount
        self.delta = amount / (VLBlurEffectView.fps * CGFloat(duration))
        self.displayLink.isPaused = false
    }

    func unblurFrom(duration: TimeInterval) {
        guard self.isBlurred else { return }
        self.target = 0
        self.delta = -1 * animator.fractionComplete / (VLBlurEffectView.fps * CGFloat(duration))
        self.displayLink.isPaused = false
    }

    @objc private func tick() {
        self.animator.fractionComplete += delta

        // unblur complete
        if self.isBlurred && self.animator.fractionComplete <= 0 {
            self.isBlurred = false
            self.isHidden = true
            self.displayLink.isPaused = true
        }

        // blur in complete
        else if self.isBlurred == false && self.animator.fractionComplete >= target {
            self.isBlurred = true
            self.displayLink.isPaused = true
        }
    }
}
