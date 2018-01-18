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
import RealmSwift
import BrightFutures
import Alamofire

class SchedulingViewController: ChildViewController, PresentrDelegate, PickupDealershipDelegate, PickupDateDelegate, PickupLocationDelegate, PickupLoanerDelegate, LocationManagerDelegate {
    
    
    public enum SchedulePickupState: Int {
        case start = 0
        case dealership = 1
        case dateTime = 2
        case location = 3
        case loaner = 4
    }
    
    static private let fakeYOrigin: CGFloat = -555.0
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
    var realm : Realm?
    var locationManager = LocationManager.sharedInstance

    var dealerships: [Dealership]?
    var serviceState: ServiceState
    var scheduleState: SchedulePickupState = .start
    
    var checkupLabelHeight: CGFloat = 0
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
    
    let stateTestView = UILabel(frame: .zero)
    let dealershipTestView = UIView(frame: .zero)

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
        
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        realm = try? Realm()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stateDidChange(state: serviceState)
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        stateTestView.accessibilityIdentifier = "schedulingTestView\(state)"
        stateTestView.text = "schedulingTestView\(state)"
    }
    
    deinit {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: View methods
    
    override func setupViews() {
        super.setupViews()
        
        dealershipView.accessibilityIdentifier = "dealershipView"
        rightButton.accessibilityIdentifier = "rightButton"
        confirmButton.accessibilityIdentifier = "confirmButton"
        
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
        
        checkupLabelHeight = checkupLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height
        
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
        
        // TestView setup
        dealershipTestView.accessibilityIdentifier = "dealershipTestView"
        dealershipTestView.isHidden = true
        contentView.addSubview(dealershipTestView)
        contentView.addSubview(stateTestView)
        stateTestView.textColor = .clear
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(20, 20, 20, 20))
        }
        
        contentView.snp.makeConstraints { make in
            make.left.top.width.height.equalTo(scrollView)
        }
        
        checkupLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(checkupLabelHeight)
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
        
        stateTestView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
            make.height.width.equalTo(1)
        }
        
        dealershipTestView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(dealershipView.snp.bottom).offset(1)
            make.height.width.equalTo(1)
        }
        
    }
    
    func fillViews() {
        if let service = RequestedServiceManager.sharedInstance.getService() {
            scheduledServiceView.setTitle(title: .RecommendedService, leftDescription: service.name!, rightDescription: String(format: "$%.02f", service.price!))
        }
        
        fillDealership()
        
        if RequestedServiceManager.sharedInstance.getLoaner() == nil {
            RequestedServiceManager.sharedInstance.setLoaner(loaner: true)
        }
        if let loaner = RequestedServiceManager.sharedInstance.getLoaner() {
            loanerView.descLeftLabel.text = loaner ? .Yes : .No
        }
    }
    
    private func fillDealership() {
        if RequestedServiceManager.sharedInstance.getDealership() == nil {
            
            if CLLocationManager.locationServicesEnabled() && locationManager.lastKnownLatitude != 0 && locationManager.lastKnownLongitude != 0 && locationManager.hasLastKnownLocation {
                DealershipAPI().getDealerships(location: CLLocationCoordinate2DMake(locationManager.lastKnownLatitude, locationManager.lastKnownLongitude)).onSuccess { result in
                    
                    self.handleDealershipsResponse(result: result)
                    
                    }.onFailure { error in
                }
            } else {
                DealershipAPI().getDealerships().onSuccess { result in
                    
                    self.handleDealershipsResponse(result: result)
                    
                    }.onFailure { error in
                }
            }
            
        } else {
            if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
                self.dealershipView.setTitle(title: .Dealership, leftDescription: dealership.name!, rightDescription: "")
            }
        }
    }
    
    private func handleDealershipsResponse(result: ResponseObject<MappableDataArray<Dealership>>?) {
        if let dealerships = result?.data?.result, dealerships.count > 0 {
            self.dealerships = dealerships
            if RequestedServiceManager.sharedInstance.getDealership() == nil {
                RequestedServiceManager.sharedInstance.setDealership(dealership: dealerships[0])
            }
            if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
                if let dealershipName = dealership.name {
                    self.dealershipView.setTitle(title: .Dealership, leftDescription: dealershipName, rightDescription: "")
                }
            }
            
            self.dealershipTestView.isHidden = false
            
            if let realm = self.realm {
                try? realm.write {
                    realm.add(dealerships, update: true)
                }
            }
        }
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
        
        let viewH = self.view.frame.height + AppDelegate.getNavigationBarHeight() + statusBarHeight() + presentrCornerRadius
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
        guard let dealerships = dealerships else {
            return
        }
        let dealershipVC = DealershipPickupViewController(title: .ChooseDealership, buttonTitle: .Next, dealerships: dealerships)
        dealershipVC.delegate = self
        dealershipVC.view.accessibilityIdentifier = "dealershipVC"
        currentPresentrVC = dealershipVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: true)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupLocationModal() {
        let locationVC = LocationPickupViewController(title: .PickupLocationTitle, buttonTitle: .Next)
        locationVC.pickupLocationDelegate = self
        locationVC.view.accessibilityIdentifier = "locationVC"
        currentPresentrVC = locationVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: scheduleState.rawValue >= SchedulePickupState.location.rawValue)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupLoanerModal() {
        let loanerVC = LoanerPickupViewController(title: .DoYouNeedLoanerVehicle, buttonTitle: .Next)
        loanerVC.delegate = self
        loanerVC.view.accessibilityIdentifier = "loanerVC"
        currentPresentrVC = loanerVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: scheduleState.rawValue >= SchedulePickupState.loaner.rawValue)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupDateTimeModal() {
        let dateModal = DateTimePickupViewController(title: .SelectYourPreferredPickupTime, buttonTitle: .Next)
        dateModal.delegate = self
        dateModal.view.accessibilityIdentifier = "dateModal"
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
        
        if ServiceState.isPickup(state: serviceState) {
            setTitle(title: .SchedulePickup)
        } else {
            setTitle(title: .ScheduleDelivery)
        }
    }
    
    func confirmButtonClick() {
    }
    
    //MARK: LocationManager delegate methods

    func locationFound(_ latitude: Double, longitude: Double) {
        fillDealership()
    }
        
    
    //MARK: PresentR delegate methods
    
    func onDealershipSelected(dealership: Dealership) {
        RequestedServiceManager.sharedInstance.setDealership(dealership: dealership)
        if scheduleState.rawValue < SchedulePickupState.dealership.rawValue {
            scheduleState = .dealership
        }
        dealershipView.descLeftLabel.text = dealership.name
        currentPresentrVC?.dismiss(animated: true, completion: nil)
    }
    
    func onDateTimeSelected(date: Date, hourRangeMin: Int, hourRangeMax: Int) {
        var openNext = false
        if scheduleState.rawValue < SchedulePickupState.dateTime.rawValue {
            scheduleState = .dateTime
            openNext = true
        }
        
        if StateServiceManager.sharedInstance.isPickup() {
            RequestedServiceManager.sharedInstance.setPickupDate(date: date)
            RequestedServiceManager.sharedInstance.setPickupTimeRange(min: hourRangeMin, max: hourRangeMax)
        } else {
            RequestedServiceManager.sharedInstance.setDropoffDate(date: date)
            RequestedServiceManager.sharedInstance.setDropoffTimeRange(min: hourRangeMin, max: hourRangeMax)
        }
        
        let dateTime = formatter.string(from: date)
        scheduledPickupView.setTitle(title: .ScheduledPickup, leftDescription: "\(dateTime) \(Date.formatHourRange(min: hourRangeMin, max:hourRangeMax))", rightDescription: "")
        
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
        //let locationRequest = RequestLocation(name: responseInfo!.value(forKey: "formattedAddress") as? String, stringLocation: nil, location: placemark?.location?.coordinate)
        let locationRequest = RequestLocation(name: responseInfo!.value(forKey: "formattedAddress") as? String, latitude: nil, longitude: nil, location: placemark?.location?.coordinate)
        if StateServiceManager.sharedInstance.isPickup() {
            RequestedServiceManager.sharedInstance.setPickupRequestLocation(requestLocation: locationRequest)
        } else {
            RequestedServiceManager.sharedInstance.setDropoffRequestLocation(requestLocation: locationRequest)
        }
        pickupLocationView.setTitle(title: .PickupLocation, leftDescription: locationRequest.name!, rightDescription: "")
    }
    
    func onLoanerSelected(loanerNeeded: Bool) {
        RequestedServiceManager.sharedInstance.setLoaner(loaner: loanerNeeded)
        if scheduleState.rawValue < SchedulePickupState.loaner.rawValue {
            scheduleState = .loaner
        }
        loanerView.descLeftLabel.text = loanerNeeded ? .Yes : .No
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.confirmButton.animateAlpha(show: true)
        })
    }
    
}
