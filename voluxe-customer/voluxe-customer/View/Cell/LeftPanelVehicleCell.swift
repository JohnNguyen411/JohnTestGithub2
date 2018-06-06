//
//  LeftPanelVehicleCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class LeftPanelVehicleCell: UITableViewCell, UITextFieldDelegate {
    
    class var identifier: String {
        return String(describing: self)
    }
    
    static let height: CGFloat = 44
    
    let notificationImage: UIImageView
    
    let settingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.volvoSansProMedium(size: 14)
        label.textColor = .luxeDarkGray()
        return label
    }()
    
    var switchView: UISwitch?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        notificationImage = UIImageView(image: UIImage(named: "notificationDot"))
        notificationImage.contentMode = .scaleAspectFit
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.accessoryType = .disclosureIndicator
        self.contentView.addSubview(settingLabel)
        self.contentView.addSubview(notificationImage)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    private func setupViews() {
       
        notificationImage.isHidden = true
        
        notificationImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(8)
        }
        settingLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
    }
    
    public func setText(text: String) {
        settingLabel.text = text
    }
    
    public func showNotification(notificationType: NotificationType?) {
        if let notificationType = notificationType {
            notificationImage.animateAlpha(show: true)
            settingLabel.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(35)
            }
            notificationImage.image = UIImage(named: notificationType == .active ? "notificationDot" : "notificationDotGrey")
        } else {
            notificationImage.animateAlpha(show: false)
            settingLabel.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(15)
            }
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
}

enum NotificationType {
    case active
    case inactive
}

