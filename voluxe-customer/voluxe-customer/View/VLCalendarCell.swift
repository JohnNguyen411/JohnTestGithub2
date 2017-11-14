//
//  VLCalendarCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/9/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
class VLCalendarCell: FSCalendarCell {
    
   
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        isEnabled = true
        super.init(frame: frame)
    }
    
    var isEnabled: Bool {
        didSet {
            setNeedsLayout()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureAppearance()
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
    override var colorForCellBorder: UIColor! {
        if !self.isEnabled {
            return UIColor.luxeLightGray()
        }
        return super.colorForCellBorder
    }
    
    override var colorForTitleLabel: UIColor! {
        if !self.isEnabled {
            return UIColor.luxeLightGray()
        }
        return super.colorForTitleLabel
    }
    
}
