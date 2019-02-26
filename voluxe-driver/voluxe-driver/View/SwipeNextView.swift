//
//  SwipeNextView.swift
//  voluxe-driver
//
//  Created by Christoph on 12/24/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class SwipeNextView: UIView {

    // MARK: Layout

    private let label: UILabel = {
        let label = UILabel(frame: CGRect.zero).usingAutoLayout()
        label.font = Font.Volvo.caption
        label.numberOfLines = 1
        label.textColor = UIColor.Volvo.volvoBlue
        label.textAlignment = .right
        return label
    }()
    
    var labelAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: Font.Volvo.caption]

    private let slider: UISlider = {
        let slider = UISlider(frame: CGRect.zero).usingAutoLayout()
        slider.clipsToBounds = false
        slider.isContinuous = true
        let size: CGFloat = 42
        let thumb = UIColor.circle(diameter: size, color: UIColor.Volvo.volvoBlue)
        let offset = CGPoint(x: 1, y: 0)
        let merged = thumb.draw(centered: UIImage(named: "forward_chevron"), offset: offset)
        slider.setThumbImage(merged, for: .normal)
        slider.tintColor = UIColor.Volvo.volvoBlue
        return slider
    }()

    private let feedbackGenerator = UIImpactFeedbackGenerator()

    var title: String? {
        get { return self.label.text }
        set {
            self.label.text = newValue?.uppercased()
            self.label.attributedText = NSAttributedString(string: newValue?.uppercased() ?? "", attributes: self.labelAttributes)
        }
    }

    // MARK: Lifecycle

    convenience init() {
        self.init(frame: CGRect.zero)
        self.labelAttributes[NSAttributedString.Key.kern] = 1.05
        self.backgroundColor = UIColor.Volvo.sky50
        self.addSubviews()
        self.addActions()
    }

    private func addSubviews() {

        self.addSubview(self.slider)
        self.slider.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.slider.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                             constant: 20).isActive = true
        self.slider.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                              constant: -46).isActive = true

        self.insertSubview(self.label, belowSubview: self.slider)
        self.label.leadingAnchor.constraint(equalTo: self.slider.leadingAnchor).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.slider.trailingAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.slider.topAnchor,
                                           constant: 12).isActive = true
    }

    func addBottomSafeAreaCoverView() {
        let view = UIView.forAutoLayout()
        view.backgroundColor = self.backgroundColor
        self.addSubview(view)
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    // MARK: Actions

    var nextClosure: (() -> ())?
    private var nextClosureShouldBeCalled = false

    private func addActions() {
        self.slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        self.slider.addTarget(self, action: #selector(sliderValueTouchUp), for: [.touchUpInside, .touchUpOutside])
    }

    // Tracks when the slider hits 1.0 the first time.
    @objc private func sliderValueDidChange() {
        guard self.slider.value == 1.0 else { return }
        guard self.nextClosureShouldBeCalled == false else { return }
        self.nextClosureShouldBeCalled = true
        self.feedbackGenerator.impactOccurred()
    }

    // Tracks when the slider is released, has hit 1.0 once, and still
    // is 1.0, then calls the next closure.
    @objc private func sliderValueTouchUp() {
        let value = self.slider.value
        self.slider.setValue(0, animated: true)
        guard value == 1.0 else { return }
        guard self.nextClosureShouldBeCalled else { return }
        self.nextClosureShouldBeCalled = false
        self.nextClosure?()
    }
}
