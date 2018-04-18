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
    
    static let baseHeight = 80
    
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
    
    let bottomButton = VLButton(type: .bluePrimary, title: nil, kern: UILabel.uppercasedKern(), actionBlock: nil)
    
    init(title: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        setupViews()
        
        setTitle(title: title.uppercased())
        setButtonTitle(title: buttonTitle.uppercased())
    }
    
    convenience init(title: String) {
        self.init(title: title, buttonTitle: "")
    }
    
    convenience init() {
        self.init(title: "", buttonTitle: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
    }
    
    func setButtonTitle(title: String) {
        bottomButton.setTitle(title: title)
        bottomButton.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
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
            make.bottom.left.right.equalToSuperview().inset(UIEdgeInsetsMake(20, 15, 20, 15))
            make.height.equalTo(height())
        }
        
        bottomButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.right.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
    }
    
    func height() -> Int {
        return VLPresentrViewController.baseHeight
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
    
}

protocol VLPresentrViewDelegate: class {
    func onSizeChanged()
}
