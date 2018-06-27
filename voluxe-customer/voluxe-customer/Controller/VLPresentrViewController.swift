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

    // TODO this is temporary until String screenName can be removed
    let screenNameEnum: AnalyticsEnums.Name.Screen?
    let _screenName: String?
    var screenName: String {
        return self._screenName ?? self.screenNameEnum?.rawValue ?? "no screen name"
    }

    let loadingView = UIView(frame: .zero)
    let activityIndicator = UIActivityIndicatorView(frame: .zero)
    let containerView = UIView(frame: .zero)
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = .volvoSansProMedium(size: 12)
        titleLabel.textAlignment = .left
        titleLabel.addUppercasedCharacterSpacing()
        return titleLabel
    }()
    
    let headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.luxeCharcoalGrey()
        headerView.clipsToBounds = true
        return headerView
    }()
    
    let bottomButton: VLButton

    init(title: String, buttonTitle: String, screenNameEnum: AnalyticsEnums.Name.Screen) {
        self.screenNameEnum = screenNameEnum
        self._screenName = nil
        self.baseHeight = VLPresentrViewController.minHeight + VLPresentrViewController.safeAreaBottomHeight()
        bottomButton = VLButton(type: .bluePrimary, title: nil, kern: UILabel.uppercasedKern(), eventName: AnalyticsConstants.eventClickNext, screenName: screenNameEnum.rawValue)
        super.init(nibName: nil, bundle: nil)
        setupViews()

        setTitle(title: title.uppercased())
        setButtonTitle(title: buttonTitle.uppercased(), eventName: AnalyticsConstants.eventClickNext)
        Analytics.trackView(screen: screenNameEnum)
    }

    // TODO temporary until String screenName is removed
    init(title: String, buttonTitle: String, screenName: String) {
        self.screenNameEnum = nil
        self._screenName = screenName
        self.baseHeight = VLPresentrViewController.minHeight + VLPresentrViewController.safeAreaBottomHeight()
        bottomButton = VLButton(type: .bluePrimary, title: nil, kern: UILabel.uppercasedKern(), eventName: AnalyticsConstants.eventClickNext, screenName: screenName)
        super.init(nibName: nil, bundle: nil)
        setupViews()
        
        setTitle(title: title.uppercased())
        setButtonTitle(title: buttonTitle.uppercased(), eventName: AnalyticsConstants.eventClickNext)
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

    // Asks the app controller to blur.  Note that doing this
    // here means that ALL VLPresenteViewController uses will
    // cause blurring, and that is desired behaviour right now.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VLSlideMenuController.shared?.blur()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        VLSlideMenuController.shared?.unblur()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.roundCorners([.topLeft, .topRight], radius: 5.0)
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalTo(headerView).offset(2)
            make.height.equalTo(25)
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.addUppercasedCharacterSpacing()
    }
    
    func setButtonTitle(title: String, eventName: String?) {
        bottomButton.setTitle(title: title)
        bottomButton.addUppercasedCharacterSpacing()
        if let eventName = eventName {
            bottomButton.setEventName(eventName)
        }
    }
    
    func setupViews() {
        
        loadingView.isHidden = true
        loadingView.alpha = 0
        
        containerView.isHidden = false
        containerView.alpha = 1
        
        headerView.isHidden = false
        headerView.alpha = 1
        
        bottomButton.setActionBlock { [weak self] in
            self?.onButtonClick()
        }
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = .luxeCobaltBlue()
        
        bottomButton.accessibilityIdentifier = "bottomButton"
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(headerView)
        self.view.addSubview(loadingView)
        self.view.addSubview(containerView)
        loadingView.addSubview(activityIndicator)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bottomButton)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
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
        headerView.animateAlpha(show: !loading)
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
    func closePresenter()
}
