//
//  VLSelectableLabel.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

/**
 Use to create selectable label
 */
class VLSelectableLabel : UIView, UIGestureRecognizerDelegate {
    
    static let height = 45

    private var selected = false
    
    weak var delegate: SelectableLabelDelegate?
    private let checkmarkView: UIImageView
    private let checkmarkImage: UIImage
    
    let index: Int
    
    private let label: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansLightBold(size: 18)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        return titleLabel
    }()
    
    
    //MARK: init
    convenience init(text: String, index: Int) {
        self.init(text: text, index: index, selected: false)
    }
    
    convenience init(text: String, index: Int, selected: Bool) {
        self.init(text: text, index: index, selected: selected, checkmark: nil)
    }
    
    
    init(text: String?, index: Int, selected: Bool, checkmark: UIImage?) {
        
        if checkmark == nil {
            checkmarkImage = UIImage(named: "checkmark")!
        } else {
            checkmarkImage = checkmark!
        }
        
        checkmarkView = UIImageView(image: self.checkmarkImage)
        checkmarkView.contentMode = .scaleAspectFit
        self.index = index
        
        super.init(frame: .zero)
        
        label.text = text
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(label)
        addSubview(checkmarkView)
        
        checkmarkView.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) -> Void in
            make.left.centerY.equalToSuperview()
            make.right.equalTo(checkmarkView.snp.left).offset(-5)
        }
        
        setSelected(selected: selected, callDelegate: true)
        
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VLSelectableLabel.labelDidTap))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    
    
    //MARK: selection action
    @objc func labelDidTap() {
        setSelected(selected: !self.selected, callDelegate: true)
    }
    
    // select the view, display the checkmark and change the color of the text, call delegate if needed
    func setSelected(selected: Bool, callDelegate: Bool) {
        checkmarkView.isHidden = !selected
        
        if self.selected != selected && callDelegate && delegate != nil {
            // change
            delegate?.onSelectionChanged(selected: selected, selectedIndex: index)
            self.selected = selected
        } else {
            self.selected = selected
        }
    }
    
}

// MARK: protocol onSelectionChanged
protocol SelectableLabelDelegate: class {
    func onSelectionChanged(selected: Bool, selectedIndex: Int)
}
