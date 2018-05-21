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


class VehiclesViewController: ChildViewController, ScheduledBookingDelegate {

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
    var serviceState: ServiceState
    var vehicles: [Vehicle]?
    var selectedVehicle: Vehicle?
    var selectedVehicleIndex = 0

    let vehicleCollectionView: UICollectionView
    let vehicleTypeView = VLTitledLabel(title: .VolvoYearModel, leftDescription: "", rightDescription: "")
    let vehicleImageView = UIImageView(frame: .zero)
    let preferedDealershipView = VLTitledLabel(title: .PreferredDealership, leftDescription: "", rightDescription: "")
    let scheduledServiceView = VLTitledLabel()
    let contentView = UIView(frame: .zero)
    let confirmButton: VLButton

    //MARK: Lifecycle methods
    init(state: ServiceState) {
        self.serviceState = state
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: VehicleCell.VehicleCellHeight, height: VehicleCell.VehicleCellHeight)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        vehicleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vehicleCollectionView.backgroundColor = UIColor.clear
        vehicleCollectionView.setCollectionViewLayout(layout, animated: false)
        
        confirmButton = VLButton(type: .bluePrimary, title: (.NewService as String).uppercased(), kern: UILabel.uppercasedKern(), eventName: AnalyticsConstants.eventClickNewService, screenName: AnalyticsConstants.paramNameYourVolvosView)
        
        super.init(screenName: AnalyticsConstants.paramNameYourVolvosView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem()
        self.navigationItem.title = .NewService

        // init tap events
        scheduledServiceView.isUserInteractionEnabled = true
        let scheduledServiceTap = UITapGestureRecognizer(target: self, action: #selector(self.scheduledServiceClick))
        scheduledServiceView.addGestureRecognizer(scheduledServiceTap)
        
        vehicleImageView.contentMode = .scaleAspectFit
        
        confirmButton.setActionBlock {
            self.confirmButtonClick()
        }
        
        vehicleCollectionView.register(VehicleCell.self, forCellWithReuseIdentifier: VehicleCell.reuseId)

        vehicleCollectionView.delegate = self
        vehicleCollectionView.dataSource = self
        vehicleCollectionView.showsVerticalScrollIndicator = false
        vehicleCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showVehicles(vehicles: UserManager.sharedInstance.getVehicles()!)
        stateDidChange(state: serviceState)
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(contentView)
        
        confirmButton.accessibilityLabel = "confirmButton"
        
        vehicleCollectionView.clipsToBounds = false
        contentView.addSubview(vehicleCollectionView)
        contentView.addSubview(vehicleTypeView)
        contentView.addSubview(vehicleImageView)
        contentView.addSubview(preferedDealershipView)
        contentView.addSubview(scheduledServiceView)
        contentView.addSubview(confirmButton)
        
        contentView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self.view, edges: UIEdgeInsetsMake(10, 20, 20, 20))
        }
        
        vehicleCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalTo(self.view)
            make.height.equalTo(VehicleCell.VehicleCellHeight)
        }
        
        vehicleTypeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleCollectionView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleTypeView.snp.bottom)
            make.height.equalTo(Vehicle.vehicleImageHeight)
        }
        
        preferedDealershipView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        
        scheduledServiceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(preferedDealershipView.snp.bottom).offset(20)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
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
        vehicleCollectionView.reloadData()
        selectVehicle(index: selectedVehicleIndex)
    }
    
    func selectVehicle(index: Int) {
        if let vehicles = vehicles {
            selectedVehicleIndex = index
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
        
        //todo: check service for selected vehicle
        if let selectedVehicle = selectedVehicle, let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: selectedVehicle), !booking.isInvalidated {
            scheduledServiceView.snp.updateConstraints { make in
                make.height.equalTo(100)
            }
            scheduledServiceView.isHidden = false
            confirmButton.animateAlpha(show: false)
            
            if ServiceState.isPickup(state: Booking.getStateForBooking(booking: booking)) {
                scheduledServiceView.setTitle(title: .ScheduledService, leftDescription: booking.getRepairOrderName())
            } else {
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
            }
            
            
            if let dealership = booking.dealership {
                preferedDealershipView.isHidden = false
                preferedDealershipView.setLeftDescription(leftDescription: dealership.name!)
            }
            
        } else {
            scheduledServiceView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            scheduledServiceView.isHidden = true
            preferedDealershipView.isHidden = true
            confirmButton.animateAlpha(show: true)
        }
        
    }
    
    //MARK: Actions methods
    func confirmButtonClick() {
        if let selectedVehicle = selectedVehicle {
            RequestedServiceManager.sharedInstance.reset()
            self.pushViewController(NewServiceViewController(vehicle: selectedVehicle), animated: true, backLabel: .Back)
        }
    }
    
    
    @objc func scheduledServiceClick() {
        if let selectedVehicle = selectedVehicle, let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: selectedVehicle) {
            // if booking is today, show upcoming request with map
            if booking.hasUpcomingRequestToday() || (booking.getState() == .service || booking.getState() == .serviceCompleted) {
                appDelegate?.loadViewForVehicle(vehicle: selectedVehicle, state: StateServiceManager.sharedInstance.getState(vehicleId: selectedVehicle.id))
            } else {
                self.navigationController?.pushViewController(ScheduledBookingViewController(booking: booking, delegate: self), animated: true)
            }
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
        selectVehicle(index: indexPath.row)
        VLAnalytics.logEventWithName(AnalyticsConstants.eventClickSelectVehicle, screenName: screenName)
    }
}

extension VehiclesViewController: SlideMenuControllerDelegate {
    
}
