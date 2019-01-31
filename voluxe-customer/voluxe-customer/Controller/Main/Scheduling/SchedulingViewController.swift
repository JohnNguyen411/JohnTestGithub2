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
import Alamofire
import SwiftEventBus
import MBProgressHUD

class SchedulingViewController: BaseVehicleViewController, PickupDealershipDelegate, PickupDateDelegate, PickupLocationDelegate, PickupLoanerDelegate, LocationManagerDelegate {
    
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
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
    
    var realm : Realm?
    var locationManager = LocationManager.sharedInstance
    
    var dealerships: [Dealership]?
    
    var pickupScheduleState: SchedulePickupState = .start
    var dropoffScheduleState: ScheduleDropoffState = .start
    
    let stateTestView = UILabel(frame: .zero)
    let dealershipTestView = UIView(frame: .zero)
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let dealershipAddressView = UIView()
    let scheduledServiceView = VLTitledLabel(padding: insetPadding)
    let descriptionButton: VLButton
    let dealershipView = VLTitledLabel(padding: insetPadding)
    let scheduledPickupView = VLTitledLabel(title: .localized(.scheduledPickup), leftDescription: "", rightDescription: "", padding: insetPadding)
    let pickupLocationView = VLTitledLabel(title: .localized(.pickupLocation), leftDescription: "", rightDescription: "", padding: insetPadding)
    let loanerView = VLTitledLabel(title: .localized(.needALoaner), leftDescription: "", rightDescription: "", padding: insetPadding)
    let confirmButton: VLButton
    
    let dealershipAddressLabel: UILabel = {
        let dealershipAddressLabel = UILabel()
        dealershipAddressLabel.textColor = .luxeGray()
        dealershipAddressLabel.font = .volvoSansProMedium(size: 12)
        dealershipAddressLabel.textAlignment = .left
        dealershipAddressLabel.numberOfLines = 1
        dealershipAddressLabel.lineBreakMode = .byTruncatingTail
        return dealershipAddressLabel
    }()
    
