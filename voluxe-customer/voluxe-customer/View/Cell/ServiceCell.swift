//
//  ServiceCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class ServiceCell: UITableViewCell {
    
    static let height: CGFloat = 50
    static let reuseId = "ServiceCell"
    
    let serviceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.volvoSansBold(size: 16)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.accessoryType = .disclosureIndicator
        self.contentView.addSubview(serviceLabel)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        serviceLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
    }
    
    public func setService(service: String) {
        serviceLabel.text = service
    }
    
    public func setChecked(checked: Bool) {
        self.accessoryType = checked ? .checkmark : .none
    }
    
}
