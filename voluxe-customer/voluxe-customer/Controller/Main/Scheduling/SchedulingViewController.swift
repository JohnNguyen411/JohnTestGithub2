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

class SchedulingViewController: ChildViewController, PickupDealershipDelegate, PickupDateDelegate, PickupLocationDelegate, PickupLoanerDelegate, LocationManagerDelegate {
    
    public enum SchedulePickupState: Int {
        case start = 0
        case location = 1
        case dealership = 2
        case dateTime = 3
        case loaner = 4
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
    let scheduledServiceView = VLTitledLabel(padding: insetPadding)
    let descriptionButton = VLButton(type: .BlueSecondary, title: (.ShowDescription as String).uppercased(), actionBlock: nil)
    let dealershipView = VLTitledLabel(padding: insetPadding)
    let scheduledPickupView = VLTitledLabel(title: .ScheduledPickup, leftDescription: "", rightDescription: "", padding: insetPadding)
    let pickupLocationView = VLTitledLabel(title: .PickupLocation, leftDescription: "", rightDescription: "", padding: insetPadding)
    let loanerView = VLTitledLabel(title: .ComplimentaryLoaner, leftDescription: "", rightDescription: "", padding: insetPadding)
    
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
        contentView.addSubview(confirmButton)
        
        confirmButton.alpha = 0
        dealershipView.alpha = 0
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
        
        if let service = RequestedServiceManager.sharedInstance.getService() {
            scheduledServiceView.setTitle(title: .RecommendedService, leftDescription: service.name!, rightDescription: String(format: "$%.02f", service.price!))
        }
        
        fillDealership()
        
        loanerView.descLeftLabel.text = RequestedServiceManager.sharedInstance.getLoaner() ? .Yes : .No
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
                    self.handleDealershipsResponse(dealerships: dealerships)
                } else {
                    self.dealerships = nil
                }
                if let completion = completion {
                    completion()
                }
                }.onFailure { error in
                    if let completion = completion {
                        completion()
                    }
            }
        }
    }
    
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
        let locationVC = LocationPickupViewController(title: .PickupLocationTitle, buttonTitle: .Next)
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
        let dateModal = DateTimePickupViewController(title: .SelectYourPreferredPickupTime, buttonTitle: .Next)
        dateModal.delegate = self
        dateModal.view.accessibilityIdentifier = "dateModal"
        currentPresentrVC = dateModal
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    
    
    //MARK: Actions methods
    func showDescriptionClick() {
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
    
    
    func confirmButtonClick() {
    }
    
    //MARK: LocationManager delegate methods
    
    func locationFound(_ latitude: Double, longitude: Double) {
        fillDealership()
    }
    
    
    //MARK: PresentR delegate methods
    
    func onDealershipSelected(dealership: Dealership) {
    }
    
    func onDateTimeSelected(timeSlot: DealershipTimeSlot) {
        
        if StateServiceManager.sharedInstance.isPickup() {
            RequestedServiceManager.sharedInstance.setPickupTimeSlot(timeSlot: timeSlot)
        } else {
            RequestedServiceManager.sharedInstance.setDropoffTimeSlot(timeSlot: timeSlot)
        }
        
        let dateTime = formatter.string(from: timeSlot.from!)
        scheduledPickupView.setTitle(title: .ScheduledPickup, leftDescription: "\(dateTime) \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "")", rightDescription: "")
    }
    
    func onLocationAdded(newSize: Int) {
        // increase size of presenter
        let newHeight = CGFloat(currentPresentrVC!.height())
        let presentationType = getPresenterPresentationType(heightInPixels: newHeight, customYOrigin: BaseViewController.fakeYOrigin)
        currentPresentr?.currentPresentationController?.updateToNewFrame(presentationType: presentationType)
    }
    
    func onLocationSelected(responseInfo: NSDictionary?, placemark: CLPlacemark?) {
        
        //let locationRequest = RequestLocation(name: responseInfo!.value(forKey: "formattedAddress") as? String, stringLocation: nil, location: placemark?.location?.coordinate)
        let locationRequest = Location(name: responseInfo!.value(forKey: "formattedAddress") as? String, latitude: nil, longitude: nil, location: placemark?.location?.coordinate)
        if StateServiceManager.sharedInstance.isPickup() {
            RequestedServiceManager.sharedInstance.setPickupRequestLocation(requestLocation: locationRequest)
        } else {
            RequestedServiceManager.sharedInstance.setDropoffRequestLocation(requestLocation: locationRequest)
        }
        pickupLocationView.setTitle(title: .PickupLocation, leftDescription: locationRequest.address!, rightDescription: "")
    }
    
    func onLoanerSelected(loanerNeeded: Bool) {
        RequestedServiceManager.sharedInstance.setLoaner(loaner: loanerNeeded)
        if pickupScheduleState.rawValue < SchedulePickupState.loaner.rawValue {
            pickupScheduleState = .loaner
        }
        loanerView.descLeftLabel.text = loanerNeeded ? .Yes : .No
        currentPresentrVC?.dismiss(animated: true, completion: {
            self.confirmButton.animateAlpha(show: true)
        })
    }
    
}