    let dealershipMapLabel: UILabel = {
        let dealershipMapLabel = UILabel()
        dealershipMapLabel.textColor = .luxeCobaltBlue()
        dealershipMapLabel.font = .volvoSansProMedium(size: 12)
        dealershipMapLabel.text = String.localized(.map).uppercased()
        dealershipMapLabel.textAlignment = .left
        dealershipMapLabel.addUppercasedCharacterSpacing()
        return dealershipMapLabel
    }()
    
    
    override init(vehicle: Vehicle, state: ServiceState, screen: AnalyticsEnums.Name.Screen? = nil) {
        descriptionButton = VLButton(type: .blueSecondary, title: String.localized(.showDetails).uppercased(), kern: UILabel.uppercasedKern(), event: .showService, screen: screen)
        confirmButton = VLButton(type: .bluePrimary, title: SchedulingViewController.getConfirmButtonTitle(vehicleId: vehicle.id), kern: UILabel.uppercasedKern())
        
        super.init(vehicle: vehicle, state: state, screen: screen)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.autoUpdate = true
        if locationManager.canUpdateLocation() {
            locationManager.startUpdatingLocation()
        }
        
        realm = try? Realm()
        
        descriptionButton.setActionBlock { [weak self] in
            self?.showDescriptionClick()
        }
        descriptionButton.contentHorizontalAlignment = .leftOrLeading()
        
        confirmButton.setActionBlock { [weak self] in
            self?.confirmButtonClick()
        }
        
        fillViews()
        
        // onLoanerChanged
        SwiftEventBus.onMainThread(self, name: "onLoanerChanged") { result in
            var loaner = false
            if let selectedLoaner = RequestedServiceManager.sharedInstance.getLoaner() {
                loaner = selectedLoaner
            }
            self.loanerView.setLeftDescription(leftDescription: loaner ? .localized(.yes) : .localized(.no))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.autoUpdate = true
        if locationManager.canUpdateLocation() {
            locationManager.startUpdatingLocation()
        }
        stateDidChange(state: serviceState)
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        stateTestView.accessibilityIdentifier = "schedulingTestView\(state)"
        stateTestView.text = "schedulingTestView\(state)"
        if (state != .schedulingDelivery && state != .schedulingService) {
            // state has change for this car, possibly sync from BE.
            RequestedServiceManager.sharedInstance.reset()
            AppController.sharedInstance.showVehiclesView(animated: false)
        }
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
            make.edgesEqualsToView(view: self.view)
        }
        
        let leftRightPadding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        contentView.snp.makeConstraints { make in
            make.leading.top.width.height.equalTo(scrollView)
        }
        
        scheduledServiceView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalToSuperview().offset(BaseViewController.defaultTopYOffset)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        descriptionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scheduledServiceView).inset(leftRightPadding)
            make.top.equalTo(scheduledServiceView.snp.bottom).offset(-10)
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        pickupLocationView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scheduledServiceView)
            make.top.equalTo(descriptionButton.snp.bottom).offset(10)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        dealershipView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scheduledServiceView)
            make.top.equalTo(pickupLocationView.snp.bottom)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        if StateServiceManager.sharedInstance.isPickup(vehicleId: self.vehicle.id) && RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.loanerFeatureEnabledKey) {
            scheduledPickupView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(scheduledServiceView)
                make.top.equalTo(loanerView.snp.bottom)
                make.height.equalTo(SchedulingViewController.vlLabelHeight)
            }
        } else {
            scheduledPickupView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(scheduledServiceView)
                make.top.equalTo(dealershipView.snp.bottom)
                make.height.equalTo(SchedulingViewController.vlLabelHeight)
            }
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leftRightPadding)
            make.bottom.equalTo(contentView.snp.bottom).offset(-SchedulingViewController.insetPadding)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        stateTestView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
            make.height.width.equalTo(1)
        }
        
        dealershipTestView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(dealershipView.snp.bottom).offset(1)
            make.height.width.equalTo(1)
        }
        
    }
    
    func fillViews() {
        
        if let repairOrder = RequestedServiceManager.sharedInstance.getRepairOrder() {
            var title = String.localized(.recommendedService)
            if RequestedServiceManager.sharedInstance.isSelfInitiated() {
                title = .localized(.selectedService)
            }
            scheduledServiceView.setTitle(title: title, leftDescription: repairOrder.getTitle(), rightDescription: "")
        }
        
        fillDealership()
        
        var loaner = false
        if let selectedLoaner = RequestedServiceManager.sharedInstance.getLoaner() {
            loaner = selectedLoaner
        }
        
        loanerView.setLeftDescription(leftDescription: loaner ? .localized(.yes) : .localized(.no))
        
        self.confirmButton.setTitle(title: SchedulingViewController.getConfirmButtonTitle(vehicleId: vehicle.id))
        self.confirmButton.setEvent(name: self.getConfirmButtonEvent(), screen: self.screen)
    }
    
    func fillDealership() {
        if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
            self.dealershipView.setTitle(title: .localized(.dealership), leftDescription: dealership.name!, rightDescription: "")
        }
    }
    
    /**
     Fetch the dealership that server the provided location
     - parameter location: the location
     - parameter completion: the completion block to execute

     - Returns: A Future ResponseObject containing a list of Dealership around the location, or an AFError if an error occured
     */
    //
    func fetchDealershipsForLocation(location: CLLocationCoordinate2D?, completion: ((_ error: String?) -> ())? = nil) {
        
        guard let location = location else { return }
        
        CustomerAPI.dealerships(location: location) { dealerships, error in
            
            if error != nil {
                completion?(nil)
                self.dealerships = nil
            } else {
                
                if StateServiceManager.sharedInstance.isPickup(vehicleId: self.vehicle.id) {
                    if let repairOrderTypeId = RequestedServiceManager.sharedInstance.getRepairOrder()?.repairOrderType?.id, dealerships.count > 0 {
                        self.filterDealershipsForRepairOrder(repairOrderTypeId, dealerships: dealerships, completion: completion)
                    } else {
                        RequestedServiceManager.sharedInstance.setDealership(dealership: nil)
                        completion?(nil)
                    }
                } else {
                    self.handleDealershipsResponse(dealerships: dealerships)
                    completion?(nil)
                }
            }
        }
    }
    
    private func filterDealershipsForRepairOrder(_ repairOrderTypeId: Int, dealerships: [Dealership], completion: ((_ error: String?) -> ())? = nil) {
        CustomerAPI.dealershipRepairOrder(dealerships: dealerships, repairOrderTypeId: repairOrderTypeId) { dealershipsRO, error in
            
            if error != nil {
                if let completion = completion {
                    completion(.localized(.errorLocationServiceNotOfferedInYourArea))
                }
            } else {
                var error: String? = nil
                if let realm = self.realm {
                    try? realm.write {
                        realm.add(dealershipsRO, update: true)
                    }
                }
                
                if dealershipsRO.count > 0 {
                    var filteredDealership: [Dealership] = []
                    for dealershipRO in dealershipsRO {
                        if !dealershipRO.enabled { continue }
                        for dealership in dealerships {
                            if dealership.enabled && dealershipRO.dealershipId == dealership.id {
                                filteredDealership.append(dealership)
                                break
                            }
                        }
                    }
                    
                    self.handleDealershipsResponse(dealerships: filteredDealership)
                } else {
                    error = .localized(.errorLocationServiceNotOfferedInYourArea)
                }
                if let completion = completion {
                    completion(error)
                }
            }
        }
    }
    
    // From list of dealership, check if offering service
    private func handleDealershipsResponse(dealerships: [Dealership]?) {
        if let dealerships = dealerships {
            self.dealerships = dealerships
            if dealerships.count > 0 {
                
                if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
                    var updateDealership = true
                    if let selectedDealership = RequestedServiceManager.sharedInstance.getDealership() {
                        for dealer in dealerships {
                            if dealer.id == selectedDealership.id {
                                updateDealership = false
                                break
                            }
                        }
                    }
                    if updateDealership {
                        RequestedServiceManager.sharedInstance.setDealership(dealership: dealerships[0])
                        // we updated the dealership we need to show/reset the timeslots
                        RequestedServiceManager.sharedInstance.setPickupTimeSlot(timeSlot: nil)
                        pickupScheduleState = .location
                    }
                }
                if let dealership = RequestedServiceManager.sharedInstance.getDealership() {
                    if let dealershipName = dealership.name {
                        self.dealershipView.setTitle(title: .localized(.dealership), leftDescription: dealershipName, rightDescription: "")
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
        guard let dealerships = dealerships else { return }
        
        let dealershipVC = DealershipViewController(title: .localized(.popupSelectDealershipLabel), buttonTitle: .localized(.next), dealerships: dealerships)
        dealershipVC.delegate = self
        dealershipVC.view.accessibilityIdentifier = "dealershipVC"
        currentPresentrVC = dealershipVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupLocationModal(dismissOnTap: Bool) {
        
        var title: Localized = .popupSelectLocationLabel
        var screen = AnalyticsEnums.Name.Screen.dropoffLocation
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .viewDealershipCloseToLocation
            }
            screen = AnalyticsEnums.Name.Screen.pickupLocation
        }
        
        let locationVC = LocationViewController(title: .localized(title), buttonTitle: .localized(.next), screen: screen)
        locationVC.isModalInPopover = true
        locationVC.pickupLocationDelegate = self
        locationVC.view.accessibilityIdentifier = "locationVC"
        currentPresentrVC = locationVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: nil)
    }
    
    func showPickupLoanerModal(dismissOnTap: Bool) {
        let loanerVC = LoanerViewController(title: .localized(.needALoaner), buttonTitle: .localized(.next), screen: .pickupLoaner)
        loanerVC.delegate = self
        loanerVC.view.accessibilityIdentifier = "loanerVC"
        currentPresentrVC = loanerVC
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showPickupDateTimeModal(dismissOnTap: Bool) {
        
        var title: Localized = .popupSelectTimeSlotLabelPickup
        if !StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            if let type = RequestedServiceManager.sharedInstance.getDropoffRequestType() , type == RequestType.advisorDropoff {
                title = .popupSelectTimeSlotLabelPickup
            } else {
                title = .popupSelectTimeSlotLabelDelivery
            }
        } else {
            if let type = RequestedServiceManager.sharedInstance.getPickupRequestType() , type == RequestType.advisorPickup {
                title = .popupSelectTimeSlotLabelDropoff
            }
        }
        
        let dateModal = DateTimeViewController(vehicle: vehicle, title: .localized(title), buttonTitle: .localized(.next))
        dateModal.delegate = self
        dateModal.view.accessibilityIdentifier = "dateModal"
        currentPresentrVC = dateModal
        currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
        customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: {})
    }
    
    func showDealershipAddress(dealership: Dealership) {
        dealershipAddressView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scheduledServiceView).inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            make.top.equalTo(dealershipView.snp.bottom).offset(-5)
            make.height.equalTo(25)
        }
        
        dealershipMapLabel.snp.makeConstraints { make in
            make.trailing.centerY.height.equalToSuperview()
            make.width.equalTo(60)
        }
        
        dealershipAddressLabel.snp.makeConstraints { make in
            make.leading.height.centerY.equalToSuperview()
            make.trailing.equalTo(dealershipMapLabel.snp.leading)
        }
        
        scheduledPickupView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(scheduledServiceView)
            make.top.equalTo(dealershipAddressView.snp.bottom).offset(10)
            make.height.equalTo(SchedulingViewController.vlLabelHeight)
        }
        
        dealershipAddressView.animateAlpha(show: true)
        dealershipAddressLabel.text = dealership.location?.address
    }
    
    
    func getPickupLocationTitle() -> String {
        var title: String = .localized(.popupSelectLocationLabel)
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .localized(.viewDealershipCloseToLocation)
            }
        }
        return title
    }
    
    func getScheduledPickupTitle() -> String {
        var title: String = .scheduledPickup
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .viewScheduledSelfDrop
            }
        } else {
            title = .scheduledDelivery
        }
        return title
    }
    
    private static func getConfirmButtonTitle(vehicleId: Int) -> String {
        var title: Localized = .viewScheduleServiceOptionConfirmButtonPositivePickup
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicleId) {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .popupAdvisorDropoffSelfDrop
            }
        } else {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .popupAdvisorDropoffSelfPickup
            } else {
                title = .viewScheduleServiceOptionConfirmButtonPositiveDropoff
            }
        }
        return String.localized(title).uppercased()
    }

    func getConfirmButtonEvent() -> AnalyticsEnums.Name.Button {
        var event = AnalyticsEnums.Name.Button.inboundVolvoConfirm
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                event = .inboundSelfConfirm
            }
        } else {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                event = .outboundSelfConfirm
            } else {
                event = .outboundVolvoConfirm
            }
        }
        return event
    }
    
    //MARK: Actions methods
    func showDescriptionClick() {
        if let repairOrder = RequestedServiceManager.sharedInstance.getRepairOrder() {
            let controller = ServiceDetailViewController(vehicle: vehicle, service: repairOrder)
            self.pushViewController(controller, animated: true)
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
    
    func onDealershipSelected(dealership: Dealership?) {
    }
    
    func onDateTimeSelected(timeSlot: DealershipTimeSlot?) {
        
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            RequestedServiceManager.sharedInstance.setPickupTimeSlot(timeSlot: timeSlot)
        } else {
            RequestedServiceManager.sharedInstance.setDropoffTimeSlot(timeSlot: timeSlot)
        }
        
        guard let timeSlot = timeSlot else {
            scheduledPickupView.setTitle(title: getScheduledPickupTitle(), leftDescription: "", rightDescription: "")
            return
        }
        
        let dateTime = formatter.string(from: timeSlot.from!)
        scheduledPickupView.setTitle(title: getScheduledPickupTitle(), leftDescription: "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "")", rightDescription: "")
    }
    
    override func onSizeChanged() {
        // increase size of presenter
        let newHeight = CGFloat(currentPresentrVC!.height())
        let presentationType = getPresenterPresentationType(heightInPixels: newHeight, customYOrigin: BaseViewController.fakeYOrigin)
        currentPresentr?.currentPresentationController?.updateToNewFrame(presentationType: presentationType)
    }
    
    
    func onLocationSelected(customerAddress: CustomerAddress) {
        
        //let locationRequest = RequestLocation(name: responseInfo!.value(forKey: "formattedAddress") as? String, stringLocation: nil, location: placemark?.location?.coordinate)
        let locationRequest = customerAddress.location
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            RequestedServiceManager.sharedInstance.setPickupRequestLocation(requestLocation: locationRequest!)
        } else {
            RequestedServiceManager.sharedInstance.setDropoffRequestLocation(requestLocation: locationRequest!)
        }
        var title: String = .localized(.pickupLocation)
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            if let requestType = RequestedServiceManager.sharedInstance.getPickupRequestType(), requestType == .advisorPickup {
                title = .localized(.viewDealershipCloseToLocation)
            }
        } else {
            title = .localized(.deliveryLocation)
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
                if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
                    RequestedServiceManager.sharedInstance.setPickupTimeSlot(timeSlot: nil)
                } else {
                    RequestedServiceManager.sharedInstance.setDropoffTimeSlot(timeSlot: nil)
                }
                
                // re-select TimeSlot
                openNext = true
                
                self.showConfirmButtonIfNeeded()
            }
        }
        
        loanerView.setLeftDescription(leftDescription: loanerNeeded ? .localized(.yes) : .localized(.no))
        currentPresentrVC?.dismiss(animated: true, completion: {
            if openNext {
                self.scheduledPickupClick()
            }
        })
    }
    
    override func closePresenter() {
        currentPresentrVC?.dismiss(animated: true, completion: nil)
    }
    
    
    override func keyboardWillAppear(_ notification: Notification) {
        super.keyboardWillAppear(notification)
        onSizeChanged()
    }
    
    override func keyboardWillDisappear(_ notification: Notification) {
        super.keyboardWillDisappear(notification)
        onSizeChanged()
    }
}
