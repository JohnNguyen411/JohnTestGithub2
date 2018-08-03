//
//  RoundImageView.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 8/3/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/// Used for Round UIImageView with shadow
class RoundImageView: UIView {
    
    private let shadowRadius: CGFloat
    private let shadowOffset: CGSize
    private let imageSize: CGSize

    var imageLayer: CALayer!
    
    var image: UIImage? {
        didSet { refreshImage() }
    }
    
    override var intrinsicContentSize:
    CGSize {
        return imageSize
    }
    
    init(size: CGSize, shadowRadius: CGFloat, shadowOffset: CGSize) {
        self.imageSize = size
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        super.init(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshImage() {
        if let imageLayer = imageLayer, let image = image {
            imageLayer.contents = image.cgImage
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageLayer == nil {
            
            let shadowLayer = CALayer()
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), cornerRadius: imageSize.width/2).cgPath
            shadowLayer.shadowOffset = shadowOffset
            shadowLayer.shadowOpacity = 0.7
            shadowLayer.shadowRadius = shadowRadius
            layer.addSublayer(shadowLayer)
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), cornerRadius: imageSize.width/2).cgPath
            
            imageLayer = CALayer()
            imageLayer.mask = maskLayer
            imageLayer.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            //imageLayer.backgroundColor = UIColor.red.cgColor
            imageLayer.contentsGravity = kCAGravityResizeAspectFill
            layer.addSublayer(imageLayer)
        }
        
        
        refreshImage()
    }
    
    
}
