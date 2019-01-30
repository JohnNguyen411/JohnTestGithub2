//
//  UIView+Spin.swift
//  voluxe-driver
//
//  Created by Christoph on 12/3/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func startSpinning() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "spin")
    }

    func stopSpinning() {
        self.layer.removeAnimation(forKey: "spin")
    }
}
