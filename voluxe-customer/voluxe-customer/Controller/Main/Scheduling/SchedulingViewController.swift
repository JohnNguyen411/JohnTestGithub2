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
import SwiftEventBus

class SchedulingViewController: ChildViewController, PickupDealershipDelegate, PickupDateDelegate, PickupLocationDelegate, PickupLoanerDelegate, LocationManagerDelegate {
    
    public enum SchedulePickupState: Int {
        case start = 0
        case location = 1
        case dealership = 2
        case loaner = 3
        case dateTime = 4
    }
    
    public enum ScheduleDropoffState: Int {
        case start = 0
        case dateTime = 1
        case location = 2
    }
    
    static private let insetPadding: CGFloat = 20.0
    static let vlLabelHeight = VLTitledLabel.height + Int(SchedulingViewController.insetPadding)
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
    var realm : Realm?
    var locationManager = LocationManager.sharedInstance
    
    var dealerships: [Dealership]?
    var serviceState: ServiceState
    
    var pickupScheduleState: SchedulePickupState = .start
    var dropoffScheduleState: ScheduleDropoffState = .start
    
    let stateTestView = UILabel(frame: .zero)
    let dealershipTestView = UIView(frame: .zero)
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let dealershipAddressView = UIView()
    let scheduledServiceView = VLTitledLabel(padding: insetPadding)
    let descriptionButton = VLButton(type: .blueSecondary, title: (.ShowDescription as String).uppercased(), actionBlock: nil)
    let dealershipView = VLTitledLabel(padding: insetPadding)
    let scheduledPickupView = VLTitledLabel(title: .ScheduledPickup, leftDescription: "", rightDescription: "", padding: insetPadding)
    let pickupLocationView = VLTitledLabel(title: .PickupLocation, leftDescription: "", rightDescription: "", padding: insetPadding)
    let loanerView = VLTitledLabel(title: .ComplimentaryLoaner, leftDescription: "", rightDescription: "", padding: insetPadding)
    let confirmButton = VLButton(type: .bluePrimary, title: (.ConfirmPickup as String).uppercased(), actionBlock: nil)
    
    let dealershipAddressLabel: UILabel = {
        let dealershipAddressLabel = UILabel()
        dealershipAddressLabel.textColor = .luxeGray()
        dealershipAddressLabel.font = .volvoSansLightBold(size: 12)
        dealershipAddressLabel.textAlignment = .left
        dealershipAddressLabel.numberOfLines = 1
        dealershipAddressLabel.lineBreakMode = .byTruncatingTail
        return dealershipAddressLabel
    }()
    
    let dealershipMapLabel: UILabel = {
        let dealershipMapLabel = UILabel()
        dealershipMapLabel.textColor = .luxeDeepBlue()
        dealershipMapLabel.font = .volvoSansLightBold(size: 12)
        dealershipMapLabel.text = String.Map.uppercased()
        dealershipMapLabel.textAlignment = .left
        return dealershipMapLabel
    }()
    
    
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
        
        confirmButton.setActionBlock {
            self.confirmButtonClick()
        }
        
        fillViews()
        
        // onLoanerChanged
        SwiftEventBus.onMainThread(self, name: "onLoanerChanged") { result in
            self.loanerView.descLeftLabel.text = RequestedServiceManager.sharedInstance.getLoaner() ? .Yes : .No
        }
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
        confirmButton.accessibilityIdentifier = "confirmButton"
        pickupLocationView.accessibilityIdentifier = "pickupLocationView"
        
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
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(scheduledServiceView)
        contentView.addSubview(descriptionButton)
        contentView.addSubview(dealershipView)
        contentView.addSubview(dealershipAddressView)
        contentView.addSubview(confirmButton)
        
        dealershipAddressView.addSubview(dealershipAddressLabel)
        dealershipAddressView.addSubview(dealershipMapLabel)
        
