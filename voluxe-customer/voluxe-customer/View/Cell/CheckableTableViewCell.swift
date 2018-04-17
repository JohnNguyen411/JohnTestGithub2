//
//  CheckableTableViewCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class CheckableTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 50
    static let reuseId = "CheckableTableViewCell"
    
    var checkView: UIImageView
    
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.volvoSansBold(size: 16)
        label.textColor = .luxeDarkGray()
        return label
    }()
    
    let separator: UIView = {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .luxeLightGray()
        return separator
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        checkView = UIImageView(image: UIImage(named: "checkmark"))
        checkView.contentMode = .scaleAspectFit
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.accessoryType = .none
        self.addSubview(checkView)
        self.addSubview(label)
        self.addSubview(separator)
        
        self.checkView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        self.label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.checkView.snp.right).offset(20)
        }
        
        separator.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.left.equalTo(checkView)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        checkView = UIImageView(image: UIImage(named: "checkmark"))
        super.init(coder: aDecoder)
    }
    
    
    func setText(text: String, selected: Bool) {
        self.label.text = text
        checkView.image = selected ? UIImage(named: "checkmark") : nil
    }
}
