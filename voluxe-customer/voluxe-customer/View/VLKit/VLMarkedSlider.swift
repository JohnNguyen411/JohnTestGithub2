//
//  VLMarkedSlider.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class VLMarkedSlider: UIView {
    
    let slider = VLSlider()
    var step = 1
    var min = 1
    var max = 10
    let markersContainer = UIView(frame: .zero)
    
    let minLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .volvoSansProMedium(size: 12)
        label.volvoProLineSpacing()
        label.textColor = .luxeDarkGray()
        label.backgroundColor = .clear
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .volvoSansProMedium(size: 12)
        label.volvoProLineSpacing()
        label.textColor = .luxeDarkGray()
        label.backgroundColor = .clear
        return label
    }()
    
    init(step: Int = 1, min: Int = 1, max: Int = 10, defaultValue: Int = 10) {
        super.init(frame: .zero)
        self.step = step
        self.min = min
        self.max = max
        self.slider.step = Float(step)
        self.slider.minimumValue = Float(min)
        self.slider.maximumValue = Float(max)
        self.slider.value = Float(defaultValue)
        
        self.minLabel.text = "\(min)"
        self.maxLabel.text = "\(max)"
        
        setupViews()
        
        self.slider.sliderValueChanged(sender: self.slider)
        
        // Add a gesture recognizer to the slider to allow the Tap
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.slider.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let maxLabelWidth = maxLabel.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))).width
        let minLabelWidth = minLabel.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))).width

        self.addSubview(slider)
        self.addSubview(maxLabel)
        self.addSubview(minLabel)
        self.addSubview(markersContainer)

        slider.snp.makeConstraints { make in
            make.top.leading.trailing.width.equalToSuperview()
        }
        
        minLabel.snp.makeConstraints { make in
            make.leading.equalTo(slider).offset((slider.thumbImageWidth()/2)-minLabelWidth/2)
            make.top.equalTo(slider.snp.bottom).offset(5)
        }
        
        maxLabel.snp.makeConstraints { make in
            make.trailing.equalTo(slider).offset(-(slider.thumbImageWidth()/2)+maxLabelWidth/2)
            make.top.equalTo(slider.snp.bottom).offset(5)
        }
        
        markersContainer.snp.makeConstraints { make in
            make.leading.equalTo(slider)
            make.trailing.equalTo(slider)
            make.top.equalTo(slider.snp.bottom).offset(5)
            make.height.equalTo(10)
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if markersContainer.bounds.width == 0 || markersContainer.subviews.count > 0 { return }
        let dotHeightWidth: Int = 4
        
        for i in stride(from: min, through: max, by: self.step) {
            if i == min || i == max { continue }
            
            let dotImage = UIImageView(image: UIImage(named: "sliderDot"))
            markersContainer.addSubview(dotImage)
            
            let trackRect =  self.slider.trackRect(forBounds: self.slider.bounds)
            let thumbRect = self.slider.thumbRect(forBounds: self.slider.bounds, trackRect: trackRect, value: Float(i))
            
            dotImage.snp.makeConstraints { make in
                make.centerX.equalTo((Int(thumbRect.origin.x) + Int(thumbRect.size.width) / 2 ) - dotHeightWidth / 2)
                make.width.height.equalTo(dotHeightWidth)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self)
        
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider)
        
        slider.setValue(slider.roundedValueForFloat(floatValue: Float(newValue)), animated: true)
        slider.sliderValueChanged(sender: slider) // need to force that call
    }
    
    func currentIntValue() -> Int {
        return Int(slider.roundedValueForFloat(floatValue: slider.value))
    }
    
}
