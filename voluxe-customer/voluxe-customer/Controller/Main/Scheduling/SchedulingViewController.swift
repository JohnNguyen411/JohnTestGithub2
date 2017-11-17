//
//  SchedulingViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import CoreLocation

class SchedulingViewController: BaseViewController, PresentrDelegate, PickupDealershipDelegate, PickupDateDelegate, PickupLocationDelegate, PickupLoanerDelegate {
    
    public enum SchedulePickupState: Int {
        case start = 0
        case dealership = 1
        case dateTime = 2
        case location = 3
        case loaner = 4
    }
    
    static private let fakeYOrigin: CGFloat = -555.0
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
    var serviceState: ServiceState
    var scheduleState: SchedulePickupState = .start
    
    let presentrCornerRadius: CGFloat = 4.0
    var currentPresentr: Presentr?
    var currentPresentrVC: VLPresentrViewController?
    
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
    let scheduledPickupView = VLTitledLabel(title: .ScheduledPickup, leftDescription: "", rightDescription: "")
    let pickupLocationView = VLTitledLabel(title: .PickupLocation, leftDescription: "", rightDescription: "")
    let loanerView = VLTitledLabel(title: .ComplimentaryLoaner, leftDescription: "", rightDescription: "")
    
    let leftButton = VLButton(type: .BluePrimary, title: (.SelfDrop as String).uppercased(), actionBlock: nil)
    let rightButton = VLButton(type: .BluePrimary, title: (.VolvoPickup as String).uppercased(), actionBlock: nil)
    let confirmButton = VLButton(type: .BluePrimary, title: (.ConfirmPickup as String).uppercased(), actionBlock: nil)
    
    
    init(state: ServiceState) {
        self.serviceState = state
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionButton.setActionBlock {
            self.showDescriptionClick()
        }
        descriptionButton.contentHorizontalAlignment = .left
        
        leftButton.setActionBlock {
            self.leftButtonClick()
        }
        rightButton.setActionBlock {
            self.rightButtonClick()
        }
        confirmButton.setActionBlock {
            self.confirmButtonClick()
        }
        
        fillViews()
    }
    
    //MARK: View methods
    
