//
//  VLCheckbox.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SnapKit

class VLCheckbox : UIView {
    
    let checkButton = UIButton()
    let titleLabel = UILabel()
    
    var checked = false
    
    weak var delegate: VLCheckboxDelegate?
    
    init(title: String? = nil) {
        
        super.init(frame: .zero)
        
        self.addSubview(checkButton)
        self.addSubview(titleLabel)
        
        checkButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(checkButton.snp.trailing).offset(5)
        }
        
        titleLabel.font = UIFont.volvoSansProRegular(size: 14)
        titleLabel.textColor = .luxeWhite()
        
        titleText = title
        
        checkButton.setImage(UIImage(named: "checked_circle"), for: UIControl.State.selected)
        checkButton.setImage(UIImage(named: "empty_checkbox"), for: UIControl.State.normal)
        checkButton.isUserInteractionEnabled = false
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(VLCheckbox.checkboxDidCheck))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleText: String? {
        didSet {
            self.titleLabel.text = titleText
            self.titleLabel.isHidden = titleText == nil || titleText!.isEmpty
        }
    }
    
    @objc func checkboxDidCheck() {
        checked = !checked
        checkButton.isSelected = checked
        delegate?.onCheckChanged(checked: checked)
    }
}

// MARK: protocol VLCheckboxDelegate
protocol VLCheckboxDelegate: class {
    func onCheckChanged(checked: Bool)
}
