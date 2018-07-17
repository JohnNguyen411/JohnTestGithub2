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

    let vehicleCollectionView: UICollectionView
    let vehicleTypeView = VLTitledLabel(title: .VolvoYearModel, leftDescription: "", rightDescription: "")
    let vehicleImageView = UIImageView(frame: .zero)
    let preferedDealershipView = VLTitledLabel(title: .Dealership, leftDescription: "", rightDescription: "")
    let scheduledServiceView = VLTitledLabel()
    let contentView = UIView(frame: .zero)
    let confirmButton: VLButton

    let shinyView: VLShinyView = {
        let view = VLShinyView(frame: CGRect.zero)
        view.alpha = 0.1
        view.axis = .all
        view.colors = VLShinyView.highlightColors
        view.scale = 3
        view.clipsToBounds = true
//        view.setMask(image: UIImage(named: "luxeByVolvo"))
        return view
    }()

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
        
        confirmButton = VLButton(type: .bluePrimary, title: (.NewService as String).uppercased(), kern: UILabel.uppercasedKern(), event: .newService, screen: .vehicles)
        
        super.init(screen: .vehicles)
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
        scheduledServiceView.isEditable = true
        
        vehicleImageView.contentMode = .scaleAspectFit
        
        confirmButton.setActionBlock { [weak self] in
            self?.confirmButtonClick()
        }
        
        vehicleCollectionView.register(VehicleCell.self, forCellWithReuseIdentifier: VehicleCell.reuseId)

        vehicleCollectionView.delegate = self
        vehicleCollectionView.dataSource = self
        vehicleCollectionView.showsVerticalScrollIndicator = false
        vehicleCollectionView.showsHorizontalScrollIndicator = false
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.shinyView.startUpdates()
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
        
        scheduledServiceView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
            make.height.equalTo(VLTitledLabel.height)
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

//        self.view.addSubview(self.shinyView)
        self.confirmButton.insertSubview(self.shinyView, belowSubview: self.confirmButton.titleLabel!)
        self.shinyView.snp.makeConstraints {
            make in
//            make.edges.equalTo(self.confirmButton)
            make.edges.equalToSuperview()
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
                if booking.getState() == .pickupScheduled, let request = booking.pickupRequest, let timeSlot = request.timeSlot, let date = timeSlot.from {
                    let dateTime = formatter.string(from: date)
                    scheduledServiceView.setTitle(title: .ScheduledPickup, leftDescription: "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "" )", rightDescription: "")
                } else {
                    scheduledServiceView.setTitle(title: .ScheduledService, leftDescription: booking.getRepairOrderName())
                }
                if let request = booking.pickupRequest, let requestLocation = request.location {
                    location = requestLocation.address
                }
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
                if let request = booking.dropoffRequest, let requestLocation = request.location {
                    location = requestLocation.address
                }
            }
            
            
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
            self.pushViewController(NewServiceViewController(vehicle: selectedVehicle), animated: true)
        }
    }
    
    
    @objc func scheduledServiceClick() {
        if let selectedVehicle = selectedVehicle, let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: selectedVehicle) {
            // if booking is today, show upcoming request with map
            if booking.hasUpcomingRequestToday() || (booking.getState() == .service || booking.getState() == .serviceCompleted) {
                appDelegate?.loadViewForVehicle(vehicle: selectedVehicle, state: StateServiceManager.sharedInstance.getState(vehicleId: selectedVehicle.id))
            } else {
                let controller = ScheduledBookingViewController(booking: booking, delegate: self)
                self.pushViewController(controller, animated: true)
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
        self.selectVehicle(index: indexPath.row)
        Analytics.trackClick(button: .selectVehicle, screen: self.screen)
    }
}
