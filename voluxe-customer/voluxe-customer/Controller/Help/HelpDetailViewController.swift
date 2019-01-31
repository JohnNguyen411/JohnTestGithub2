//
//  HelpDetailViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/27/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class HelpDetailViewController: BaseViewController {
    
    let helpTitle: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansProMedium(size: 16)
        textView.backgroundColor = .clear
        textView.numberOfLines = 1
        return textView
    }()
    
    let label: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansProRegular(size: 14)
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    var canSchedule = true
    
    var helpType: HelpSection.HelpType
    var helpDetail: HelpDetail
    
    var actions: [HelpAction]?
    
    let leftButton: VLButton
    let rightButton: VLButton

    init(type: HelpSection.HelpType, helpDetail: HelpDetail, actions: [HelpAction]? = nil) {
        self.helpDetail = helpDetail
        self.helpType = type
        self.actions = actions
        
        let screenName = AnalyticsEnums.Name.Screen.helpDetail
        
        leftButton = VLButton(type: .bluePrimary, title: "", kern: UILabel.uppercasedKern(), event: .callHelp, screen: screenName)
        rightButton = VLButton(type: .bluePrimary, title: "", kern: UILabel.uppercasedKern(), event: .emailHelp, screen: screenName)
        
        super.init(screen: screenName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpTitle.text = .localized(helpDetail.title)
        label.text = .localized(helpDetail.description)
        
        self.navigationItem.title = .localized(.help)
        
        label.volvoProLineSpacing()
        label.sizeToFit()
        
        if let actions = self.actions, actions.count > 0 {
            let actionLeft = actions[0]
            leftButton.setTitle(title: actionLeft.title.uppercased())
            
            leftButton.setActionBlock { [weak self] in
                guard let weakself = self else { return }
                weakself.contact(helpAction: actionLeft)
            }
            
            if actions.count > 1 {
                let actionRight = actions[1]
                rightButton.setTitle(title: actionRight.title.uppercased())
                
                rightButton.setActionBlock { [weak self] in
                    guard let weakself = self else { return }
                    weakself.contact(helpAction: actionRight)
                }
            }
        }
       
    }
    
    private func contact(helpAction: HelpAction) {
        if helpAction.type == .call {
            call(phoneNumber: helpAction.value)
        } else if helpAction.type == .email {
            email(emailAddress: helpAction.value)
        } else if helpAction.type == .webview {
            self.pushViewController(VLWebViewController(urlAddress: helpAction.value, title: helpAction.title, showReloadButton: true), animated: true)
        }
    }
    
    private func call(phoneNumber: String) {
        let number = "telprompt:\(phoneNumber)"
        guard let url = URL(string: number) else { return }
        UIApplication.shared.open(url)
    }
    
    private func email(emailAddress: String) {
        let number = "mailto:\(emailAddress)"
        guard let url = URL(string: number) else { return }
        UIApplication.shared.open(url)
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(helpTitle)
        self.view.addSubview(label)
        self.view.addSubview(leftButton)
        self.view.addSubview(rightButton)
        
        helpTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        if let actions = self.actions {
            if actions.count > 1 {
                leftButton.snp.makeConstraints { make in
                    make.equalsToBottom(view: self.view, offset: -20)
                    make.leading.equalToSuperview().offset(20)
                    make.width.equalToSuperview().dividedBy(2).offset(-25)
                    make.height.equalTo(VLButton.primaryHeight)
                }
                
                rightButton.snp.makeConstraints { make in
                    make.equalsToBottom(view: self.view, offset: -20)
                    make.trailing.equalToSuperview().offset(-20)
                    make.width.equalToSuperview().dividedBy(2).offset(-25)
                    make.height.equalTo(VLButton.primaryHeight)
                }
            } else if actions.count == 1 {
                leftButton.snp.makeConstraints { make in
                    make.equalsToBottom(view: self.view, offset: -20)
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview().offset(-40)
                    make.height.equalTo(VLButton.primaryHeight)
                }
                rightButton.animateAlpha(show: false)
            } else {
                leftButton.animateAlpha(show: false)
                rightButton.animateAlpha(show: false)
            }
        } else {
            leftButton.animateAlpha(show: false)
            rightButton.animateAlpha(show: false)
        }
        
        
        label.snp.makeConstraints { make in
            make.trailing.leading.equalTo(helpTitle)
            make.top.equalTo(helpTitle.snp.bottom).offset(20)
        }
    }
}
