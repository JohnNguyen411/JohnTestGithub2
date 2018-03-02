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
    
    
    public static var signupCustomer = Customer()
    public static var pwd: String = ""
    
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
    lazy var addVehicleViewController = FTUEAddVehicleViewController()

    
    let viewPager = ViewPager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FTUEViewController.signupCustomer = Customer()
        
        viewPager.dataSource = self
        if flowType == .Login {
            ftueLoginController.delegate = self
        } else {
            ftueNameController.delegate = self
            ftueEmailPhoneController.delegate = self
            ftuePasswordController.delegate = self
        }
        
        addVehicleViewController.delegate = self
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
        var currentPos = viewPager.currentPosition - 1
        if currentPos < 0 {
            currentPos = 0
        }
        let currentController = controllerAtIndex(index: currentPos)
        if currentController.nextButtonTap() {
            
            if let customer = UserManager.sharedInstance.getCustomer(), flowType == .Login, currentPos == 0 {
                if customer.phoneNumber != nil && !customer.phoneNumberVerified {
                    viewPager.scrollToPage(index: currentPos + 2)
                    return
                }
            }
            viewPager.moveToNextPage()
        }
    }
    
}


extension FTUEViewController: ViewPagerDataSource {
    
    func numberOfItems(viewPager: ViewPager) -> Int {
        if flowType == .Login {
            if let customer = UserManager.sharedInstance.getCustomer() {
                if customer.phoneNumber == nil {
                    return FTUEViewController.nbOfItemsLogin
                } else {
                    return FTUEViewController.nbOfItemsLogin
                }
            }
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
                    newView = addVehicleViewController.view
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
                return addVehicleViewController
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
    
    func loadMainScreen() {
        appDelegate?.loadMainScreen()
    }
    
}

protocol FTUEProtocol {
    func didSelectPage()
    func nextButtonTap() -> Bool
}

protocol FTUEChildProtocol {
    func canGoNext(nextEnabled: Bool)
    func goToNext()
    func loadMainScreen()
}
