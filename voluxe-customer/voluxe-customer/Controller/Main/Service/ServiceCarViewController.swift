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
import BrightFutures
import Alamofire
import Kingfisher
import MBProgressHUD

class ServiceCarViewController: BaseVehicleViewController, LocationManagerDelegate {
    
    let updateLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = (.New as String).uppercased()
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
        textView.text = .ScheduleDropDealership
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

    let vehicleTypeView = VLTitledLabel(title: .VolvoYearModel, leftDescription: "", rightDescription: "")

    let scheduledServiceView = VLTitledLabel()
    let descriptionButton = VLButton(type: .blueSecondary, title: (.ShowDetails as String).uppercased(), kern: UILabel.uppercasedKern())
    
    let vehicleImageView = UIImageView(frame: .zero)
    
    let selfDropButton = VLButton(type: .grayPrimary, title: (.SelfDrop as String).uppercased(), kern: UILabel.uppercasedKern())
    let deliveryButton = VLButton(type: .bluePrimary, title: (.SchedulePickup as String).uppercased(), kern: UILabel.uppercasedKern())
    let confirmButton = VLButton(type: .bluePrimary, title: (.Ok as String).uppercased(), kern: UILabel.uppercasedKern())

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
        descriptionButton.contentHorizontalAlignment = .left
        
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
            make.left.equalToSuperview().inset(margin)
            make.right.equalToSuperview().inset(margin)
            make.bottom.equalTo(deliveryButton.snp.top).offset(-margin)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(deliveryButton.snp.top).offset(-margin)
        }
        
        vehicleTypeView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLTitledLabel.height)))
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleTypeView.snp.bottom)
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: Vehicle.vehicleImageHeight))
        }
        
        checkupLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
        }
        
        scheduledServiceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLTitledLabel.height)))
        }
        
        updateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(scheduledServiceView).offset(-3)
            make.width.greaterThanOrEqualTo(45)
            make.height.equalTo(20)
        }
        
        descriptionButton.snp.makeConstraints { make in
            make.left.right.equalTo(scheduledServiceView)
            make.top.equalTo(scheduledServiceView.snp.bottom)
            make.height.equalTo(VLButton.secondaryHeight)
        }
        
        if !ServiceState.isPickup(state: serviceState) {
            
            if RemoteConfigManager.sharedInstance.getBoolValue(key: RemoteConfigManager.selfOBEnabledKey) {
                selfDropButton.snp.makeConstraints { make in
                    make.left.equalToSuperview().inset(margin)
                    make.right.equalToSuperview().inset(margin)
                    make.equalsToBottom(view: self.view, offset: -margin)
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
                }
                
                deliveryButton.snp.makeConstraints { make in
                    make.left.equalToSuperview().inset(margin)
                    make.right.equalToSuperview().inset(margin)
                    make.bottom.equalTo(selfDropButton.snp.top).offset(-margin)
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
                }
            } else {
                deliveryButton.snp.makeConstraints { make in
                    make.left.equalToSuperview().inset(margin)
                    make.right.equalToSuperview().inset(margin)
                    make.equalsToBottom(view: self.view, offset: -margin)
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
                }
                selfDropButton.isHidden = true
            }
            
            
        } else {
            deliveryButton.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(margin)
                make.right.equalToSuperview().inset(margin)
                make.equalsToBottom(view: self.view, offset: -margin)
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
            }
        }
        
        
        confirmButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(margin)
            make.right.equalToSuperview().inset(margin)
            make.equalsToBottom(view: self.view, offset: -margin)
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
        }
        
        stateTestView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(confirmButton.snp.top)
            make.height.width.equalTo(1)
        }
        
    }
    
    func fillViews() {
        
        vehicle.setVehicleImage(imageView: vehicleImageView)
        
        if let service = RequestedServiceManager.sharedInstance.getRepairOrder() {
            var title = String.RecommendedService
            if RequestedServiceManager.sharedInstance.isSelfInitiated() {
                title = .SelectedService
                showUpdateLabel(show: false, title: String.New.uppercased(), width: 40, right: true)
            } else {
                showUpdateLabel(show: true, title: String.New.uppercased(), width: 40, right: true)
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
        
        stateTestView.accessibilityIdentifier = "schedulingTestView\(state)"
        stateTestView.text = "schedulingTestView\(state)"
        
        confirmButton.isHidden = true
        
        Analytics.trackView(screen: screenAnalyticsEnum(state: state))

        if state == .needService || state == .serviceCompleted {
            
            scheduledServiceView.isHidden = false
            descriptionButton.isHidden = false
            
            if state == .needService {
                dealershipPrefetching()
                self.updateLabelText(text: .ScheduleDropDealership)
            } else {
                self.updateLabelText(text: .SchedulePickupDealershipSelfEnabled)
               
//                showUpdateLabel(show: true, title: (.New as String).uppercased(), width: 40, right: true)
                if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
                    scheduledServiceView.setTitle(title: String.CompletedService, leftDescription: booking.getRepairOrderName(), rightDescription: "")
                }
            }
            
            let checkupLabelHeight = checkupLabel.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat(MAXFLOAT))).height

            let descriptionBottom = descriptionButton.frame.origin.y + descriptionButton.frame.size.height
            if descriptionButton.frame.origin.y > 0 && descriptionBottom + checkupLabelHeight + 20 >= scrollView.frame.size.height {
                
                checkupLabel.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
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
                    make.left.bottom.right.equalToSuperview()
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
                make.left.right.equalToSuperview()
                make.top.equalTo(vehicleImageView.snp.bottom).offset(50)
            }
            
//            showUpdateLabel(show: true, title: (.New as String).uppercased(), width: 40, right: false)

            if state == .service {
                self.updateLabelText(text: String(format: NSLocalizedString(.VolvoCurrentlyServicing), (dealership?.name)!))
                selfDropButton.isHidden = true
                deliveryButton.isHidden = true

            } else if state == .enRouteForService {
                confirmButton.isHidden = true
                selfDropButton.isHidden = true
                deliveryButton.isHidden = true
                
                self.updateLabelText(text: String(format: NSLocalizedString(.DriverDrivingToDealership), (dealership?.name)!))
                
            } else if state == .completed {
                confirmButton.isHidden = false
                selfDropButton.isHidden = true
                deliveryButton.isHidden = true
                
                self.updateLabelText(text: String(format: NSLocalizedString(.DeliveryComplete), (dealership?.name)!))
            }
        }
        
        
        if ServiceState.isPickup(state: state) {

            self.selfDropButton.setEvent(name: .inboundSelf, screen: screenAnalyticsEnum(state: state))
            self.deliveryButton.setEvent(name: .inboundVolvo, screen: screenAnalyticsEnum(state: state))
            
            selfDropButton.setTitle(title: (.SelfDrop as String).uppercased())
            deliveryButton.setTitle(title: (.SchedulePickup as String).uppercased())

        } else {
            selfDropButton.setTitle(title: (.SelfPickupAtDealership as String).uppercased())
            deliveryButton.setTitle(title: (.ScheduleDelivery as String).uppercased())
            self.selfDropButton.setEvent(name: .outboundSelf, screen: screenAnalyticsEnum(state: state))
            self.deliveryButton.setEvent(name: .outboundVolvo, screen: screenAnalyticsEnum(state: state))
        }
    }
    
    private func showUpdateLabel(show: Bool, title: String?, width: Int, right: Bool) {
        
        updateLabel.isHidden = !show
        updateLabel.text = title
        
        if right {
            updateLabel.snp.remakeConstraints { make in
                make.right.equalToSuperview()
                make.top.equalTo(scheduledServiceView).offset(-3)
                make.width.greaterThanOrEqualTo(width)
                make.height.equalTo(20)
            }
        } else {
            updateLabel.snp.remakeConstraints { make in
                make.left.equalToSuperview()
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
            self.pushViewController(ServiceDetailViewController(vehicle: vehicle, service: booking.repairOrderRequests[0]), animated: true, backBarButtonTitle: .Back)
        }
    }
    
    func selfDropButtonClick() {
        
        // show confirmation dialog
        
        self.showDialog(title: .SelfPickupAtDealership, message: .AreYouSureSelfPickup, cancelButtonTitle: .No, okButtonTitle: .Yes, okCompletion: {
            if StateServiceManager.sharedInstance.isPickup(vehicleId: self.vehicle.id) {
                RequestedServiceManager.sharedInstance.setPickupRequestType(requestType: .advisorPickup)
                self.pushViewController(SchedulingPickupViewController(vehicle: self.vehicle, state: .schedulingService), animated: true)
            } else {
                if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: self.vehicle) {
                    RequestedServiceManager.sharedInstance.setDropOffRequestType(requestType: .advisorDropoff)
                    
                    self.showProgressHUD()
                    
                    BookingAPI().createDropoffRequest(customerId: booking.customerId, bookingId: booking.id, timeSlotId: nil, location: nil, isDriver: false).onSuccess { result in
                        if let dropOffRequest = result?.data?.result {
                            self.manageNewDropoffRequest(dropOffRequest: dropOffRequest, booking: booking)
                            self.refreshFinalBooking(customerId: booking.customerId, bookingId: booking.id)
                        }
                        }.onFailure { error in
                            self.hideProgressHUD()
                            self.showOkDialog(title: .Error, message: .GenericError)
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
            DealershipAPI().getDealerships(location: CLLocationCoordinate2DMake(locationManager.lastKnownLatitude, locationManager.lastKnownLongitude)).onSuccess { result in
                
                self.saveDealerships(result: result)
                
                }.onFailure { error in
            }
        } else {
            DealershipAPI().getDealerships().onSuccess { result in
                
                self.saveDealerships(result: result)
                
                }.onFailure { error in
            }
        }
    }
    
    func saveDealerships(result: ResponseObject<MappableDataArray<Dealership>>?) {
        if let dealerships = result?.data?.result, dealerships.count > 0 {
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
            let realmDropOffRequest = realm.objects(Request.self).filter("id = \(dropOffRequest.id)").first
            
            if let booking = realm.objects(Booking.self).filter("id = \(booking.id)").first {
                
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
        BookingAPI().getBooking(customerId: customerId, bookingId: bookingId).onSuccess { result in
            if let booking = result?.data?.result {
                if let realm = try? Realm() {
                    try? realm.write {
                        realm.add(booking, update: true)
                    }
                }
            }
            
            if let realm = try? Realm() {
                let bookings = realm.objects(Booking.self).filter("customerId = \(customerId)")
                UserManager.sharedInstance.setBookings(bookings: Array(bookings))
            }
            
            RequestedServiceManager.sharedInstance.reset()
            AppController.sharedInstance.showVehiclesView(animated: false)
            
            self.hideProgressHUD()
            
            }.onFailure { error in
                // retry
                self.hideProgressHUD()
                self.showDialog(title: .Error, message: .GenericError, buttonTitle: .Retry, completion: {
                    self.refreshFinalBooking(customerId: customerId, bookingId: bookingId)
                }, dialog: .error, screen: self.screenAnalyticsEnum(state: self.serviceState))
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
