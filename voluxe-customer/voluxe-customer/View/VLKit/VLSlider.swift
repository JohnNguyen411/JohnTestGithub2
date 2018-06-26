//
//  VLSlider.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class VLSlider: UISlider {
    
    private static let sliderButtonImage: UIImage! = UIImage(named: "slider_button")
    
    var step: Float = 1
    
    init() {
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: UIControlEvents.valueChanged)
        self.minimumTrackTintColor = UIColor.luxeCobaltBlue()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        let roundedValue = roundedValueForFloat(floatValue: sender.value)
        sender.value = roundedValue
        self.setThumbImage(thumbImage(forValue: String(Int(roundedValue))), for: UIControlState.normal)
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
        return VLSlider.sliderButtonImage.size.width
    }
    
    func thumbImageHeight() -> CGFloat {
        return VLSlider.sliderButtonImage.size.height
    }
    
    private func thumbImage(forValue: String) -> UIImage? {
        
        guard let image = VLSlider.sliderButtonImage else {
            return nil
        }
        
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
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
        
        return CGRect(origin: origin, size: unadjustedThumbrect.size)
    }
    
}
