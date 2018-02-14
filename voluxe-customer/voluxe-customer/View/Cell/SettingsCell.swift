//
//  SettingsCell.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class SettingsCell: UITableViewCell, UITextFieldDelegate {
    
    static let height: CGFloat = 50
    static let reuseIdIndicator = "SettingsCell"
    static let reuseIdToogle = "SettingsCellToogle"
    static let reuseIdLeftImg = "SettingsCellLeftImg"
    static let reuseIdEdit = "Edit"
    
    enum SettingsCellType {
        case indicator
        case uiswitch
        case button
        case leftImage
        case none
    }
    
    var delegate: SettingsCellProtocol?
    
    var editImage: UIImageView
    var leftImage: UIImageView
    var settingLabel: UILabel
    var settingTextField: UITextField
    var switchView: UISwitch?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        settingLabel = UILabel(frame: .zero)
        settingTextField = UITextField(frame: .zero)
        leftImage = UIImageView(frame: .zero)
        editImage = UIImageView(frame: .zero)
        
        editImage.contentMode = .scaleAspectFit
        leftImage.contentMode = .scaleAspectFit
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.accessoryType = .disclosureIndicator
        self.contentView.addSubview(settingLabel)
        self.contentView.addSubview(settingTextField)
        self.contentView.addSubview(leftImage)
        self.contentView.addSubview(editImage)
        setupViews()
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onEditClicked))
        singleTap.numberOfTapsRequired = 1
        editImage.isUserInteractionEnabled = true
        editImage.addGestureRecognizer(singleTap)
        
        settingTextField.isHidden = true
        settingTextField.delegate = self
        settingTextField.returnKeyType = .done
        
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
        editImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(0)
        }
        leftImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(editImage.snp.right)
            make.width.equalTo(0)
        }
        settingLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(leftImage.snp.right).offset(15)
        }
        
        settingTextField.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(leftImage.snp.right).offset(15)
        }
    }
    
    public func setText(text: String, leftImageName: String? = nil, editImageName: String? = nil) {
        settingLabel.text = text
        if let leftImageName = leftImageName {
            leftImage.image = UIImage(named: leftImageName)
            
            leftImage.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.width.equalTo(20)
            }
                
            settingLabel.snp.remakeConstraints { make in
                make.top.bottom.right.equalToSuperview()
                make.left.equalTo(leftImage.snp.right).offset(15)
            }
            
            settingTextField.snp.remakeConstraints { make in
                make.top.bottom.right.equalToSuperview()
                make.left.equalTo(leftImage.snp.right).offset(15)
            }
        }
        if let editImageName = editImageName {
            editImage.image = UIImage(named: editImageName)
        }

    }
    
    public func setChecked(checked: Bool) {
        if let switchView = switchView {
            switchView.setOn(checked, animated: true)
        }
    }
    
    
    public func setCellType(type: SettingsCellType) {
        if type == .indicator {
            self.accessoryType = .disclosureIndicator
        } else if type == .button || type == .none {
            self.accessoryType = .none
        } else if type == .leftImage {
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
    
    private func resetConstraints() {
        if editImage.image == nil {
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            if self.isEditing {
                self.editImage.alpha = 1
                self.editImage.snp.updateConstraints { make in
                    make.width.equalTo(20)
                }
                self.leftImage.snp.updateConstraints { make in
                    make.left.equalToSuperview().offset(50)
                }
            } else {
                self.editImage.alpha = 0
                self.editImage.snp.updateConstraints { make in
                    make.width.equalTo(0)
                }
                self.leftImage.snp.updateConstraints { make in
                    make.left.equalToSuperview().offset(15)
                }
            }
        })
        
    }
    
    @objc internal func onEditClicked() {
        if settingTextField.isHidden {
            settingTextField.isHidden = false
            settingLabel.isHidden = true
        }
    }
    
    @objc internal func switchChanged(switch: UISwitch) {
        // callback delegate?
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        resetConstraints()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // validate phone number
        return true
    }
    
}

protocol SettingsCellProtocol {
    func switchChanged(_ cell: UITableViewCell)
}
