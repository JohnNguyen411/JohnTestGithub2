//
//  PermissionViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/17/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation


class PermissionViewController: BaseViewController {
    
    public enum PermissionType {
        case location
        case notification
    }
    
    private let completionBlock:(()->())

    private let permissionType: PermissionType
    private let grantPermissionButton: VLButton
    private let closeButton = UIButton(type: UIButton.ButtonType.custom)
    
    let imageView = UIImageView()
    
    let permissionText: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .permissionNotificationMessage
        textView.font = .volvoSansProRegular(size: 16)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    public static func screenNameForPermission(type: PermissionType) -> AnalyticsEnums.Name.Screen {
        switch type {
        case .location: return AnalyticsEnums.Name.Screen.requestLocation
        case .notification: return AnalyticsEnums.Name.Screen.requestNotifications
        }
    }
    
    init(permissionType: PermissionType, completion: @escaping (()->())) {
        self.permissionType = permissionType
        self.grantPermissionButton = VLButton(type: .bluePrimary, title: String.permissionGrantTitle.uppercased(), kern: UILabel.uppercasedKern())
        self.completionBlock = completion
        
        super.init(screen: PermissionViewController.screenNameForPermission(type: permissionType))

        self.grantPermissionButton.setActionBlock { [weak self] in
            self?.onGrantPermissionClicked()
        }
        
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseClicked), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overCurrentContext
    }

    override func setupViews() {
        super.setupViews()
        
        imageView.image = UIImage(named: self.permissionType == .notification ? "notif_permission" : "")
        
        self.view.addSubview(permissionText)
        self.view.addSubview(grantPermissionButton)
        self.view.addSubview(closeButton)
        self.view.addSubview(imageView)

        grantPermissionButton.snp.makeConstraints { make in
            make.equalsToBottom(view: self.view, offset: -20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        closeButton.snp.makeConstraints { make in
            make.equalsToTop(view: self.view, offset: 20)
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(50)
        }
        
        imageView.snp.makeConstraints { make in
            make.equalsToTop(view: self.view, offset: 80)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalTo(200)
        }
        
        permissionText.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
    }
    
    func onGrantPermissionClicked() {
        if permissionType == .notification {
            Analytics.trackClick(button: .requestNotifications, screen: self.screen)
            requestPushNotifications()
        } else {
            Analytics.trackClick(button: .requestLocation, screen: self.screen)
            requestLocationPermission()
        }
    }

    @objc func onCloseClicked() {
        self.dismiss(animated: true)
    }
}
