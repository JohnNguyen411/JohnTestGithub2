//
//  VehiclesViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 1/31/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import CoreLocation
import RealmSwift
import BrightFutures
import Alamofire
import SwiftEventBus


class VehiclesViewController: BaseViewController, ScheduledBookingDelegate {

    public static var selectedVehicleIndex = 0

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
    
    var serviceState: ServiceState
    var vehicles: [Vehicle]?
    var selectedVehicle: Vehicle?
    var vehicleCount = 0

    let scrollView = VLScrollView()
    let vehicleCollectionView: UICollectionView
    let vehicleTypeView = VLTitledLabel(title: .VolvoYearModel, leftDescription: "", rightDescription: "")
    let vehicleImageView = UIImageView(frame: .zero)
    let preferedDealershipView = VLTitledLabel(title: .Dealership, leftDescription: "", rightDescription: "")
    let scheduledServiceView = VLTitledLabel()
    let contentView = UIView(frame: .zero)
    let confirmButton: VLButton
    let dealershipLocationButton: VLButton


    //MARK: Lifecycle methods
    init(state: ServiceState) {
        self.serviceState = state
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: VehicleCell.VehicleCellHeight, height: VehicleCell.VehicleCellHeight)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        vehicleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vehicleCollectionView.backgroundColor = UIColor.clear
        vehicleCollectionView.setCollectionViewLayout(layout, animated: false)
        
        dealershipLocationButton = VLButton(type: .blueSecondary, title: String.ViewDealershipLocation.uppercased(), kern: UILabel.uppercasedKern(), event: .viewDealershipLocation, screen: .vehicles)
        confirmButton = VLButton(type: .bluePrimary, title: (.NewService as String).uppercased(), kern: UILabel.uppercasedKern(), event: .newService, screen: .vehicles)
        
        super.init(screen: .vehicles)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // init tap events
        scheduledServiceView.isUserInteractionEnabled = true
        let scheduledServiceTap = UITapGestureRecognizer(target: self, action: #selector(self.scheduledServiceClick))
        scheduledServiceView.addGestureRecognizer(scheduledServiceTap)
        scheduledServiceView.isEditable = true
        
        vehicleImageView.contentMode = .scaleAspectFit
        
        dealershipLocationButton.setActionBlock { [weak self] in
            self?.dealershipLocationClick()
        }
        
        confirmButton.setActionBlock { [weak self] in
            self?.confirmButtonClick()
        }
        
        vehicleCollectionView.register(VehicleCell.self, forCellWithReuseIdentifier: VehicleCell.reuseId)

        vehicleCollectionView.delegate = self
        vehicleCollectionView.dataSource = self
        vehicleCollectionView.showsVerticalScrollIndicator = false
        vehicleCollectionView.showsHorizontalScrollIndicator = false
        
        SwiftEventBus.onMainThread(self, name:"stateDidChange") {
            result in
            guard let stateChange: StateChangeObject = result?.object as? StateChangeObject else { return }
            self.stateDidChange(vehicleId: stateChange.vehicleId, oldState: stateChange.oldState, newState: stateChange.newState)
        }
    }
    
    deinit {
        SwiftEventBus.unregister(self)
    }
    
    func stateDidChange(vehicleId: Int, oldState: ServiceState?, newState: ServiceState) {
        guard let vehicle = selectedVehicle else { return }
        if vehicleId != vehicle.id {
            return
        }
        
        if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle), booking.isActive() {
            AppController.sharedInstance.loadViewForVehicle(vehicle: vehicle, state: newState)
            return
        }
        
        stateDidChange(state: newState)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationBarItem()
        super.viewDidAppear(animated)
        
        showVehicles(vehicles: UserManager.sharedInstance.getVehicles()!)
        stateDidChange(state: serviceState)
        
        // animate alpha at the first load
        self.contentView.animateAlpha(show: true)
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        dealershipLocationButton.isHidden = true
        
        self.contentView.alpha = 0
        self.view.addSubview(contentView)
        
        confirmButton.accessibilityLabel = "confirmButton"
        
