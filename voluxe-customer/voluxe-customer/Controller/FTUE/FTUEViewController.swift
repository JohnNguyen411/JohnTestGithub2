//
//  FTUEViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/30/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEViewController: BaseViewController {
    
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "volvo_logo")
        return imageView
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        button.setTitle(">", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let viewPager = ViewPager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewPager.dataSource = self
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupViews() {
        super.setupViews()
        
        viewPager.pageControl.isHidden = true
        viewPager.scrollView.isScrollEnabled = false
        
        self.view.addSubview(viewPager)
        self.view.addSubview(logo)
        self.view.addSubview(nextButton)
        
        viewPager.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(10)
        }
        
        logo.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(35)
            make.width.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(35)
            make.width.height.equalTo(50)
        }
    }
    
    @objc func pressButton(button: UIButton) {
        viewPager.scrollToPage(index: viewPager.currentPosition + 1)
    }
    
    
}


extension FTUEViewController: ViewPagerDataSource{
    func numberOfItems(viewPager:ViewPager) -> Int {
        return 5
    }
    
    func viewAtIndex(viewPager:ViewPager, index: Int, view: UIView?) -> UIView {
        var newView = view;
        if (newView == nil) {
            if index == 0 {
                let ftueOneController = FTUEStartViewController()
                newView = ftueOneController.view
            } else if  index == 1 {
                let ftueTwoController = FTUELoginViewController()
                newView = ftueTwoController.view
            } else if  index == 2 {
                let ftueThreeController = FTUEPhoneNumberViewController()
                newView = ftueThreeController.view
            } else {
                newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height))
                newView?.backgroundColor = .blue
            }
            
        }
        
        return newView!
    }
    
    func didSelectedItem(index: Int) {
        print("select index \(index)")
    }
    
}
