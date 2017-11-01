//
//  FTUEAllSetViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/1/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEAllSetViewController: UIViewController, FTUEProtocol {
    
    let text1: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = Fonts.FONT_B2
        textView.text = .WelcomeToAppLabel
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(text1)
        
        let sizeThatFits = text1.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat(MAXFLOAT)))
        
        text1.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(sizeThatFits)
        }
        
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {
        
    }
}
