//
//  Label.swift
//  voluxe-customer
//
//  Created by Christoph on 9/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

struct Label {

    static func dark(with text: String? = nil) -> UILabel {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .darkGray
        label.text = text
        return label
    }
    
    static func taskTitle(with text: String? = nil) -> UILabel {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .darkGray
        label.text = text
        label.font = Font.Medium.regular
        return label
    }
    
    static func taskText(with text: String? = nil) -> UILabel {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .darkGray
        label.text = text
        label.numberOfLines = 0
        label.font = Font.Intermediate.regular
        return label
    }
    
    static func taskTitleNumber(with text: String? = nil) -> UILabel {
        let label = UILabel(frame: .zero)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.text = text
        label.font = Font.Medium.regular
        label.backgroundColor = UIColor.Volvo.success
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12.5
        return label
    }
    
    static func taskNextNumber(with text: String? = nil) -> UILabel {
        let label = taskTitleNumber(with: text)
        label.backgroundColor = UIColor.Volvo.slate
        return label
    }
}

extension UILabel {

    convenience init(text: String) {
        self.init()
        self.text = text
    }
}
