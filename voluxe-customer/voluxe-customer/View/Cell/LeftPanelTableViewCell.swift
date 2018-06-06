//
//  LeftPanelTableViewCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/1/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

open class LeftPanelTableViewCell : UITableViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
        self.backgroundColor = .clear
    }
    
    open class func height() -> CGFloat {
        return 44
    }
    
    open func setData(_ data: Any?, isButton: Bool) {
        self.backgroundColor = .clear
        self.textLabel?.font = .volvoSansProMedium(size: 14)
        if isButton {
            self.textLabel?.textColor = .luxeCobaltBlue()
            self.accessoryType = .none
        } else {
            self.textLabel?.textColor = .luxeDarkGray()
            self.accessoryType = .disclosureIndicator
        }
        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }
    
}
