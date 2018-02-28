//
//  FTUEAllSetViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/1/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEAllSetViewController: FTUEChildViewController, FTUEProtocol {
    
    let allSetLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .WelcomeToAppLabel
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allSetLabel.accessibilityIdentifier = "allSetLabel"
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(allSetLabel)
        
        let sizeThatFits = allSetLabel.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat(MAXFLOAT)))
        
        allSetLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(sizeThatFits)
        }
        
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        
    }
    
    func nextButtonTap() -> Bool {
        return true
    }
}
