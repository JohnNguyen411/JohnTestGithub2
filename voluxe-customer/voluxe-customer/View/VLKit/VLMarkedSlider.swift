//
//  VLMarkedSlider.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class VLMarkedSlider: UIView, VLSliderProtocol {
    
    let dotHeightWidth: Int = 4

    let slider = VLSlider(newNPS: RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.customerNewNpsViewEnabled))
    var step = 1
    var min = 1
    var disabledValue = 0
    var max = 10
    let markersContainer = UIView(frame: .zero)
    
    let newNPS = RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.customerNewNpsViewEnabled)
    var hasBeenRelayout = false
    var delegate: VLMarkedSliderProtocol?
    
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
    
    init(step: Int = 1, disabledValue: Int = 0, min: Int = 1, max: Int = 10, defaultValue: Int = 10) {
        super.init(frame: .zero)
        self.slider.delegate = self
        self.step = step
        self.min = min
        self.max = max
        self.slider.step = Float(step)
        self.disabledValue = disabledValue
        if newNPS {
            self.slider.minimumValue = Float(disabledValue)
        } else {
            self.slider.minimumValue = Float(min)
        }
        self.slider.maximumValue = Float(max)
        self.slider.value = Float(newNPS ? disabledValue : defaultValue)
        
        self.minLabel.text = "\(min)"
        self.maxLabel.text = "\(max)"
        
        setupViews()
        
        if newNPS {
            self.slider.setInitialImage()
        } else {
            self.slider.sliderValueChanged(sender: self.slider)
        }
        
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
            make.top.leading.trailing.equalToSuperview()
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
        let trackRect =  self.slider.trackRect(forBounds: self.slider.bounds)
        
        let minStride = self.min
        
        for i in stride(from: minStride, through: max, by: self.step) {
            if i == minStride || i == max { continue }
            
            let dotImage = UIImageView(image: UIImage(named: "sliderDot"))
            markersContainer.addSubview(dotImage)
            
            let thumbRect = self.slider.thumbRect(forBounds: self.slider.bounds, trackRect: trackRect, value: Float(i))
            dotImage.tag = i
            
            dotImage.snp.makeConstraints { make in
                make.centerX.equalTo((Int(thumbRect.origin.x) + Int(thumbRect.size.width) / 2 ) - dotHeightWidth / 2)
                make.width.height.equalTo(dotHeightWidth)
                make.centerY.equalToSuperview()
            }
            
        }
        if newNPS && !hasBeenRelayout {

            let thumbRect = self.slider.thumbRect(forBounds: self.slider.bounds, trackRect: trackRect, value: Float(self.min))
            self.minLabel.snp.remakeConstraints { make in
                make.centerX.equalTo((Int(thumbRect.origin.x) + Int(thumbRect.size.width) / 2 ) - dotHeightWidth / 2)
                make.top.equalTo(slider.snp.bottom).offset(5)
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
    
    // MARK: VLSliderProtocol
    
    func onValueChange(value: Int) {
        if newNPS && value != self.disabledValue && !hasBeenRelayout {
            let minLabelWidth = minLabel.sizeThatFits(CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))).width
            hasBeenRelayout = true
            self.disabledValue = min

            self.slider.minimumValue = Float(self.min)
            let trackRect =  self.slider.trackRect(forBounds: self.slider.bounds)

            UIView.animate(withDuration: 0.3, animations: {
                
                for view in self.markersContainer.subviews {
                    
                    let thumbRect = self.slider.thumbRect(forBounds: self.slider.bounds, trackRect: trackRect, value: Float(view.tag))
                    
                    view.snp.remakeConstraints { make in
                        make.centerX.equalTo((Int(thumbRect.origin.x) + Int(thumbRect.size.width) / 2 ) - self.dotHeightWidth / 2)
                        make.width.height.equalTo(self.dotHeightWidth)
                        make.centerY.equalToSuperview()
                    }
                }
                
                
                self.minLabel.snp.remakeConstraints { make in
                    make.leading.equalTo(self.slider).offset((self.slider.thumbImageWidth()/2)-minLabelWidth/2)
                    make.top.equalTo(self.slider.snp.bottom).offset(5)
                }
                
                self.layoutIfNeeded()
               
            })
        }
        delegate?.onValueChanged(value: value)
    }
}

protocol VLMarkedSliderProtocol {
    func onValueChanged(value: Int)
}
