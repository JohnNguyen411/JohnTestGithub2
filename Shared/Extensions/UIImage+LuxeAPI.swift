//
//  UIImage+LuxeAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 11/27/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit
import CoreServices

extension UIImage {

    // TODO https://app.asana.com/0/858610969087925/935159618076288/f
    // TODO does this need to be downscaled?
    func jpegDataForPhotoUpload() -> Data? {
        OSLog.info("original size: \(self.size)")
        let maxSize = 2 * 1000 * 1000 // 2MB
        guard var data = jpegData(compressionQuality: 0.7) else { return nil }
        OSLog.info("1st 0.7 bytes: \(data.count)")
        
        if data.count > maxSize {
            // need downscale
            var resizeCount: CGFloat = 0
            while data.count > maxSize {
                // downscale from 10% until under maxSize
                resizeCount += 1
                guard let resized = resized(withPercentage: 1-(resizeCount*0.1)) else { return nil}
                guard let jpegResized = resized.jpegData(compressionQuality: 0.7) else { return nil}
                OSLog.info("\(resizeCount) size: \(resized.size)")
                OSLog.info("\(resizeCount) 0.7 bytes: \(jpegResized.count)")

                data = jpegResized
            }
        }
        
        return data
    }
}


