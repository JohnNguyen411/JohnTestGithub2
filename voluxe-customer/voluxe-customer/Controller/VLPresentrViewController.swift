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

    let containerView = UIView(frame: .zero)

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let bottomButton = VLButton(type: .BluePrimary, title: nil, actionBlock: nil)
    
    convenience init(title: String, buttonTitle: String) {
        self.init()
        
        setTitle(title: title.uppercased())
        setButtonTitle(title: buttonTitle.uppercased())
    }
    
    convenience init(title: String) {
        self.init()
        
        setTitle(title: title)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setButtonTitle(title: String) {
        bottomButton.setTitle(title: title)
    }
    
    func setupViews() {
        
        bottomButton.setActionBlock {
            self.onButtonClick()
        }
        
        bottomButton.accessibilityIdentifier = "bottomButton"

        self.view.backgroundColor = .white
        
        self.view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bottomButton)

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
    
}
