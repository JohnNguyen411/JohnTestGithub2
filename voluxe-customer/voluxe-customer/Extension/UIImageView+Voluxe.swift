//
//  UIImageView+Voluxe.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    
    static func makeRoundImageView(frame: CGRect, photoUrl: URL?, defaultImage: UIImage!) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        
        if let photoUrl = photoUrl {
            imageView.sd_setImage(with: photoUrl)
        } else {
            imageView.image = defaultImage
        }
        
        imageView.layer.cornerRadius = frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.0
        imageView.layer.borderColor = UIColor.white.cgColor
        
        return imageView
    }
    
    func applyCropImage(image: UIImage, scale: CGFloat) {
        let cropRect = CGRect(x: ((image.size.width - (image.size.width * scale)) / 2), y: 0, width: image.size.width * scale, height: image.size.height * scale)
        if let cgimage = image.cgImage {
            guard let imageRef = cgimage.cropping(to: cropRect) else { return }
            // or use the UIImage wherever you like
            self.image = UIImage(cgImage: imageRef)
        }
    }
    
}
