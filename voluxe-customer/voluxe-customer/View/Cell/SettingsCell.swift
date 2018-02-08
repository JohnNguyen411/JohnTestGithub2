//
//  SettingsCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class SettingsCell: UITableViewCell {
    
    static let height: CGFloat = 50
    static let reuseIdIndicator = "SettingsCell"
    static let reuseIdToogle = "SettingsCellToogle"
    
    enum SettingsCellType {
        case indicator
        case uiswitch
        case button
    }
    
    var delegate: SettingsCellProtocol?
    
    var settingLabel: UILabel
    var switchView: UISwitch?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        settingLabel = UILabel(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.accessoryType = .disclosureIndicator
        self.contentView.addSubview(settingLabel)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyTextStyle(type: SettingsCellType) {
        if type == .button {
            settingLabel.textColor = .luxeDarkBlue()
        } else {
            settingLabel.textColor = .black
        }
        
    }
    
    private func setupViews() {
        settingLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
    }
    
    public func setText(text: String) {
        settingLabel.text = text
    }
    
    public func setChecked(checked: Bool) {
        if let switchView = switchView {
            switchView.setOn(checked, animated: true)
        }
    }
    
    
    public func setCellType(type: SettingsCellType) {
        if type == .indicator {
            self.accessoryType = .disclosureIndicator
        } else if type == .button {
            self.accessoryType = .none
        } else {
            self.accessoryType = .checkmark
            switchView = UISwitch(frame: .zero)
            self.accessoryView = switchView
            switchView?.setOn(true, animated: true)
            switchView?.addTarget(self, action: #selector(switchChanged(switch:)), for: .valueChanged)
        }
        applyTextStyle(type: type)
    }
    
    @objc internal func switchChanged(switch: UISwitch) {
        // callback delegate?
        
    }
    
}

protocol SettingsCellProtocol {
    func switchChanged(_ cell: UITableViewCell)
}
