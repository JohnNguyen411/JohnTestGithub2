//
//  VLSlider.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class VLSlider: UISlider {
    
    private static let thumbImageWidthHeight: CGFloat = 44
    private static let arrowWidthHeight: CGFloat = 28

    private static let sliderButtonImage: UIImage! = UIImage(named: "slider_button")
    private static let sliderArrowButton: UIImage! = UIImage(named: "slider_arrow_button")

    var delegate: VLSliderProtocol?
    var step: Float = 1
    var oldValue = 0
    var newNPS: Bool

    init(newNPS: Bool) {
        self.newNPS = newNPS
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: UIControl.Event.valueChanged)
        self.minimumTrackTintColor = UIColor.luxeCobaltBlue()
        self.oldValue = Int(self.minimumValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        let roundedValue = roundedValueForFloat(floatValue: sender.value)
        sender.value = roundedValue
        self.delegate?.onValueChange(value: Int(roundedValue))
        if newNPS && roundedValue == 0 {
            self.setInitialImage()
        } else {
            self.setThumbImage(thumbImage(forValue: String(Int(roundedValue))), for: UIControl.State.normal)
        }
        self.oldValue = Int(roundedValue)
    }
    
    func setInitialImage() {
        self.setThumbImage(initialThumbImage(), for: UIControl.State.normal)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 6
        newBounds.origin.x = thumbImageWidth() / 2
        newBounds.size.width = self.bounds.width - thumbImageWidth()
        return newBounds
    }
    
    func roundedValueForFloat(floatValue: Float) -> Float{
        return round(floatValue / step) * step
    }
    
    func thumbImageWidth() -> CGFloat {
        return VLSlider.thumbImageWidthHeight
    }
    
    func thumbImageHeight() -> CGFloat {
        return VLSlider.thumbImageWidthHeight
    }
    
    private func initialThumbImage() -> UIImage? {
        
        guard let sliderButtonImage = VLSlider.sliderArrowButton else {
            return nil
        }
        
        let imageView = UIImageView(image: sliderButtonImage)
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x: 0, y: 0, width: VLSlider.thumbImageWidthHeight, height: VLSlider.thumbImageWidthHeight)
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0);
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageWithText = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return imageWithText
    }
    
    private func thumbImage(forValue: String) -> UIImage? {
        
        guard let image = VLSlider.sliderButtonImage else {
            return nil
        }
        
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x: 0, y: 0, width: VLSlider.thumbImageWidthHeight, height: VLSlider.thumbImageWidthHeight)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: VLSlider.thumbImageWidthHeight, height: VLSlider.thumbImageWidthHeight))
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.volvoSansProMedium(size: 16)
        label.text = forValue
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0);
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageWithText = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return imageWithText
    }
    
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let unadjustedThumbrect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let thumbOffsetToApplyOnEachSide: CGFloat = unadjustedThumbrect.size.width / 2.0
        let minOffsetToAdd = -thumbOffsetToApplyOnEachSide
        let maxOffsetToAdd = thumbOffsetToApplyOnEachSide
        var offsetForValue = minOffsetToAdd + (maxOffsetToAdd - minOffsetToAdd) * CGFloat(value / (self.maximumValue - self.minimumValue))
        if offsetForValue > maxOffsetToAdd {
            offsetForValue = maxOffsetToAdd
        }
        var origin = unadjustedThumbrect.origin
        origin.x += offsetForValue
        
        if origin.x + unadjustedThumbrect.size.width > self.bounds.width  {
            origin.x = rect.width
        }
        
        if origin.x < 0 {
            origin.x = 0
        }
        
        return CGRect(origin: origin, size: unadjustedThumbrect.size)
    }
    
}

protocol VLSliderProtocol {
    func onValueChange(value: Int)
}
