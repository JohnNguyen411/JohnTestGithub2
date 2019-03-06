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
        return self.jpegData(compressionQuality: 0.5)
    }
}


