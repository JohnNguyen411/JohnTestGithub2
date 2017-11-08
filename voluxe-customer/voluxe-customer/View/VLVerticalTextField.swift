//
//  VLVerticalTextField.swift
//  Valet
//
//  Created by Johan Giroux on 9/28/16.
//  Copyright © 2016 Luxe Valet, Inc. All rights reserved.
//

import Foundation
import UIKit

/**
 Should be created with a height of 75 in constraints of the caller. LuxeVerticalTextField.verticalHeight
 */
class VLVerticalTextField : VLTextField {

    static let verticalHeight = 75
    
    let rightLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansLightBold(size: 12)
        textView.textColor = .luxeOrange()
        textView.numberOfLines = 1
        textView.textAlignment = .right
        textView.backgroundColor = .clear
        return textView
    }()
    
    convenience init(title: String, placeholder: String) {
        self.init(title: title, placeholder: placeholder, isPhoneNumber: false)
    }
    
    // MARK: Initializers
    override init(title:String, placeholder:String, isPhoneNumber: Bool) {
        super.init(title: title, placeholder: placeholder, isPhoneNumber: isPhoneNumber)
        
        backgroundColor = .clear
        textField.placeholder = nil
        
        textField.textAlignment = .left
        titleLabel.textAlignment = .left
        textField.textColor = .luxeDarkBlue()
        titleLabel.textColor = .luxeDarkBlue()
        textField.tintColor = .luxeDarkBlue()
        textField.font = .volvoSansLight(size: 18)
        titleLabel.font = .volvoSansLightBold(size: 12)
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.font: UIFont.volvoSansLight(size: 18), NSAttributedStringKey.foregroundColor: UIColor.luxeLightGray()])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRightButtonText(rightButtonText: String) {
        rightLabel.text = rightButtonText

        if rightLabel.superview == nil {
            addSubview(rightLabel)
        }
        
        let sizeThatFits = rightLabel.sizeThatFits(CGSize(width: 150, height: 20))

        textField.snp.updateConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-sizeThatFits.width)
        }
        
        rightLabel.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview()
            make.top.equalTo(textField.snp.top)
            make.height.equalTo(20)
            make.width.equalTo(sizeThatFits.width)
        }
        
    }
    
    
    override func applyConstraints() {
        textField.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(self).offset(10)
            make.height.equalTo(25)
        }
       
        let separator0 = UIView()
        separator0.backgroundColor = .luxeDarkBlue()
        addSubview(separator0)
        
        separator0.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(1)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(separator0.snp.bottom).offset(4)
        }
    }
    
    override func applyErrorState() {
        textField.textColor = .luxeDarkBlue()
        titleLabel.textColor = .red
        backgroundColor = .blue
    }

    override func resetErrorState() {
        titleLabel.text = self.title
        titleLabel.textColor = .luxeDarkBlue()
        textField.textColor = .luxeDarkBlue()
        backgroundColor = .clear
    }

    
}
