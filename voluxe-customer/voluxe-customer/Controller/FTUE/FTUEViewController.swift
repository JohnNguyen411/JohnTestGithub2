//
//  FTUEViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/30/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class FTUEViewController: BaseViewController, FTUEChildProtocol {
    
    enum FTUEFlowType {
        case Login
        case Signup
    }
    
    init(flowType: FTUEFlowType) {
        self.flowType = flowType
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let flowType: FTUEFlowType
    static let nbOfItemsSignup = 4
    static let nbOfItemsLogin = 3
    
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
    
    lazy var ftueLoginController = FTUELoginViewController()
    lazy var ftueNameController = FTUESignupNameViewController()
    lazy var ftuePhoneController = FTUEPhoneNumberViewController()
    lazy var ftuePhoneVerifController = FTUEPhoneVerificationViewController()
    lazy var ftueEmailPhoneController = FTUESignupEmailPhoneViewController()
    lazy var ftuePasswordController = FTUESignupPasswordViewController()

    let viewPager = ViewPager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewPager.dataSource = self
        if flowType == .Login {
            ftueLoginController.delegate = self
        } else {
            ftueNameController.delegate = self
            ftueEmailPhoneController.delegate = self
            ftuePasswordController.delegate = self
        }
        ftuePhoneController.delegate = self
        ftuePhoneVerifController.delegate = self
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
        
        logo.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(60)
            make.width.height.equalTo(50)
        }
        
        viewPager.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(20)
        }
        
        nextButton.snp.makeConstraints { (make) -> Void in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(60)
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
    
    
    func numberOfItems(viewPager: ViewPager) -> Int {
        if flowType == .Login {
            return FTUEViewController.nbOfItemsLogin
        } else {
            return FTUEViewController.nbOfItemsSignup
        }
    }
    
    func viewAtIndex(viewPager: ViewPager, index: Int, view: UIView?) -> UIView {
        var newView = view;
        
        if (newView == nil) {
            if flowType == .Login {
                if index == 0 {
                    newView = ftueLoginController.view
                } else if index == 1 {
                    newView = ftuePhoneController.view
                } else {
                    newView = ftuePhoneVerifController.view
                }
            } else {
                if index == 0 {
                    newView = ftueNameController.view
                } else if index == 1 {
                    newView = ftueEmailPhoneController.view
                } else if index == 2 {
                    newView = ftuePhoneVerifController.view
                } else {
                    newView = ftuePasswordController.view
                }
            }
        }
        
        return newView!
    }
    
    func controllerAtIndex(index: Int) -> FTUEProtocol {
        if flowType == .Login {
            if index == 0 {
                return ftueLoginController
            } else if index == 1 {
                return ftuePhoneController
            } else {
                return ftuePhoneVerifController
            }
        } else {
            if index == 0 {
                return ftueNameController
            } else if index == 1 {
                return ftueEmailPhoneController
            } else if index == 2 {
                return ftuePhoneVerifController
            } else {
                return ftuePasswordController
            }
        }
    }
    
    func didChangePage(index: Int) {
        Logger.print("select index \(index)")
        let currentController = controllerAtIndex(index: index)
        currentController.didSelectPage()
        
    }
    
    func didSelectedItem(index: Int) {
        Logger.print("select index \(index)")
    }
    
    func canGoNext(nextEnabled: Bool) {
        nextButton.isEnabled = nextEnabled
    }
    
    func goToNext() {
        pressButton(button: nextButton)
    }
    
}

protocol FTUEProtocol {
    func didSelectPage()
}

protocol FTUEChildProtocol {
    func canGoNext(nextEnabled: Bool)
    func goToNext()
}
