//
//  CheckmarkCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class CheckmarkCell: UITableViewCell {
    
    static let height: CGFloat = 50
    static let reuseId = "CheckmarkCell"
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.volvoSansBold(size: 16)
        label.textColor = .luxeDarkGray()
        return label
    }()
    
    let separator: UIView = {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .luxeLightestGray()
        return separator
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.accessoryType = .disclosureIndicator
        self.tintColor = .luxeCobaltBlue()
        self.contentView.addSubview(titleLabel)
        self.addSubview(separator)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(2)
            make.bottom.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(titleLabel)
            make.height.equalTo(1)
        }
    }
    
    public func setTitle(title: String) {
        titleLabel.text = title
    }
    
    public func setChecked(checked: Bool) {
        self.accessoryType = checked ? .checkmark : .none
    }
    
}
