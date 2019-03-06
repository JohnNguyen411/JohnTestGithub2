//
//  UIButton+Color.swift
//  voluxe-driver
//
//  Created by Christoph on 12/23/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    convenience init(color: UIColor,
                     highlightColor: UIColor? = nil,
                     disabledColor: UIColor? = nil,
                     cornerRadius: CGFloat? = nil)
    {
        self.init(type: .custom)
        self.imageView?.contentMode = .scaleAspectFill
        self.setBackgroundImage(with: color, for: .normal, cornerRadius: cornerRadius)
        if let color = highlightColor { self.setBackgroundImage(with: color, for: .highlighted, cornerRadius: cornerRadius) }
        if let color = disabledColor { self.setBackgroundImage(with: color, for: .disabled, cornerRadius: cornerRadius) }
    }

    private func setBackgroundImage(with color: UIColor, for state: UIControl.State, cornerRadius: CGFloat?) {
        var image = color.image()
        if let cornerRadius = cornerRadius { image = image.rounded(cornerRadius: cornerRadius, resizable: true) }
        self.setBackgroundImage(image, for: state)
    }
}
