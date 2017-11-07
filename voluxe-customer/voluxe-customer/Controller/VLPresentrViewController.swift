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
    
    static let baseHeight = 70

    let containerView = UIView(frame: .zero)

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let bottomButton = VLButton(type: .BluePrimary, title: nil, actionBlock: nil)
    
    convenience init(title: String, buttonTitle: String, actionBlock:@escaping (()->())) {
        self.init()
        
        setTitle(title: title)
        setButtonTitle(title: title, actionBlock: actionBlock)
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
    
    func setButtonTitle(title: String, actionBlock:@escaping (()->())) {
        bottomButton.setTitle(title: title)
        bottomButton.setActionBlock {
            actionBlock()
        }
    }
    
    func setupViews() {
        containerView.backgroundColor = .white
        
        self.view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bottomButton)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func height() -> Int {
        return VLPresentrViewController.baseHeight
    }
    
    
}
