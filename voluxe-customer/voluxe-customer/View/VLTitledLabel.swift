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
        titleLabel.font = .volvoSansLightBold(size: 18)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let descRightLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansLightBold(size: 18)
        titleLabel.textAlignment = .right
        return titleLabel
    }()
    
    init(title: String, leftDescription: String, rightDescription: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        descLeftLabel.text = leftDescription
        descRightLabel.text = rightDescription
        
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyConstraints() {
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(20)
        }
        
        let separator0 = UIView()
        separator0.backgroundColor = .luxeGray()
        addSubview(separator0)
        
        separator0.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.height.equalTo(1)
        }
        
        descLeftLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(separator0.snp.bottom).offset(4)
        }
        
        descRightLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(separator0.snp.bottom).offset(4)
        }
    }
    
}
