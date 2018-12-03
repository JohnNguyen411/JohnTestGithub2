//
//  UIImage+LuxeAPI.swift
//  voluxe-driver
//
//  Created by Christoph on 11/27/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    // TODO resize photo to maximum size first
    func jpegDataForPhotoUpload() -> Data? {
        return self.jpegData(compressionQuality: 0.5)
    }
}
