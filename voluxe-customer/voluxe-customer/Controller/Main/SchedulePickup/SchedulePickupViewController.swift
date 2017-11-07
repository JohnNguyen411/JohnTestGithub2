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
    
    let presentrCornerRadius: CGFloat = 4.0
    
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
    
    func buildPresenter(heightInPixels: CGFloat) -> Presentr {
        // bottom modal view
        let widthPerc = 0.9
        let width = ModalSize.fluid(percentage: Float(widthPerc))
        
        let viewH = self.view.frame.height + MainViewController.getNavigationBarHeight() + statusBarHeight() + presentrCornerRadius
        let viewW = Double(self.view.frame.width)

        let percH = heightInPixels / viewH
        let leftRightMargin = (viewW - (viewW * widthPerc))/2
        let height = ModalSize.fluid(percentage: Float(percH))

        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: leftRightMargin, y: Double(viewH - heightInPixels)))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVerticalFromTop
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = presentrCornerRadius
        customPresenter.blurBackground = true
        customPresenter.blurStyle = UIBlurEffectStyle.dark
        customPresenter.dismissOnSwipe = false
        return customPresenter
    }
    
    
    //MARK: Actions methods
    func showDescriptionClick() {
        print("showDescriptionClick")
    }
    
    @objc func dealershipClick() {
        print("dealershipClick")
        let dealershipController = DealershipPickupViewController(title: .ChooseDealership, buttonTitle: .Next, actionBlock: {})
        let modalPresenter = buildPresenter(heightInPixels: CGFloat(dealershipController.height()))
        customPresentViewController(modalPresenter, viewController: dealershipController, animated: true, completion: {})
    }
    
    func selfDropClick() {
        print("selfDropClick")
    }
    
    func volvoPickupClick() {
        print("volvoPickupClick")
    }
    
}
