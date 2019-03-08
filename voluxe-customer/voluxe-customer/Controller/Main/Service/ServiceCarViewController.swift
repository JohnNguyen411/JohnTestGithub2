//
//  ServiceCarViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SlideMenuControllerSwift
import CoreLocation
import RealmSwift
import Alamofire
import Kingfisher
import MBProgressHUD

class ServiceCarViewController: BaseVehicleViewController, LocationManagerDelegate {
    
    let updateLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = String.localized(.new).uppercased()
        textView.font = .volvoSansProMedium(size: 12)
        textView.textColor = .white
        textView.backgroundColor = .luxeLipstick()
        textView.numberOfLines = 0
        textView.layer.masksToBounds = true
        textView.textAlignment = .center
        textView.layer.cornerRadius = 5
        textView.addUppercasedCharacterSpacing()
        return textView
    }()
    
    let checkupLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .localized(.viewScheduleServiceOptionInfoPickup)
        textView.font = .volvoSansProRegular(size: 14)
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        textView.contentMode = .bottom
        return textView
    }()
    
    var locationManager = LocationManager.sharedInstance
    
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView(frame: .zero)

    let stateTestView = UILabel(frame: .zero)

    let vehicleTypeView = VLTitledLabel(title: .localized(.volvoYearModel), leftDescription: "", rightDescription: "")

    let scheduledServiceView = VLTitledLabel()
    let descriptionButton = VLButton(type: .blueSecondary, title: String.localized(.showDetails).uppercased(), kern: UILabel.uppercasedKern())
    
    let vehicleImageView = UIImageView(frame: .zero)
    
    let selfDropButton = VLButton(type: .grayPrimary, title: String.localized(.viewScheduleServiceOptionPickupSelfDropPickup).uppercased(), kern: UILabel.uppercasedKern())
    let deliveryButton = VLButton(type: .bluePrimary, title: String.localized(.schedulePickup).uppercased(), kern: UILabel.uppercasedKern())
    let confirmButton = VLButton(type: .bluePrimary, title: String.localized(.ok).uppercased(), kern: UILabel.uppercasedKern())

    var screenTitle: String?
    
    //MARK: Lifecycle methods
    init(title: String? = nil, vehicle: Vehicle, state: ServiceState) {
        self.screenTitle = title
        super.init(vehicle: vehicle, state: state, screen: nil)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = self.screenTitle {
            self.navigationItem.title = title
        }
        
        vehicleTypeView.setLeftDescription(leftDescription: vehicle.vehicleDescription())

        vehicleImageView.contentMode = .scaleAspectFit
        
        selfDropButton.setActionBlock { [weak self] in
            self?.selfDropButtonClick()
        }
        deliveryButton.setActionBlock { [weak self] in
            self?.deliveryButtonClick()
        }
        confirmButton.setActionBlock { [weak self] in
            self?.confirmButtonClick()
        }
        
        descriptionButton.setActionBlock { [weak self] in
            self?.showDescriptionClick()
        }
        descriptionButton.contentHorizontalAlignment = .leftOrLeading()
        
        fillViews()
        
        stateDidChange(state: serviceState)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        locationManager.autoUpdate = true
        if locationManager.canUpdateLocation() {
            locationManager.startUpdatingLocation()
        }
        RequestedServiceManager.sharedInstance.resetScheduling()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            RequestedServiceManager.sharedInstance.reset()
        }
    }
    
    //MARK: Views methods
    override func setupViews() {
        super.setupViews()
        deliveryButton.accessibilityIdentifier = "deliveryButton"
        confirmButton.accessibilityIdentifier = "confirmButton"
        
        scrollView.contentMode = .scaleToFill
        
        scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)
        
        contentView.addSubview(stateTestView)
        stateTestView.textColor = .clear
        
        contentView.addSubview(vehicleTypeView)
        contentView.addSubview(vehicleImageView)
        contentView.addSubview(scheduledServiceView)
        contentView.addSubview(descriptionButton)
        contentView.addSubview(checkupLabel)
        contentView.addSubview(updateLabel)

        self.view.addSubview(selfDropButton)
        self.view.addSubview(deliveryButton)
        self.view.addSubview(confirmButton)
        
        updateLabel.isHidden = true
        
        let margin = ViewUtils.getAdaptedHeightSize(sizeInPoints: 20)

        scrollView.snp.makeConstraints { make in
            make.equalsToTop(view: self.view, offset: ViewUtils.getAdaptedHeightSize(sizeInPoints: BaseViewController.defaultTopYOffset))
            make.leading.equalToSuperview().inset(margin)
            make.trailing.equalToSuperview().inset(margin)
            make.bottom.equalTo(deliveryButton.snp.top).offset(-margin)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(deliveryButton.snp.top).offset(-margin)
        }
        
        vehicleTypeView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLTitledLabel.height)))
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(vehicleTypeView.snp.bottom)
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: Vehicle.vehicleImageHeight))
        }
        
        checkupLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
        }
        
        scheduledServiceView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLTitledLabel.height)))
        }
        
        updateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(scheduledServiceView).offset(-3)
            make.width.greaterThanOrEqualTo(45)
            make.height.equalTo(20)
        }
        
        descriptionButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(scheduledServiceView)
            make.top.equalTo(scheduledServiceView.snp.bottom)
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        if !ServiceState.isPickup(state: serviceState) {
            
            if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.selfOBEnabledKey) {
                selfDropButton.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(margin)
                    make.trailing.equalToSuperview().inset(margin)
                    make.equalsToBottom(view: self.view, offset: -margin)
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
                }
                
                deliveryButton.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(margin)
                    make.trailing.equalToSuperview().inset(margin)
                    make.bottom.equalTo(selfDropButton.snp.top).offset(-margin)
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
                }
            } else {
                deliveryButton.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(margin)
                    make.trailing.equalToSuperview().inset(margin)
                    make.equalsToBottom(view: self.view, offset: -margin)
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
                }
                selfDropButton.isHidden = true
            }
            
        } else {
            deliveryButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(margin)
                make.trailing.equalToSuperview().inset(margin)
                make.equalsToBottom(view: self.view, offset: -margin)
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
            }
        }
        
        
        confirmButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(margin)
            make.trailing.equalToSuperview().inset(margin)
            make.equalsToBottom(view: self.view, offset: -margin)
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
        }
        
        stateTestView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
            make.height.width.equalTo(1)
        }
        
    }
    
    private func updateButtonsConstraints() {
        let margin = ViewUtils.getAdaptedHeightSize(sizeInPoints: 20)

        if !ServiceState.isPickup(state: serviceState) {
            if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.selfOBEnabledKey) {
                
                selfDropButton.snp.remakeConstraints { make in
                    make.leading.equalToSuperview().inset(margin)
                    make.trailing.equalToSuperview().inset(margin)
                    make.equalsToBottom(view: self.view, offset: -margin)
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
                }
                
                deliveryButton.snp.remakeConstraints { make in
                    make.leading.equalToSuperview().inset(margin)
                    make.trailing.equalToSuperview().inset(margin)
                    make.bottom.equalTo(selfDropButton.snp.top).offset(-margin)
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
                }
            } else {
                deliveryButton.snp.remakeConstraints { make in
                    make.leading.equalToSuperview().inset(margin)
                    make.trailing.equalToSuperview().inset(margin)
                    make.equalsToBottom(view: self.view, offset: -margin)
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
                }
            }
            
        } else {
            deliveryButton.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(margin)
                make.trailing.equalToSuperview().inset(margin)
                make.equalsToBottom(view: self.view, offset: -margin)
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
            }
        }
    }
    
    func fillViews() {
        
        vehicle.setVehicleImage(imageView: vehicleImageView)
        
        if let service = RequestedServiceManager.sharedInstance.getRepairOrder() {
            var title = String.localized(.recommendedService)
            if RequestedServiceManager.sharedInstance.isSelfInitiated() {
                title = .localized(.selectedService)
                showUpdateLabel(show: false, title: String.localized(.new).uppercased(), width: 40, right: true)
            } else {
                showUpdateLabel(show: true, title: String.localized(.new).uppercased(), width: 40, right: true)
            }
            scheduledServiceView.setTitle(title: title, leftDescription: service.getTitle(), rightDescription: "")
        }
    }

    override func logViewScreen() {
        super.logViewScreen()
        self.descriptionButton.setEvent(name: .showService, screen: screenAnalyticsEnum(state: serviceState))
        self.confirmButton.setEvent(name: .ok, screen: screenAnalyticsEnum(state: serviceState))
    }
    
    func showVehicleImage(show: Bool, alpha: Bool, animated: Bool) {
        self.vehicleImageView.changeVisibility(show: show, alpha: alpha, animated: animated, height: Vehicle.vehicleImageHeight)
    }
    
    
    private func screenAnalyticsEnum(state: ServiceState) -> AnalyticsEnums.Name.Screen {
        if state == .needService {
            return .needService
        } else if state == .serviceCompleted {
            return .serviceCompleted
        } else if state == .service {
            return .serviceInProgress
        } else if state == .enRouteForService {
            return .serviceEnRoute
        } else if state == .completed {
            return .bookingCompleted
        }
        return .needService
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        self.serviceState = state
        
        updateButtonsConstraints()
        
        stateTestView.accessibilityIdentifier = "schedulingTestView\(state)"
        stateTestView.text = "schedulingTestView\(state)"
        
        confirmButton.isHidden = true
        
        Analytics.trackView(screen: screenAnalyticsEnum(state: state))

        if state == .needService || state == .serviceCompleted {
            
            scheduledServiceView.isHidden = false
            descriptionButton.isHidden = false
            
            if state == .needService {
                dealershipPrefetching()
                self.updateLabelText(text: .localized(.viewScheduleServiceOptionInfoPickup))
            } else {
                self.updateLabelText(text: .localized(.viewScheduleServiceOptionInfoSelfDropoff))
               
//                showUpdateLabel(show: true, title: (.New as String).uppercased(), width: 40, right: true)
                if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                    scheduledServiceView.setTitle(title: .localized(.completedService), leftDescription: booking.getRepairOrderName(), rightDescription: "")
                }
            }
            
            let checkupLabelHeight = checkupLabel.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat(MAXFLOAT))).height

            let descriptionBottom = descriptionButton.frame.origin.y + descriptionButton.frame.size.height
            if descriptionButton.frame.origin.y > 0 && descriptionBottom + checkupLabelHeight + 20 >= scrollView.frame.size.height {
                
                checkupLabel.snp.remakeConstraints { make in
                    make.leading.trailing.equalToSuperview()
                    make.top.equalTo(descriptionButton.snp.bottom).offset(20)
                }
                
                let contentViewHeight = descriptionBottom + 20 + checkupLabelHeight
                
                contentView.snp.remakeConstraints { make in
                    make.edges.equalTo(scrollView)
                    make.width.equalTo(scrollView)
                    make.height.equalTo(contentViewHeight)
                }
                
                
            } else {
                contentView.snp.makeConstraints { make in
                    make.bottom.equalToSuperview()
                }
                
                checkupLabel.snp.remakeConstraints { make in
                    make.leading.bottom.trailing.equalToSuperview()
                }
            }
            
            selfDropButton.animateAlpha(show: true)
            deliveryButton.animateAlpha(show: true)
            confirmButton.animateAlpha(show: false)
        } else {
            
            var dealership = RequestedServiceManager.sharedInstance.getDealership()
            if dealership == nil, let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                dealership = booking.dealership
            }
            scheduledServiceView.isHidden = true
            descriptionButton.isHidden = true
            
            checkupLabel.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(vehicleImageView.snp.bottom).offset(50)
            }
            
