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
    
    let containerView = UIView(frame: .zero)

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    convenience init(title: String) {
        self.init()
        
        setTitle(title: title)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setupViews() {
        self.view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
    
    
}
