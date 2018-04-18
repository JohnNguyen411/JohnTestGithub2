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
    
    static let height = 50

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let descLeftLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansLightBold(size: 16)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let descRightLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansLightBold(size: 16)
        titleLabel.textAlignment = .right
        return titleLabel
    }()
    
    let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.textColor = .luxeOrange()
        errorLabel.font = .volvoSansLightBold(size: 12)
        errorLabel.textAlignment = .right
        errorLabel.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
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
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setLeftDescription(leftDescription: String) {
        descLeftLabel.text = leftDescription
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(padding/2, padding, padding/2, padding))
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(20)
        }
        
        separator.backgroundColor = .luxeGray()
        containerView.addSubview(separator)
        
        separator.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.height.equalTo(1)
        }
        
        descLeftLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(4)
        }
        
        descRightLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(4)
        }
        
        errorLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(20)
        }
        
        errorLabel.isHidden = true
    }
    
    func showError(error: String?) {
        
        separator.backgroundColor = .luxeOrange()
        titleLabel.textColor = .luxeOrange()
        descLeftLabel.textColor = .luxeOrange()
        descRightLabel.textColor = .luxeOrange()
        self.backgroundColor = .luxeLightOrange()
        
        errorLabel.text = error?.uppercased()
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