        confirmButton.alpha = 0
        dealershipView.alpha = 0
        dealershipAddressView.alpha = 0
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
            make.edges.equalToSuperview()
        }
        
        let leftRightPadding = UIEdgeInsetsMake(0, 20, 0, 20)
        
        contentView.snp.makeConstraints { make in
            make.left.top.width.height.equalTo(scrollView)
        }
        
        scheduledServiceView.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.top.equalToSuperview().offset(SchedulingViewController.insetPadding)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        descriptionButton.snp.makeConstraints { make in
            make.left.right.equalTo(scheduledServiceView).inset(leftRightPadding)
            make.top.equalTo(scheduledServiceView.snp.bottom)
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        pickupLocationView.snp.makeConstraints { make in
            make.left.right.equalTo(scheduledServiceView)
            make.top.equalTo(descriptionButton.snp.bottom).offset(SchedulingViewController.insetPadding)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        dealershipView.snp.makeConstraints { make in
            make.left.right.equalTo(scheduledServiceView)
            make.top.equalTo(pickupLocationView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        dealershipMapLabel.snp.makeConstraints { make in
            make.right.centerY.height.equalToSuperview()
            make.width.equalTo(60)
        }
        
        dealershipAddressLabel.snp.makeConstraints { make in
            make.left.height.centerY.equalToSuperview()
            make.right.equalTo(dealershipMapLabel.snp.left)
        }
        
        scheduledPickupView.snp.makeConstraints { make in
            make.left.right.equalTo(scheduledServiceView)
            make.top.equalTo(dealershipView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(leftRightPadding)
            make.bottom.equalTo(contentView.snp.bottom).offset(-SchedulingViewController.insetPadding)
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
        
        if let repairOrder = RequestedServiceManager.sharedInstance.getRepairOrder() {
            var title = String.RecommendedService
            if RequestedServiceManager.sharedInstance.isSelfInitiated() {
                title = .SelectedService
            }
            scheduledServiceView.setTitle(title: title, leftDescription: repairOrder.name!, rightDescription: "")
        }
        
        fillDealership()
        
        loanerView.descLeftLabel.text = RequestedServiceManager.sharedInstance.getLoaner() ? .Yes : .No
        
        confirmButton.setTitle(title: getConfirmButtonTitle())
    }
    
    private func fillDealership() {
        if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
            self.dealershipView.setTitle(title: .Dealership, leftDescription: dealership.name!, rightDescription: "")
        }
    }
    
    func fetchDealershipsForLocation(location: CLLocationCoordinate2D?, completion: (() -> Swift.Void)? = nil) {
        
        if let location = location {
            DealershipAPI().getDealerships(location: location).onSuccess { result in
                if let dealerships = result?.data?.result {
                    if StateServiceManager.sharedInstance.isPickup() {
                        if dealerships.count > 0 {
                            
                            //todo check with getDealershipRepairOrder if available ONLY at pickup
                            RepairOrderAPI().getDealershipRepairOrder(dealerships: dealerships, repairOrderTypeId: RequestedServiceManager.sharedInstance.getRepairOrder()?.repairOrderType?.id).onSuccess { result in
                                if let dealershipsRO = result?.data?.result {
                                    if let realm = self.realm {
                                        try? realm.write {
                                            realm.add(dealershipsRO, update: true)
                                        }
                                    }
                                    if dealershipsRO.count > 0 {
                                        self.handleDealershipsResponse(dealerships: dealerships)
                                    } else {
                                        // todo show error
                                    }
                                } else {
                                    // todo show error
                                }
                                
                                if let completion = completion {
                                    completion()
                                }

                                }.onFailure { error in
                                    // No nearby dealership offering that service
                                    // todo show error
                                    if let completion = completion {
                                        completion()
                                    }
                            }
                        }
                    } else {
                        self.handleDealershipsResponse(dealerships: dealerships)
                        if let completion = completion {
                            completion()
                        }
                    }
                } else {
                    if let completion = completion {
                        completion()
                    }
                    self.dealerships = nil
                }
                
                }.onFailure { error in
                    if let completion = completion {
                        completion()
                    }
            }
        }
    }
    
    // From list of dealership, check if offering service
    private func handleDealershipsResponse(dealerships: [Dealership]?) {
        if let dealerships = dealerships {
            //todo: hide loading if needed
            self.dealerships = dealerships
            if dealerships.count > 0 {
                
                if StateServiceManager.sharedInstance.isPickup() && RequestedServiceManager.sharedInstance.getDealership() == nil {
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
    }
    
    func showDealershipModal(dismissOnTap: Bool) {
        guard let dealerships = dealerships else {
            return
        }
        let dealershipVC = DealershipPickupViewController(title: .ChooseDealership, buttonTitle: .Next, dealerships: dealerships)
        dealershipVC.delegate = self
        dealershipVC.view.accessibilityIdentifier = "dealershipVC"
        currentPresentrVC = dealershipVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupLocationModal(dismissOnTap: Bool) {
        
        var title: String = .PickupLocationTitle
        if StateServiceManager.sharedInstance.isPickup() {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .DealershipCloseToLocation
            }
        }
        
        let locationVC = LocationPickupViewController(title: title, buttonTitle: .Next)
        locationVC.pickupLocationDelegate = self
        locationVC.view.accessibilityIdentifier = "locationVC"
        currentPresentrVC = locationVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupLoanerModal(dismissOnTap: Bool) {
        let loanerVC = LoanerPickupViewController(title: .DoYouNeedLoanerVehicle, buttonTitle: .Next)
        loanerVC.delegate = self
        loanerVC.view.accessibilityIdentifier = "loanerVC"
        currentPresentrVC = loanerVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupDateTimeModal(dismissOnTap: Bool) {
        
        var title: String = .SelectPickupDate
        if !StateServiceManager.sharedInstance.isPickup() {
            if let type = RequestedServiceManager.sharedInstance.getDropoffRequestType() , type == RequestType.advisorDropoff {
                title = .SelectPickupDate
            } else {
                title = .SelectDeliveryDate
            }
        } else {
            if let type = RequestedServiceManager.sharedInstance.getPickupRequestType() , type == RequestType.advisorPickup {
                title = .SelectDropoffDate
            }
        }
        
        let dateModal = DateTimePickupViewController(title: title, buttonTitle: .Next)
        dateModal.delegate = self
        dateModal.view.accessibilityIdentifier = "dateModal"
        currentPresentrVC = dateModal
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showDealershipAddress(dealership: Dealership) {
        dealershipAddressView.snp.makeConstraints { make in
            make.left.right.equalTo(scheduledServiceView).inset(UIEdgeInsetsMake(0, 20, 0, 20))
            make.top.equalTo(dealershipView.snp.bottom).offset(-5)
            make.height.equalTo(25)
        }
        
        scheduledPickupView.snp.remakeConstraints { make in
            make.left.right.equalTo(scheduledServiceView)
            make.top.equalTo(dealershipAddressView.snp.bottom).offset(10)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        dealershipAddressView.animateAlpha(show: true)
        dealershipAddressLabel.text = dealership.location?.address
    }
    
    
    func getPickupLocationTitle() -> String {
        var title: String = .PickupLocationTitle
        if StateServiceManager.sharedInstance.isPickup() {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .DealershipCloseToLocation
            }
        }
        return title
    }
    
    func getScheduledPickupTitle() -> String {
        var title: String = .ScheduledPickup
        if StateServiceManager.sharedInstance.isPickup() {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .ScheduledSelfDrop
            }
        }
        return title
    }
    
    func getConfirmButtonTitle() -> String {
        var title: String = .ConfirmPickup
        if StateServiceManager.sharedInstance.isPickup() {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .ConfirmSelfDrop
            }
        } else {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .ConfirmSelfPickup
            } else {
                title = .ConfirmDelivery
            }
        }
        return title
        
    }
    
    
    //MARK: Actions methods
    func showDescriptionClick() {
        if let repairOrder = RequestedServiceManager.sharedInstance.getRepairOrder(), let repairOrderType = repairOrder.repairOrderType {
            childViewDelegate?.pushViewController(controller: ServiceDetailViewController(service: repairOrderType, canSchedule: true), animated: true, backLabel: .Back, title: repairOrderType.name)
        }
    }
    
    @objc func dealershipClick() {
        dealershipView.animateAlpha(show: true)
    }
    
    @objc func scheduledPickupClick() {
        scheduledPickupView.animateAlpha(show: true)
    }
    
    @objc func pickupLocationClick() {
        pickupLocationView.animateAlpha(show: true)
    }
    
    @objc func loanerClick() {
        loanerView.animateAlpha(show: true)
    }
    
    func showConfirmButtonIfNeeded() {
        
    }
    
    func confirmButtonClick() {
    }
    
    //MARK: LocationManager delegate methods
    
    func locationFound(_ latitude: Double, longitude: Double) {
        fillDealership()
    }
    
    
    //MARK: PresentR delegate methods
    
    func onDealershipSelected(dealership: Dealership) {
    }
    
    func onDateTimeSelected(timeSlot: DealershipTimeSlot?) {
        
        if StateServiceManager.sharedInstance.isPickup() {
            RequestedServiceManager.sharedInstance.setPickupTimeSlot(timeSlot: timeSlot)
        } else {
            RequestedServiceManager.sharedInstance.setDropoffTimeSlot(timeSlot: timeSlot)
        }
        
        guard let timeSlot = timeSlot else {
            scheduledPickupView.setTitle(title: getScheduledPickupTitle(), leftDescription: "", rightDescription: "")
            return
        }
        
        let dateTime = formatter.string(from: timeSlot.from!)
        scheduledPickupView.setTitle(title: getScheduledPickupTitle(), leftDescription: "\(dateTime) \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "")", rightDescription: "")
    }
    
    func onSizeChanged() {
        // increase size of presenter
        let newHeight = CGFloat(currentPresentrVC!.height())
        let presentationType = getPresenterPresentationType(heightInPixels: newHeight, customYOrigin: BaseViewController.fakeYOrigin)
        currentPresentr?.currentPresentationController?.updateToNewFrame(presentationType: presentationType)
    }
    
    func onLocationSelected(customerAddress: CustomerAddress) {
        
        //let locationRequest = RequestLocation(name: responseInfo!.value(forKey: "formattedAddress") as? String, stringLocation: nil, location: placemark?.location?.coordinate)
        let locationRequest = customerAddress.location
        if StateServiceManager.sharedInstance.isPickup() {
            RequestedServiceManager.sharedInstance.setPickupRequestLocation(requestLocation: locationRequest!)
        } else {
            RequestedServiceManager.sharedInstance.setDropoffRequestLocation(requestLocation: locationRequest!)
        }
        var title: String = .PickupLocation
        if StateServiceManager.sharedInstance.isPickup() {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .DealershipCloseToLocation
            }
        } else {
            title = .DeliveryLocation
        }
        
        pickupLocationView.setTitle(title: title, leftDescription: locationRequest!.address!, rightDescription: "")
    }
    
    func onLoanerSelected(loanerNeeded: Bool) {
        
        let valueChanged = loanerNeeded != RequestedServiceManager.sharedInstance.getLoaner()
        
        var openNext = false
        RequestedServiceManager.sharedInstance.setLoaner(loaner: loanerNeeded)
        
        if pickupScheduleState.rawValue < SchedulePickupState.loaner.rawValue {
            pickupScheduleState = .loaner
            openNext = true
        } else {
            if valueChanged {
                
                scheduledPickupView.setTitle(title: getScheduledPickupTitle(), leftDescription: "", rightDescription: "")
                
                // invalidate Date/Time
                if StateServiceManager.sharedInstance.isPickup() {
                    RequestedServiceManager.sharedInstance.setPickupTimeSlot(timeSlot: nil)
                } else {
                    RequestedServiceManager.sharedInstance.setDropoffTimeSlot(timeSlot: nil)
                }
                
                // re-select TimeSlot
                openNext = true
                
                self.showConfirmButtonIfNeeded()
            }
        }
        
        loanerView.descLeftLabel.text = loanerNeeded ? .Yes : .No
        currentPresentrVC?.dismiss(animated: true, completion: {
            if openNext {
                self.scheduledPickupClick()
            }
        })
    }
    
}