//            showUpdateLabel(show: true, title: (.New as String).uppercased(), width: 40, right: false)

            if state == .service {
                self.updateLabelText(text: String(format: .localized(.viewScheduleServiceStatusInServiceInfo), (dealership?.name)!))
                selfDropButton.isHidden = true
                deliveryButton.isHidden = true

            } else if state == .enRouteForService {
                confirmButton.isHidden = true
                selfDropButton.isHidden = true
                deliveryButton.isHidden = true
                
                self.updateLabelText(text: String(format: .localized(.viewScheduleServiceStatusAtDealershipInfo), (dealership?.name)!))
                
            } else if state == .completed {
                confirmButton.isHidden = false
                selfDropButton.isHidden = true
                deliveryButton.isHidden = true
                
                self.updateLabelText(text: String(format: .localized(.viewScheduleServiceStatusComplete), (dealership?.name)!))
            }
        }
        
        
        if ServiceState.isPickup(state: state) {

            self.selfDropButton.setEvent(name: .inboundSelf, screen: screenAnalyticsEnum(state: state))
            self.deliveryButton.setEvent(name: .inboundVolvo, screen: screenAnalyticsEnum(state: state))
            
            selfDropButton.setTitle(title: String.localized(.viewScheduleServiceOptionPickupSelfDropPickup).uppercased())
            deliveryButton.setTitle(title: String.localized(.schedulePickup).uppercased())

        } else {
            selfDropButton.setTitle(title: String.localized(.viewScheduleServiceOptionPickupSelfDeliveryDropoff).uppercased())
            deliveryButton.setTitle(title: String.localized(.scheduleDelivery).uppercased())
            self.selfDropButton.setEvent(name: .outboundSelf, screen: screenAnalyticsEnum(state: state))
            self.deliveryButton.setEvent(name: .outboundVolvo, screen: screenAnalyticsEnum(state: state))
        }
    }
    
    private func showUpdateLabel(show: Bool, title: String?, width: Int, right: Bool) {
        
        updateLabel.isHidden = !show
        updateLabel.text = title
        
        if right {
            updateLabel.snp.remakeConstraints { make in
                make.trailing.equalToSuperview()
                make.top.equalTo(scheduledServiceView).offset(-3)
                make.width.greaterThanOrEqualTo(width)
                make.height.equalTo(20)
            }
        } else {
            updateLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.bottom.equalTo(checkupLabel.snp.top).offset(-10)
                make.width.greaterThanOrEqualTo(width)
                make.height.equalTo(20)
            }
        }
    }
    
    //MARK: Actions methods
    func showDescriptionClick() {
        if let repairOrder = RequestedServiceManager.sharedInstance.getRepairOrder() {
            self.pushViewController(ServiceDetailViewController(vehicle: vehicle, service: repairOrder), animated: true)
        } else if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle), booking.repairOrderRequests.count > 0 {
            self.pushViewController(ServiceDetailViewController(vehicle: vehicle, service: booking.repairOrderRequests[0]), animated: true, backBarButtonTitle: .localized(.back))
        }
    }
    
    func selfDropButtonClick() {
        
        // show confirmation dialog
        
        self.showDialog(title: .localized(.viewScheduleServiceOptionPickupSelfDeliveryDropoff),
                        message: .localized(.popupAdvisorDropoffMessage),
                        cancelButtonTitle: .localized(.no),
                        okButtonTitle: .localized(.yes),
                        okCompletion: {
            if StateServiceManager.sharedInstance.isPickup(vehicleId: self.vehicle.id) {
                RequestedServiceManager.sharedInstance.setPickupRequestType(requestType: .advisorPickup)
                self.pushViewController(SchedulingPickupViewController(vehicle: self.vehicle, state: .schedulingService), animated: true)
            } else {
                if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: self.vehicle) {
                    RequestedServiceManager.sharedInstance.setDropOffRequestType(requestType: .advisorDropoff)
                    
                    self.showProgressHUD()
                    
                    CustomerAPI.createDropoffRequest(customerId: booking.customerId, bookingId: booking.id, timeSlotId: nil, location: nil, isDriver: false) { request, error in
                        if let dropOffRequest = request {
                            self.manageNewDropoffRequest(dropOffRequest: dropOffRequest, booking: booking)
                            self.refreshFinalBooking(customerId: booking.customerId, bookingId: booking.id)
                        } else if error != nil {
                            self.hideProgressHUD()
                            self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown))
                        }
                    }
                }
            }
        })
    }
    
    
    func deliveryButtonClick() {
        if StateServiceManager.sharedInstance.isPickup(vehicleId: vehicle.id) {
            RequestedServiceManager.sharedInstance.setPickupRequestType(requestType: .driverPickup)
            self.pushViewController(SchedulingPickupViewController(vehicle: vehicle, state: .schedulingService), animated: true)
        } else {
            if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                RequestedServiceManager.sharedInstance.setDropOffRequestType(requestType: .driverDropoff)
                self.pushViewController(SchedulingDropoffViewController(state: .schedulingDelivery, booking: booking), animated: true)
            }
        }
    }
    
    func confirmButtonClick() {
        if StateServiceManager.sharedInstance.getState(vehicleId: vehicle.id) == .completed {
            // start over
            RequestedServiceManager.sharedInstance.reset()
            AppController.sharedInstance.showLoadingView()
        }
    }
    
    
    func updateLabelText(text: String) {
        checkupLabel.text = text
        checkupLabel.volvoProLineSpacing()
    }
    
    //MARK: Prefetching methods
    
    func dealershipPrefetching() {
        if locationManager.canUpdateLocation() && locationManager.lastKnownLatitude != 0 && locationManager.lastKnownLongitude != 0 && locationManager.hasLastKnownLocation {
            CustomerAPI.dealerships(location: CLLocationCoordinate2DMake(locationManager.lastKnownLatitude, locationManager.lastKnownLongitude)) { dealerships, error in
                self.saveDealerships(dealerships: dealerships)
            }
        } else {
            CustomerAPI.dealerships() { dealerships, error in
                self.saveDealerships(dealerships: dealerships)
            }
        }
    }
    
    func saveDealerships(dealerships: [Dealership]) {
        if dealerships.count > 0 {
            if let realm = try? Realm() {
                try? realm.write {
                    realm.add(dealerships, update: true)
                }
            }
        }
    }
    
    private func manageNewDropoffRequest(dropOffRequest: Request, booking: Booking) {
        
        if let realm = try? Realm() {
            try? realm.write {
                realm.add(dropOffRequest, update: true)
            }
            let realmDropOffRequest = realm.objects(Request.self, "id == %@", dropOffRequest.id).first
            
            if let booking = realm.objects(Booking.self, "id == %@", booking.id).first {
                
                try? realm.write {
                    // update state to scheduled dropoff
                    booking.state = State.dropoffScheduled.rawValue
                    booking.dropoffRequest = realmDropOffRequest
                    realm.add(booking, update: true)
                }
            }
        }
    }
    
    private func refreshFinalBooking(customerId: Int, bookingId: Int) {
        CustomerAPI.booking(customerId: customerId, bookingId: bookingId) { booking, error in
            self.hideProgressHUD()
            
            if error != nil {
                self.showDialog(title: .localized(.error), message: .localized(.errorUnknown), buttonTitle: .localized(.retry), completion: {
                    self.refreshFinalBooking(customerId: customerId, bookingId: bookingId)
                }, dialog: .error, screen: self.screenAnalyticsEnum(state: self.serviceState))
            } else {
                
                if let booking = booking {
                    if let realm = try? Realm() {
                        try? realm.write {
                            realm.add(booking, update: true)
                        }
                    }
                }
                
                if let realm = try? Realm() {
                    let bookings = realm.objects(Booking.self, "customerId == %@", customerId)
                    UserManager.sharedInstance.setBookings(bookings: Array(bookings))
                }
                
                RequestedServiceManager.sharedInstance.reset()
                AppController.sharedInstance.showVehiclesView(animated: false)
                
            }
        }
    }
    
    
    //MARK: LocationDelegate methods
    
    func locationFound(_ latitude: Double, longitude: Double) {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        stateDidChange(state: serviceState)
    }
}