    override func setupViews() {
        super.setupViews()
        
        // init tap events
        dealershipView.isUserInteractionEnabled = true
        let dealershipTap = UITapGestureRecognizer(target: self, action: #selector(self.dealershipClick))
        dealershipView.addGestureRecognizer(dealershipTap)
        
        scheduledPickupView.isUserInteractionEnabled = true
        let scheduledPickupTap = UITapGestureRecognizer(target: self, action: #selector(self.scheduledPickupClick))
        scheduledPickupView.addGestureRecognizer(scheduledPickupTap)
        
        pickupLocationView.isUserInteractionEnabled = true
        let pickupLocationTap = UITapGestureRecognizer(target: self, action: #selector(self.pickupLocationClick))
        pickupLocationView.addGestureRecognizer(pickupLocationTap)
        
        loanerView.isUserInteractionEnabled = true
        let loanerTap = UITapGestureRecognizer(target: self, action: #selector(self.loanerClick))
        loanerView.addGestureRecognizer(loanerTap)
        
        scrollView.contentMode = .scaleAspectFit
        
        let sizeThatFits = checkupLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT)))
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(checkupLabel)
        
        contentView.addSubview(scheduledServiceView)
        contentView.addSubview(descriptionButton)
        contentView.addSubview(dealershipView)
        
        contentView.addSubview(leftButton)
        contentView.addSubview(rightButton)
        contentView.addSubview(confirmButton)
        
        confirmButton.alpha = 0
        scheduledPickupView.alpha = 0
        pickupLocationView.alpha = 0
        loanerView.alpha = 0
        
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
        
        scheduledPickupView.snp.makeConstraints { make in
            make.left.right.equalTo(checkupLabel)
            make.top.equalTo(dealershipView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        pickupLocationView.snp.makeConstraints { make in
            make.left.right.equalTo(checkupLabel)
            make.top.equalTo(scheduledPickupView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalToSuperview().dividedBy(2).offset(-10)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
    }
    
    func fillViews() {
        scheduledServiceView.setTitle(title: .RecommendedService, leftDescription: "10,000 mile check-up", rightDescription: "$400")
        dealershipView.setTitle(title: .Dealership, leftDescription: "Marin Volvo", rightDescription: "")
    }
    
    func buildPresenter(heightInPixels: CGFloat, dismissOnTap: Bool) -> Presentr {
        let customType = getPresenterPresentationType(heightInPixels: heightInPixels, customYOrigin: SchedulingPickupViewController.fakeYOrigin)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = presentrCornerRadius
        customPresenter.blurBackground = true
        customPresenter.blurStyle = UIBlurEffectStyle.light
        customPresenter.dismissOnSwipe = false
        customPresenter.keyboardTranslationType = .moveUp
        customPresenter.dismissOnTap = dismissOnTap
        
        
        return customPresenter
    }
    
    func getPresenterPresentationType(heightInPixels: CGFloat, customYOrigin: CGFloat) -> PresentationType {
        let widthPerc = 0.95
        let width = ModalSize.fluid(percentage: Float(widthPerc))
        
        let viewH = self.view.frame.height + MainViewController.getNavigationBarHeight() + statusBarHeight() + presentrCornerRadius
        let viewW = Double(self.view.frame.width)
        
        let percH = heightInPixels / viewH
        let leftRightMargin = (viewW - (viewW * widthPerc))/2
        let height = ModalSize.fluid(percentage: Float(percH))
        
        var yOrigin = customYOrigin
        if yOrigin == SchedulingPickupViewController.fakeYOrigin {
            yOrigin = viewH - heightInPixels
        }
        
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: leftRightMargin, y: Double(yOrigin)))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        return customType
    }
    
    func showDealershipModal() {
        let dealershipVC = DealershipPickupViewController(title: .ChooseDealership, buttonTitle: .Next)
        dealershipVC.delegate = self
        currentPresentrVC = dealershipVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: true)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupLocationModal() {
        let locationVC = LocationPickupViewController(title: .PickupLocationTitle, buttonTitle: .Next)
        locationVC.pickupLocationDelegate = self
        currentPresentrVC = locationVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: scheduleState.rawValue >= SchedulePickupState.location.rawValue)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupLoanerModal() {
        let loanerVC = LoanerPickupViewController(title: .DoYouNeedLoanerVehicle, buttonTitle: .Next)
        loanerVC.delegate = self
        currentPresentrVC = loanerVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: scheduleState.rawValue >= SchedulePickupState.loaner.rawValue)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupDateTimeModal() {
        let dateModal = DateTimePickupViewController(title: .SelectYourPreferredPickupTime, buttonTitle: .Next)
        dateModal.delegate = self
        currentPresentrVC = dateModal
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: scheduleState.rawValue >= SchedulePickupState.dateTime.rawValue)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {
            self.hideCheckupLabel()
        })
    }
    
    func hideCheckupLabel() {
        self.checkupLabel.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        currentPresentr = nil
        currentPresentrVC = nil
        return true
    }
    
    func stateDidChange(state: ServiceState) {
        
    }
    
    //MARK: Actions methods
    func showDescriptionClick() {
    }
    
    @objc func dealershipClick() {
        showDealershipModal()
    }
    
    @objc func scheduledPickupClick() {
        showPickupDateTimeModal()
    }
    
    @objc func pickupLocationClick() {
        showPickupLocationModal()
        pickupLocationView.animateAlpha(show: true)
    }
    
    @objc func loanerClick() {
        showPickupLoanerModal()
        loanerView.animateAlpha(show: true)
    }
    
    func leftButtonClick() {
    }
    
    func rightButtonClick() {
        showPickupDateTimeModal()
        scheduledPickupView.animateAlpha(show: true)
        
        leftButton.animateAlpha(show: false)
        rightButton.animateAlpha(show: false)
    }
    
    func confirmButtonClick() {
    }
        
    
    //MARK: PresentR delegate methods
    
    func onDealershipSelected(dealership: String) {
        if scheduleState.rawValue < SchedulePickupState.dealership.rawValue {
            scheduleState = .dealership
        }
        dealershipView.descLeftLabel.text = dealership
        currentPresentrVC?.dismiss(animated: true, completion: nil)
    }
    
    func onDateTimeSelected(date: Date, hourRangeMin: Int, hourRangeMax: Int) {
        var openNext = false
        if scheduleState.rawValue < SchedulePickupState.dateTime.rawValue {
            scheduleState = .dateTime
            openNext = true
        }

        let dateTime = formatter.string(from: date)
        scheduledPickupView.setTitle(title: .ScheduledPickup, leftDescription: dateTime, rightDescription: "")
        
        currentPresentrVC?.dismiss(animated: true, completion: {
            if openNext {
                self.pickupLocationClick()
            }
        })
    }
    
    func onLocationAdded(newSize: Int) {
        // increase size of presenter
        let newHeight = CGFloat(currentPresentrVC!.height())
        let presentationType = getPresenterPresentationType(heightInPixels: newHeight, customYOrigin: SchedulingPickupViewController.fakeYOrigin)
        currentPresentr?.currentPresentationController?.updateToNewFrame(presentationType: presentationType)
    }
    
    func onLocationSelected(responseInfo: NSDictionary?, placemark: CLPlacemark?) {
        pickupLocationView.setTitle(title: .PickupLocation, leftDescription: responseInfo!.value(forKey: "formattedAddress") as! String, rightDescription: "")
    }
    
    func onLoanerSelected(loanerNeeded: Bool) {
        if scheduleState.rawValue < SchedulePickupState.loaner.rawValue {
            scheduleState = .loaner
        }
        loanerView.descLeftLabel.text = loanerNeeded ? .Yes : .No
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.confirmButton.animateAlpha(show: true)
        })
    }
    
}
