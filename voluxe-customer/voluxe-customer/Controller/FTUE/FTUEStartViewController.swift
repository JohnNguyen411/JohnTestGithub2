//
//  FTUEStartViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEStartViewController: UIViewController {

    let text1: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = Fonts.FONT_B2
        textView.text = .FTUEStartOne
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    let text2: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = Fonts.FONT_B2
        textView.text = .FTUEStartTwo
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(text1)
        self.view.addSubview(text2)

        let sizeThatFits = text1.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat(MAXFLOAT)))
        
        text1.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(sizeThatFits)
        }
        
        text2.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(text1)
            make.top.equalTo(text1.snp.bottom)
            make.height.equalTo(sizeThatFits)
        }
    }
}
