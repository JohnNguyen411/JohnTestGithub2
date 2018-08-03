//
//  NotificationPermissionViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationPermissionViewController: VLPresentrViewController, PresentrDelegate {

    static var isShowing = false
    
    let notNowButton = VLButton(type: .whitePrimary, title: String.NotNow.uppercased())
    let allowButton = VLButton(type: .bluePrimary, title: String.Allow.uppercased())
    let notifDelegate: UNUserNotificationCenterDelegate
    var sizeDelegate: VLPresentrViewDelegate?
    
    let permissionText: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .NotificationPermissionBody
        textView.font = .volvoSansProRegular(size: 16)
        textView.textColor = .luxeDarkGray()
        textView.volvoProLineSpacing()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    var sizePermissionText = 0
    let appIcon = UIImageView(image: UIImage(named: "appIconNotif"))

    init(title: String, screen: AnalyticsEnums.Name.Screen, delegate: UNUserNotificationCenterDelegate) {
        self.notifDelegate = delegate
        super.init(title: title, buttonTitle: "", screen: screen)

        bottomButton.isHidden = true
        
        notNowButton.setActionBlock { [weak self] in
            self?.dismiss(animated: true)
        }
        
        allowButton.setActionBlock { [weak self] in
            self?.requestPushNotifications()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        appIcon.contentMode = .center
        
        containerView.addSubview(notNowButton)
        containerView.addSubview(allowButton)
        containerView.addSubview(permissionText)
        containerView.addSubview(appIcon)
        
        sizePermissionText = Int(permissionText.sizeThatFits(CGSize(width: self.view.frame.width - 60, height: CGFloat(MAXFLOAT))).height)

        notNowButton.snp.makeConstraints { make in
            make.bottom.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        allowButton.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        permissionText.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(notNowButton.snp.top).offset(-30)
        }
        
        appIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-9)
            make.bottom.equalTo(permissionText.snp.top).offset(-20)
            make.height.width.equalTo(70)
        }
        
        if let sizeDelegate = sizeDelegate {
            sizeDelegate.onSizeChanged()
        }
    }
    
    override func height() -> Int {
        return baseHeight + sizePermissionText + 145
    }

    func requestPushNotifications() {
        weak var weakSelf = self
        UNUserNotificationCenter.current().delegate = self.notifDelegate
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard let me = weakSelf else { return }
            Logger.print("Permission granted: \(granted)")
            Analytics.trackChangePermission(permission: .notification, granted: granted, screen: me.screen)
            if granted {
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    Logger.print("Notification settings: \(settings)")
                    guard settings.authorizationStatus == .authorized else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        me.dismiss(animated: true)
                    }
                }
            } else {
                me.dismiss(animated: true)
            }
        }
    }
}
