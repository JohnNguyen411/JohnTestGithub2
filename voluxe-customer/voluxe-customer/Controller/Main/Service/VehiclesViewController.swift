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
    var vehicles: [Vehicle] = []
    var selectedVehicle: Vehicle?

    let vehicleCollectionView: UICollectionView
    let vehicleTypeView = VLTitledLabel(title: .volvoYearModel, leftDescription: "", rightDescription: "")
    let vehicleImageView = UIImageView(frame: .zero)
    let preferredDealershipView = VLTitledLabel(title: .dealership, leftDescription: "", rightDescription: "")
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
        
        dealershipLocationButton = VLButton(type: .blueSecondary, title: String.viewScheduleServiceScheduledLabel.uppercased(), kern: UILabel.uppercasedKern(), event: .viewDealershipLocation, screen: .vehicles)
        confirmButton = VLButton(type: .bluePrimary, title: (.newService as String).uppercased(), kern: UILabel.uppercasedKern(), event: .newService, screen: .vehicles)
        
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

        showVehicles(vehicles: UserManager.sharedInstance.getVehicles() ?? [])
        stateDidChange(state: serviceState)
        
        // animate alpha at the first load
        self.contentView.animateAlpha(show: true)
    }
    
    
    override func setupViews() {
        super.setupViews()

        self.contentView.alpha = 0
        dealershipLocationButton.isHidden = true
        confirmButton.accessibilityLabel = "confirmButton"
        vehicleCollectionView.clipsToBounds = false

        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self.view, edges: UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20))
        }

        contentView.addSubview(vehicleCollectionView)
        vehicleCollectionView.snp.makeConstraints {
            make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(VehicleCell.VehicleCellHeight)
        }

        // TODO https://app.asana.com/0/835085594281016/840211358323978/f
        // The upcoming Layout utility will have a func for this, but it
        // is left expanded for now.
        let scrollView = UIScrollView.forAutoLayout()
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(vehicleCollectionView.snp.bottom).offset(20)
        }

        // TODO https://app.asana.com/0/835085594281016/840211358323978/f
        // The upcoming Layout utility will have a func for this, but it
        // is left expanded for now.
        let contentViewInScrollView = UIView.forAutoLayout()
        scrollView.addSubview(contentViewInScrollView)
        contentViewInScrollView.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(scrollView.snp.height)
        }

        contentViewInScrollView.addSubview(vehicleTypeView)
        vehicleTypeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(VLTitledLabel.height)
        }

        contentViewInScrollView.addSubview(vehicleImageView)
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleTypeView.snp.bottom)
            make.height.equalTo(Vehicle.vehicleImageHeight)
        }

        contentViewInScrollView.addSubview(scheduledServiceView)
        scheduledServiceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
            make.height.equalTo(VLTitledLabel.height)
        }

        contentViewInScrollView.addSubview(dealershipLocationButton)
        dealershipLocationButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(scheduledServiceView.snp.bottom).offset(20)
        }

        contentViewInScrollView.addSubview(preferredDealershipView)
        preferredDealershipView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(scheduledServiceView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }

        // TODO https://app.asana.com/0/835085594281016/840211358323978/f
        // The upcoming Layout utility will have a func for this, but it
        // is left expanded for now.
        // A spacer view is required to prevent the vehicle image from
        // breaking its height constraint on taller screens, this will
        // stretch and condense as necessary allowing small screens to
        // automatically scroll and large screens to stretch.  This
        // will be part of the upcoming Layout utility.
        let spacerView = UIView()
        contentViewInScrollView.addSubview(spacerView)
        spacerView.snp.makeConstraints {
            make in
            make.left.right.equalToSuperview()
            make.top.equalTo(preferredDealershipView.snp.bottom)
        }

        contentViewInScrollView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(spacerView.snp.bottom)
            make.height.equalTo(VLButton.primaryHeight)
        }
    }

    func showVehicles(vehicles: [Vehicle]) {

        // collection view is hidden for less than two cars
        // but only if it has changed
        if vehicles.count != self.vehicles.count {
            self.vehicleCollectionView.snp.updateConstraints {
                make in
                let height = vehicles.count > 1 ? VehicleCell.VehicleCellHeight : 0
                make.height.equalTo(height)
            }
        }

        // update the data store
        self.vehicles = vehicles
        self.vehicleCollectionView.reloadData()
        self.vehicleCollectionView.layoutIfNeeded()
        self.selectVehicle(index: VehiclesViewController.selectedVehicleIndex)
    }
    
    func selectVehicle(index: Int) {
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
    
    override func stateDidChange(state: ServiceState) {
        super.stateDidChange(state: state)
        // check if service scheduled
        self.serviceState = state
        if let selectedVehicle = selectedVehicle, let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: selectedVehicle), !booking.isInvalidated, booking.getState() != .canceled {

            scheduledServiceView.isHidden = false
            confirmButton.isHidden = true
            var location: String? = nil
            
            if ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                if !booking.isSelfIB() && booking.getState() == .pickupScheduled, let request = booking.pickupRequest, let timeSlot = request.timeSlot, let date = timeSlot.from {
                    let dateTime = formatter.string(from: date)
                    scheduledServiceView.setTitle(title: .scheduledPickup, leftDescription: "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" )", rightDescription: "")
                    dealershipLocationButton.isHidden = true
                    scheduledServiceView.isEditable = true
                } else {
                    scheduledServiceView.setTitle(title: .viewScheduleServiceVehicleServiceScheduled, leftDescription: booking.getRepairOrderName())
                    dealershipLocationButton.isHidden = false
                    scheduledServiceView.isEditable = false
                }
                if let request = booking.pickupRequest, let requestLocation = request.location {
                    location = requestLocation.getMediumAddress()
                }
            } else {
                if booking.isSelfOB() {
                    scheduledServiceView.setTitle(title: .completedService, leftDescription: booking.getRepairOrderName())
                    scheduledServiceView.isEditable = false
                    dealershipLocationButton.isHidden = false
                } else {
                    scheduledServiceView.isEditable = true
                    dealershipLocationButton.isHidden = true
                    if let request = booking.dropoffRequest, let timeSlot = request.timeSlot, let date = timeSlot.from {
                        let dateTime = formatter.string(from: date)
                        scheduledServiceView.setTitle(title: .scheduledDelivery, leftDescription: "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" )", rightDescription: "")
                    } else {
                        if booking.getState() == .service {
                            scheduledServiceView.setTitle(title: .currentService, leftDescription: booking.getRepairOrderName())
                        } else {
                            scheduledServiceView.setTitle(title: .completedService, leftDescription: booking.getRepairOrderName())
                        }
                    }
                    if let request = booking.dropoffRequest, let requestLocation = request.location {
                        location = requestLocation.getMediumAddress()
                    }
                }
            }
            
            
            if booking.isSelfOB() || (ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) && booking.isSelfIB()) {
                preferredDealershipView.isHidden = true
            } else {
                if let location = location {
                    preferredDealershipView.isHidden = false
                    if ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                        preferredDealershipView.setTitle(title: .pickupLocation, leftDescription: location)
                    } else {
                        preferredDealershipView.setTitle(title: .deliveryLocation, leftDescription: location)
                    }
                } else {
                    if let dealership = booking.dealership {
                        preferredDealershipView.isHidden = false
                        preferredDealershipView.setTitle(title: .dealership, leftDescription: dealership.name ?? "")
                    }
                }
            }
        } else {
            scheduledServiceView.isHidden = true
            preferredDealershipView.isHidden = true
            dealershipLocationButton.isHidden = true
            confirmButton.isHidden = false
        }

        self.updateViewHeightConstraints()
    }

    private func updateViewHeightConstraints() {

        self.scheduledServiceView.snp.updateConstraints {
            make in
            let height = self.scheduledServiceView.isHidden ? 0 : VLTitledLabel.height
            make.height.equalTo(height)
        }

        self.preferredDealershipView.snp.updateConstraints {
            make in
            let height = self.preferredDealershipView.isHidden ? 0 : VLTitledLabel.height
            make.height.equalTo(height)
        }

        self.confirmButton.snp.updateConstraints {
            make in
            let height = self.confirmButton.isHidden ? 0 : VLButton.primaryHeight
            make.height.equalTo(height)
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
        cell.setVehicle(vehicle: self.vehicles[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vehicles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectVehicle(index: indexPath.row)
        Analytics.trackClick(button: .selectVehicle, screen: self.screen)
    }
}
