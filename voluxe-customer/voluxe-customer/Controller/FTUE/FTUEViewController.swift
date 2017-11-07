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
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "volvo_logo")
        return imageView
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(pressButton(button:)), for: .touchUpInside)
        button.setImage(UIImage(named: "next_button"), for: .normal)
        return button
    }()
    
    let ftueOneController = FTUEStartViewController()
    let ftueTwoController = FTUELoginViewController()
    let ftueThreeController = FTUEPhoneNumberViewController()
    let ftueFourthController = FTUEPhoneVerificationViewController()
    let ftueFifthController = FTUEAllSetViewController()

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
            make.top.equalTo(logo.snp.bottom).offset(20)
        }
        
        logo.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(35)
            make.width.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(35)
            make.width.height.equalTo(50)
        }
    }
    
    @objc func pressButton(button: UIButton) {
        if viewPager.currentPosition == numberOfItems(viewPager: viewPager) {
            appDelegate?.loadMainScreen()
        } else {
            viewPager.moveToNextPage()
        }
    }
    
    
}


extension FTUEViewController: ViewPagerDataSource {
    
    
    func numberOfItems(viewPager:ViewPager) -> Int {
        return 5
    }
    
    func viewAtIndex(viewPager:ViewPager, index: Int, view: UIView?) -> UIView {
        var newView = view;
        
        if (newView == nil) {
            if index == 0 {
                newView = ftueOneController.view
            } else if  index == 1 {
                newView = ftueTwoController.view
            } else if  index == 2 {
                newView = ftueThreeController.view
            } else if  index == 3 {
                newView = ftueFourthController.view
            } else if index == 4 {
                newView = ftueFifthController.view
            } else {
                newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  self.view.frame.height))
                newView?.backgroundColor = .blue
            }
        }
        
        return newView!
    }
    
    func controllerAtIndex(index: Int) -> FTUEProtocol {
        if index == 0 {
            return ftueOneController
        } else if  index == 1 {
            return ftueTwoController
        } else if  index == 2 {
            return ftueThreeController
        } else if  index == 3 {
            return ftueFourthController
        } else {
            return ftueFifthController
        }
    }
    
    func didChangePage(index: Int) {
        print("select index \(index)")
        let currentController = controllerAtIndex(index: index)
        currentController.didSelectPage()
    }
    
    func didSelectedItem(index: Int) {
        print("select index \(index)")
    }
    
}

protocol FTUEProtocol {
    func didSelectPage()
}
