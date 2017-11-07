//
//  SchedulePickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/3/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import Presentr

class SchedulePickupViewController: BaseViewController {
    
    let checkupLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .FTUEStartOne
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let scheduledServiceView = VLTitledLabel()
    let descriptionButton = VLButton(type: .BlueSecondary, title: (.ShowDescription as String).uppercased(), actionBlock: nil)
    let dealershipView = VLTitledLabel()
    let scheduledPickupView = VLTitledLabel()
    let pickupLocationView = VLTitledLabel()
    let loanerView = VLTitledLabel()
    
    let dropButton = VLButton(type: .BluePrimary, title: (.SelfDrop as String).uppercased(), actionBlock: nil)
    let pickupButton = VLButton(type: .BluePrimary, title: (.VolvoPickup as String).uppercased(), actionBlock: nil)

    // bottom modal view
    let modalPresenter: Presentr = {
        let width = ModalSize.fluid(percentage: 0.90)
        let height = ModalSize.fluid(percentage: 0.40)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 20, y: 400))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = false
        customPresenter.blurBackground = true
        customPresenter.blurStyle = UIBlurEffectStyle.light
        customPresenter.dismissOnSwipe = false
        return customPresenter
    }()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionButton.setActionBlock {
            self.showDescriptionClick()
        }
        descriptionButton.contentHorizontalAlignment = .left
        
        dropButton.setActionBlock {
            self.selfDropClick()
        }
        pickupButton.setActionBlock {
            self.volvoPickupClick()
        }
        
        fillViews()
    }
    
    override func setupViews() {
        super.setupViews()
        
        // init tap events
        dealershipView.isUserInteractionEnabled = true
        let dealershipTap = UITapGestureRecognizer(target: self, action: #selector(self.dealershipClick))
        dealershipView.addGestureRecognizer(dealershipTap)
        
        scrollView.contentMode = .scaleAspectFit
        
        let sizeThatFits = checkupLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT)))

        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(checkupLabel)
        
        contentView.addSubview(scheduledServiceView)
        contentView.addSubview(descriptionButton)
        contentView.addSubview(dealershipView)
        
        contentView.addSubview(dropButton)
        contentView.addSubview(pickupButton)
        
        contentView.addSubview(scheduledPickupView)
        contentView.addSubview(pickupLocationView)
        contentView.addSubview(loanerView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(20, 20, 20, 20))
        }
            
        contentView.snp.makeConstraints { make in
            make.left.top.width.height.equalTo(scrollView)
        }
        
        checkupLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(sizeThatFits)
        }
        
        scheduledServiceView.snp.makeConstraints { make in
            make.left.right.equalTo(checkupLabel)
            make.top.equalTo(checkupLabel.snp.bottom).offset(30)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        descriptionButton.snp.makeConstraints { make in
            make.left.right.equalTo(checkupLabel)
            make.top.equalTo(scheduledServiceView.snp.bottom)
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        dealershipView.snp.makeConstraints { make in
            make.left.right.equalTo(checkupLabel)
            make.top.equalTo(descriptionButton.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        dropButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        pickupButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
    }
    
    func fillViews() {
        scheduledServiceView.setTitle(title: .RecommendedService, leftDescription: "10,000 mile check-up", rightDescription: "$400")
        dealershipView.setTitle(title: .Dealership, leftDescription: "Marin Volvo", rightDescription: "")
    }
    
    
    //MARK: Actions methods
    func showDescriptionClick() {
        print("showDescriptionClick")
    }
    
    @objc func dealershipClick() {
        print("dealershipClick")
        let dealershipController = DealershipPickupViewController(title: .ChooseDealership, buttonTitle: .Next, actionBlock: {})
        customPresentViewController(modalPresenter, viewController: dealershipController, animated: true, completion: {
            // attached?
            /*
            dealershipController.view.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(dealershipController.height())
            }
 */
        })
    }
    
    func selfDropClick() {
        print("selfDropClick")
    }
    
    func volvoPickupClick() {
        print("volvoPickupClick")
    }
    
}
