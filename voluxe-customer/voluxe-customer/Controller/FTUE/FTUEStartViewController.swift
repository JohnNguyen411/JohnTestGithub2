//
//  FTUEStartViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/31/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEStartViewController: UIViewController, FTUEProtocol {
    
    let text1: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansLight(size: 18)
        textView.text = .FTUEStartOne
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let text2: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansLight(size: 18)
        textView.text = .FTUEStartTwo
        textView.textColor = .luxeDarkGray()
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
        self.view.addSubview(text2)

        let sizeThatFits = text1.sizeThatFits(CGSize(width: view.frame.width - 30, height: CGFloat(MAXFLOAT)))
        
        text1.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(sizeThatFits)
        }
        
        text2.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(text1)
            make.top.equalTo(text1.snp.bottom).offset(15)
            make.height.equalTo(sizeThatFits)
        }
    }
    
    //MARK: FTUEStartViewController
    func didSelectPage() {}
}
