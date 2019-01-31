//
//  CurrentLocationCellView.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 8/7/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class CurrentLocationCellView: UIView {
    
    static let height = 60
    
    var isLocationEnabled: Bool = false {
        didSet {
            // show / hide permission note
            // update myLocationImageView image
            myLocationImageView.image = UIImage(named: isLocationEnabled ? "location-active" : "location-inactive")
            fillSubtitleLabel()
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            // show / hide checkmark
            if LocationManager.sharedInstance.isAuthorizationGranted() {
                checkmarkView.isHidden = !isChecked
            } else {
                checkmarkView.isHidden = true
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = .localized(.popupSelectLocationCurrentLocation)
        titleLabel.font = UIFont.volvoSansProMedium(size: 14)
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.addUppercasedCharacterSpacing()
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.font = .volvoSansProMedium(size: 13)
        subtitleLabel.text = .localized(.popupUpdatingLocation)
        subtitleLabel.textColor = .luxeGray()
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.volvoProLineSpacing()
        subtitleLabel.numberOfLines = 2
        return subtitleLabel
    }()
    
    private let checkmarkView = UIImageView(image: UIImage(named: "checkmark"))
    private let myLocationImageView = UIImageView(image: UIImage(named: "location-active"))
    private let delegate: CurrentLocationCellDelegate
    private var address: GMSAddress?

    init(delegate: CurrentLocationCellDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(myLocationImageView)
        self.addSubview(checkmarkView)
        
        let cellTap = UITapGestureRecognizer(target: self, action: #selector(cellClick))
        self.addGestureRecognizer(cellTap)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        checkmarkView.contentMode = .scaleAspectFit
        
        self.myLocationImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.width.height.equalTo(20)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(myLocationImageView)
            make.width.equalToSuperview()
            make.leading.equalTo(myLocationImageView.snp.trailing).offset(10)
        }
        
        let ghostCenterView = UIView(frame: .zero)
        self.addSubview(ghostCenterView)
        
        ghostCenterView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.bottom.trailing.leading.equalToSuperview()
        }
        
        self.subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ghostCenterView)
            make.leading.trailing.equalToSuperview()
        }
        self.checkmarkView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview().offset(-4)
            make.width.equalTo(12)
        }
        
    }
    
    private func fillSubtitleLabel() {
        if let address = self.address {
            subtitleLabel.text = address.shortAddress()
        } else {
            if isLocationEnabled {
                subtitleLabel.text = .localized(.popupUpdatingLocation)
            } else {
                subtitleLabel.text = .localized(.popupSelectLocationPermissionNote)
            }
        }
        subtitleLabel.volvoProLineSpacing()
    }
    
    public func setAddress(address: GMSAddress?) {
        self.address = address
        fillSubtitleLabel()
    }
    
    @objc func cellClick() {
        if LocationManager.sharedInstance.authorizationStatus() == .denied {
            delegate.deniedPermissionClick()
        } else if LocationManager.sharedInstance.authorizationStatus() == .notDetermined {
            delegate.requestPermissionLocationClick()
        } else if LocationManager.sharedInstance.isAuthorizationGranted() {
            delegate.currentLocationClick()
        }
    }
    
    
}

protocol CurrentLocationCellDelegate {
    func currentLocationClick()
    func requestPermissionLocationClick()
    func deniedPermissionClick()
}
