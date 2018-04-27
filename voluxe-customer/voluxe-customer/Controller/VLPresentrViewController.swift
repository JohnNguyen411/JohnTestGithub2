//
//  VLPresentrViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/6/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class VLPresentrViewController: UIViewController {
    
    static let minHeight = 80
    let baseHeight: Int
    
    let screenName: String
    let loadingView = UIView(frame: .zero)
    let activityIndicator = UIActivityIndicatorView(frame: .zero)
    let containerView = UIView(frame: .zero)
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.textAlignment = .left
        titleLabel.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
        return titleLabel
    }()
    
    let bottomButton: VLButton
    
    init(title: String, buttonTitle: String, screenName: String) {
        self.screenName = screenName
        self.baseHeight = VLPresentrViewController.minHeight + VLPresentrViewController.safeAreaBottomHeight()
        bottomButton = VLButton(type: .bluePrimary, title: nil, kern: UILabel.uppercasedKern(), eventName: AnalyticsConstants.eventClickNext, screenName: screenName)
        super.init(nibName: nil, bundle: nil)
        setupViews()
        
        setTitle(title: title.uppercased())
        setButtonTitle(title: buttonTitle.uppercased(), eventName: AnalyticsConstants.eventClickNext)
        
        // log show event
        VLAnalytics.logEventWithName(AnalyticsConstants.eventViewModal, parameters: [AnalyticsConstants.modalName: screenName])
    }
    
    convenience init(title: String, screenName: String) {
        self.init(title: title, buttonTitle: "", screenName: screenName)
    }
    
    convenience init(screenName: String) {
        self.init(title: "", buttonTitle: "", screenName: screenName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
    }
    
    func setButtonTitle(title: String, eventName: String?) {
        bottomButton.setTitle(title: title)
        bottomButton.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
        if let eventName = eventName {
            bottomButton.setEventName(eventName)
        }
    }
    
    func setupViews() {
        
        loadingView.isHidden = true
        loadingView.alpha = 0
        
        containerView.isHidden = false
        containerView.alpha = 1
        
        bottomButton.setActionBlock {
            self.onButtonClick()
        }
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = .luxeCobaltBlue()
        
        bottomButton.accessibilityIdentifier = "bottomButton"
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(loadingView)
        self.view.addSubview(containerView)
        loadingView.addSubview(activityIndicator)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bottomButton)
        
        loadingView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(height())
        }
        
        activityIndicator.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsetsMake(20, 15, 20, 15))
            make.equalsToBottom(view: self.view, offset: -20)
            make.height.equalTo(height())
        }
        
        bottomButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.right.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
    }
    
    func height() -> Int {
        return baseHeight
    }
    
    func onButtonClick() {}
    
    func showLoading(loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        loadingView.alpha = loading ? 0 : 1
        loadingView.isHidden = !loading
        
        loadingView.animateAlpha(show: loading)
        containerView.animateAlpha(show: !loading)
    }
    
    
    private static func safeAreaBottomHeight() -> Int {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                if let window = UIApplication.shared.keyWindow {
                    return Int(window.safeAreaInsets.bottom)
                }
            }
            return 0
        #else
            return 0
        #endif
    }
}

protocol VLPresentrViewDelegate: class {
    func onSizeChanged()
}
