//
//  ServiceCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class ServiceCell: UITableViewCell {
    
    static let reuseId = "ServiceCell"
    
    var serviceLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        serviceLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        self.contentView.addSubview(serviceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        serviceLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func setService(service: String) {
        serviceLabel.text = service
    }
    
}
