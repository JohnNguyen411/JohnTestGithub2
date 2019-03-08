//
//  DebugFontCellView.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class DebugFontCellView: UIView {
    
    let bottomSeparator = UIView(frame: .zero)
    let title = UILabel(frame: .zero)
    let weight = UILabel(frame: .zero)
    let size = UILabel(frame: .zero)
    let tracking = UILabel(frame: .zero)
    
    init(attributedString: NSMutableAttributedString, weight: String , size: String, tracking: String) {
        super.init(frame: .zero)
        setupViews()
        fillViews(attributedString: attributedString, weight: weight, size: size, tracking: tracking)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        weight.font = UIFont.systemFont(ofSize: 12)
        size.font = UIFont.systemFont(ofSize: 12)
        tracking.font = UIFont.systemFont(ofSize: 12)
        
        bottomSeparator.backgroundColor = .luxeGray()
        
        self.addSubview(bottomSeparator)
        self.addSubview(title)
        self.addSubview(weight)
        self.addSubview(size)
        self.addSubview(tracking)
        
        bottomSeparator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tracking.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(70)
        }
        
        size.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(tracking.snp.leading).offset(-20)
            make.width.equalTo(40)
        }
        
        weight.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(size.snp.leading).offset(-20)
            make.width.equalTo(70)
        }
        
        title.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
            make.width.equalTo(90)
        }
    }
    
    func fillViews(attributedString: NSMutableAttributedString, weight: String , size: String, tracking: String) {
        self.title.attributedText = attributedString
        self.title.textAlignment = .left
        self.weight.text = weight
        self.weight.textAlignment = .left
        self.tracking.text = tracking
        self.tracking.textAlignment = .right
        self.size.text = size
        self.size.textAlignment = .right
    }
    
    func autoHeight() -> CGFloat {
        return title.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat(MAXFLOAT))).height
    }
    
}
