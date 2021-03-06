//
//  VLTitledLabel.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/3/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/**
 Should be created with a height of 50 in constraints of the caller. VLTitledLabel.height
 */
class VLTitledLabel: UIView {
    
    static let height = 60

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.font = .volvoSansProMedium(size: 12)
        titleLabel.volvoProLineSpacing()
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let descLeftLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansProMedium(size: 15)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        return titleLabel
    }()
    
    let descRightLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansProMedium(size: 15)
        titleLabel.volvoProLineSpacing()
        titleLabel.textAlignment = .right
        return titleLabel
    }()
    
    let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .luxeRed()
        errorLabel.font = .volvoSansProMedium(size: 12)
        errorLabel.textAlignment = .right
        errorLabel.addUppercasedCharacterSpacing()
        return errorLabel
    }()
    
    let separator = UIView()
    let containerView = UIView(frame: .zero)
    let padding: CGFloat
    
    var isEditable = false {
        didSet {
            if isEditable {
                descLeftLabel.textColor = .luxeCobaltBlue()
            } else {
                descLeftLabel.textColor = .luxeDarkGray()
            }
        }
    }
    
     init(padding: CGFloat = 0) {
        self.padding = padding
        super.init(frame: .zero)
        
        self.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descLeftLabel)
        containerView.addSubview(descRightLabel)
        containerView.addSubview(errorLabel)
        applyConstraints()
    }
    
    convenience init(title: String, leftDescription: String, rightDescription: String, padding: CGFloat = 0) {
        self.init(padding: padding)
        
        setTitle(title: title, leftDescription: leftDescription, rightDescription: rightDescription)
    }
    
    func setTitle(title: String, leftDescription: String, rightDescription: String? = nil) {
        titleLabel.text = title
        descLeftLabel.text = leftDescription
        if let rightDescription = rightDescription {
            descRightLabel.text = rightDescription
            descRightLabel.volvoProLineSpacing()
        }
        titleLabel.volvoProLineSpacing()
        descLeftLabel.sizeToFit()
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.volvoProLineSpacing()
    }
    
    func setLeftDescription(leftDescription: String) {
        descLeftLabel.text = leftDescription
        descLeftLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self, edges: UIEdgeInsets(top: padding/2, left: padding, bottom: padding/2, right: padding))
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(20)
        }
        
        separator.backgroundColor = .luxeGray()
        containerView.addSubview(separator)
        
        separator.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.height.equalTo(1)
        }
        
        descLeftLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.width.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(10)
        }
        
        descRightLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(10)
        }
        
        errorLabel.snp.makeConstraints { (make) -> Void in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(20)
        }
        
        errorLabel.isHidden = true
    }
    
    func showError(error: String?) {
        
        separator.backgroundColor = .luxeRed()
        titleLabel.textColor = .luxeRed()
        descLeftLabel.textColor = .luxeRed()
        descRightLabel.textColor = .luxeRed()
        self.backgroundColor = .luxeLightOrange()
        
        errorLabel.text = error?.uppercased()
        errorLabel.volvoProLineSpacing()
        if errorLabel.isHidden {
            errorLabel.animateAlpha(show: true)
        }
    }
    
    func hideError() {
        titleLabel.textColor = .luxeGray()
        separator.backgroundColor = .luxeGray()
        descLeftLabel.textColor = isEditable ? .luxeCobaltBlue() :  .luxeDarkGray()
        descRightLabel.textColor = .luxeDarkGray()
        self.backgroundColor = .clear

        if !errorLabel.isHidden {
            errorLabel.animateAlpha(show: false)
        }
    }
    
}