        vehicleCollectionView.clipsToBounds = false
        contentView.addSubview(vehicleCollectionView)
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(vehicleTypeView)
        scrollView.addSubview(vehicleImageView)
        scrollView.addSubview(preferedDealershipView)
        scrollView.addSubview(scheduledServiceView)
        scrollView.addSubview(dealershipLocationButton)
        scrollView.addSubview(confirmButton)
        
        contentView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self.view, edges: UIEdgeInsetsMake(10, 20, 20, 20))
        }
        
        vehicleCollectionView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(VehicleCell.VehicleCellHeight)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(vehicleCollectionView.snp.bottom).offset(20)
        }
        
        vehicleTypeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(VLTitledLabel.height)
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleTypeView.snp.bottom)
            make.height.equalTo(Vehicle.vehicleImageHeight)
        }
        
        scheduledServiceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        dealershipLocationButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(scheduledServiceView.snp.bottom).offset(20)
        }
        
        preferedDealershipView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(scheduledServiceView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.viewDidLayoutSubviews()
        
        preferedDealershipView.layoutIfNeeded()
        confirmButton.layoutIfNeeded()
        scrollView.contentView.setNeedsLayout()
        scrollView.contentView.layoutIfNeeded()

        var contentHeight: CGFloat = 0.0
        if !preferedDealershipView.isHidden {
            contentHeight = preferedDealershipView.frame.origin.y + preferedDealershipView.frame.size.height
        } else if let scrollViewSize = scrollView.scrollViewSize, !confirmButton.isHidden {
            contentHeight = scrollViewSize.height
        }
        
        scrollView.contentView.frame = CGRect(x: scrollView.contentView.frame.origin.x, y: scrollView.contentView.frame.origin.y, width: scrollView.contentView.frame.size.width, height: contentHeight)
        scrollView.contentSize = CGSize(width: scrollView.contentView.frame.width, height: scrollView.contentView.frame.height)
    }
    
    
    func showVehicles(vehicles: [Vehicle]) {
        self.vehicles = vehicles
        if vehicles.count > 1 {
            vehicleCollectionView.snp.updateConstraints { make in
                make.height.equalTo(VehicleCell.VehicleCellHeight)
            }
        } else {
            vehicleCollectionView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        
        if vehicles.count != vehicleCount {
            vehicleCollectionView.setNeedsLayout()
        }
        
        DispatchQueue.main.async {
            self.vehicleCollectionView.reloadData()
            self.selectVehicle(index: VehiclesViewController.selectedVehicleIndex)
        }
        
        vehicleCount = vehicles.count
    }
    
    func selectVehicle(index: Int) {
        if let vehicles = vehicles {
            VehiclesViewController.selectedVehicleIndex = index
            if index < vehicles.count {
                let vehicle = vehicles[index]
                vehicleTypeView.setLeftDescription(leftDescription: vehicle.vehicleDescription())
                vehicle.setVehicleImage(imageView: vehicleImageView)
                selectedVehicle = vehicle
                stateDidChange(state: serviceState)
                vehicleCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            } else if vehicles.count > 0 {
                selectVehicle(index: 0)
            }
        }
    }
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        // check if service scheduled
        self.serviceState = state
        if let selectedVehicle = selectedVehicle, let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: selectedVehicle), !booking.isInvalidated, booking.getState() != .canceled {
            scheduledServiceView.snp.updateConstraints { make in
                make.height.equalTo(VLTitledLabel.height)
            }
            scheduledServiceView.isHidden = false
            confirmButton.animateAlpha(show: false)
            
            var location: String? = nil
            
            if ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                if !booking.isSelfIB() && booking.getState() == .pickupScheduled, let request = booking.pickupRequest, let timeSlot = request.timeSlot, let date = timeSlot.from {
                    let dateTime = formatter.string(from: date)
                    scheduledServiceView.setTitle(title: .ScheduledPickup, leftDescription: "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" )", rightDescription: "")
                    dealershipLocationButton.isHidden = true
                    scheduledServiceView.isEditable = true
                } else {
                    scheduledServiceView.setTitle(title: .ScheduledService, leftDescription: booking.getRepairOrderName())
                    dealershipLocationButton.isHidden = false
                    scheduledServiceView.isEditable = false
                }
                if let request = booking.pickupRequest, let requestLocation = request.location {
                    location = requestLocation.getMediumAddress()
                }
            } else {
                if booking.isSelfOB() {
                    scheduledServiceView.setTitle(title: .CompletedService, leftDescription: booking.getRepairOrderName())
                    scheduledServiceView.isEditable = false
                    dealershipLocationButton.isHidden = false
                } else {
                    scheduledServiceView.isEditable = true
                    dealershipLocationButton.isHidden = true
                    if let request = booking.dropoffRequest, let timeSlot = request.timeSlot, let date = timeSlot.from {
                        let dateTime = formatter.string(from: date)
                        scheduledServiceView.setTitle(title: .ScheduledDelivery, leftDescription: "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" )", rightDescription: "")
                    } else {
                        if booking.getState() == .service {
                            scheduledServiceView.setTitle(title: .CurrentService, leftDescription: booking.getRepairOrderName())
                        } else {
                            scheduledServiceView.setTitle(title: .CompletedService, leftDescription: booking.getRepairOrderName())
                        }
                    }
                    if let request = booking.dropoffRequest, let requestLocation = request.location {
                        location = requestLocation.getMediumAddress()
                    }
                }
            }
            
            
            if booking.isSelfOB() || (ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) && booking.isSelfIB()) {
                preferedDealershipView.isHidden = true
            } else {
                if let location = location {
                    preferedDealershipView.isHidden = false
                    if ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                        preferedDealershipView.setTitle(title: .PickupLocation, leftDescription: location)
                    } else {
                        preferedDealershipView.setTitle(title: .DeliveryLocation, leftDescription: location)
                    }
                } else {
                    if let dealership = booking.dealership {
                        preferedDealershipView.isHidden = false
                        preferedDealershipView.setTitle(title: .Dealership, leftDescription: dealership.name!)
                    }
                }
            }
        } else {
            scheduledServiceView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            scheduledServiceView.isHidden = true
            preferedDealershipView.isHidden = true
            dealershipLocationButton.isHidden = true
            confirmButton.animateAlpha(show: true)
        }
        
    }
    
    //MARK: Actions methods
    func confirmButtonClick() {
        if let selectedVehicle = selectedVehicle {
            RequestedServiceManager.sharedInstance.reset()
            self.pushViewController(NewServiceViewController(vehicle: selectedVehicle), animated: true)
        }
    }
    
    
    @objc func scheduledServiceClick() {
        if let selectedVehicle = selectedVehicle, let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: selectedVehicle) {
            if booking.isSelfOB() {
                return
            }
            // if booking is today, show upcoming request with map
            if booking.hasUpcomingRequestToday() || (booking.getState() == .service || booking.getState() == .serviceCompleted) {
                AppController.sharedInstance.loadViewForVehicle(vehicle: selectedVehicle, state: StateServiceManager.sharedInstance.getState(vehicleId: selectedVehicle.id))
            } else {
                let controller = ScheduledBookingViewController(booking: booking, delegate: self)
                self.pushViewController(controller, animated: true)
            }
        }
    }
    
    @objc func dealershipLocationClick() {
        if let selectedVehicle = selectedVehicle {
            AppController.sharedInstance.loadViewForVehicle(vehicle: selectedVehicle, state: StateServiceManager.sharedInstance.getState(vehicleId: selectedVehicle.id))
        }
    }
    
    func onCancelRequest() {
        // refresh
        stateDidChange(state: serviceState)
    }
}

extension VehiclesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleCell.reuseId, for: indexPath) as! VehicleCell
        cell.setVehicle(vehicle: vehicles![indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let vehicles = vehicles {
            return vehicles.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectVehicle(index: indexPath.row)
        Analytics.trackClick(button: .selectVehicle, screen: self.screen)
    }
}
