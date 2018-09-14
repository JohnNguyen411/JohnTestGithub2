//
//  ScheduledSelfViewController.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 9/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import PhoneNumberKit

class ScheduledSelfViewController: BaseVehicleViewController {
    
    let phoneNumberKit = PhoneNumberKit()
    
    let dealershipNameLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansProBold(size: 14)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let dealershipNoteLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.font = .volvoSansProRegular(size: 14)
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let dealershipAddressLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansProRegular(size: 14)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    let deliveryLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = .ScheduleDriver
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansProRegular(size: 14)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView(frame: .zero)
    
    let scheduleDeliveryButton: VLButton
    let mapItButton: VLButton
    let dealershipPhoneButton: VLButton
    
    let mapVC = MapViewController()
    
    init(vehicle: Vehicle, state: ServiceState, screen: AnalyticsEnums.Name.Screen) {
        dealershipPhoneButton = VLButton(type: .blueSecondary, title: "", kern: UILabel.uppercasedKern(), event: .callDealership, screen: screen)
        mapItButton = VLButton(type: .blueSecondary, title: (.GetDirections as String).uppercased(), kern: UILabel.uppercasedKern(), event: .getDirections, screen: screen)
        scheduleDeliveryButton = VLButton(type: .grayPrimary, title: (.ScheduleDelivery as String).uppercased(), kern: UILabel.uppercasedKern(), event: .scheduleDelivery, screen: screen)
        super.init(vehicle: vehicle, state: state, screen: screen)
        
        self.mapVC.screen = screen
        
        scrollView.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: self.vehicle) {
            self.fillViews(booking: booking)
        }
        
        setTitle(title: .PickupAtDealership)
        
        mapItButton.contentHorizontalAlignment = .right
        scheduleDeliveryButton.addTarget(self, action: #selector(scheduleDelivery), for: .touchUpInside)
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(dealershipNameLabel)
        contentView.addSubview(dealershipNoteLabel)
        contentView.addSubview(self.mapVC.view)
        contentView.addSubview(dealershipAddressLabel)
        contentView.addSubview(dealershipPhoneButton)
        contentView.addSubview(mapItButton)
        self.view.addSubview(deliveryLabel)
        self.view.addSubview(scheduleDeliveryButton)
        
        let adaptedMarging = ViewUtils.getAdaptedHeightSize(sizeInPoints: 20)
        
        scrollView.snp.makeConstraints { make in
            make.equalsToTop(view: self.view, offset: ViewUtils.getAdaptedHeightSize(sizeInPoints: BaseViewController.defaultTopYOffset))
            make.bottom.equalTo(deliveryLabel.snp.top).offset(-adaptedMarging)
            make.left.equalToSuperview().offset(adaptedMarging)
            make.right.equalToSuperview().offset(-adaptedMarging)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.top.width.bottom.equalTo(scrollView)
        }
        
        dealershipNoteLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: 160))
        }
        
        dealershipNameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dealershipNoteLabel.snp.bottom).offset(adaptedMarging)
        }
        
        dealershipAddressLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dealershipNameLabel.snp.bottom).offset(5)
        }
        
        dealershipPhoneButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dealershipAddressLabel.snp.bottom).offset(5)
        }
        
        mapItButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dealershipPhoneButton.snp.bottom).offset(adaptedMarging)
        }
        
        mapVC.view.snp.makeConstraints { make in
            make.top.equalTo(mapItButton.snp.bottom).offset(adaptedMarging)
            make.left.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-2)
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: 200))
        }
        
        mapVC.view.clipsToBounds = false
        
        ViewUtils.addShadow(toView: mapVC.view)
        
        deliveryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(adaptedMarging)
            make.right.equalToSuperview().offset(-adaptedMarging)
            make.bottom.equalTo(scheduleDeliveryButton.snp.top).offset(-adaptedMarging)
        }
        
        scheduleDeliveryButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-adaptedMarging)
            make.left.equalToSuperview().offset(adaptedMarging)
            make.equalsToBottom(view: self.view, offset: -adaptedMarging)
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(VLButton.primaryHeight)))
        }
        
    }
    
    private func fillViews(booking: Booking) {
        if let dealership = booking.dealership, let location = dealership.location {
            dealershipAddressLabel.text = location.getMediumAddress()
            dealershipNameLabel.text = dealership.name
            
            if let coordinates = location.getLocation() {
                mapVC.updateRequestLocation(location: coordinates)
                self.mapVC.enableZoom(zoomEnabled: true)
                mapItButton.addTarget(self, action: #selector(mapIt), for: .touchUpInside)
                
            } else {
                mapVC.view.isHidden = true
                mapItButton.isHidden = true
            }
            
            if let hours = dealership.hoursOfOperation {
                dealershipNoteLabel.text = hours
                dealershipNoteLabel.sizeToFit()
            }
            
            if let phone = dealership.phoneNumber {
                dealershipPhoneButton.addTarget(self, action: #selector(callDealership), for: .touchUpInside)
                
                do {
                    let validPhoneNumber = try phoneNumberKit.parse(phone)
                    dealershipPhoneButton.setTitle(title: phoneNumberKit.format(validPhoneNumber, toType: .national, withPrefix: false))
                } catch {
                }
            }
        }
    }
    
    @objc private func callDealership() {
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: self.vehicle) else { return }
        guard let dealership = booking.dealership else { return }
        guard let phone = dealership.phoneNumber else { return }
        
        let number = "telprompt:\(phone)"
        guard let numberURL = URL(string: number) else { return }
        
        UIApplication.shared.open(numberURL)
        
    }
    
    
    @objc private func mapIt() {
        
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: self.vehicle) else { return }
        guard let dealership = booking.dealership else { return }
        guard let location = dealership.location else { return }
        
        if let coordinates = location.getLocation() {
            LocationUtils.launchNavigationToLocation(location: coordinates, usingWaze: false)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let height = self.mapVC.view.frame.origin.y + self.mapVC.view.frame.size.height
        
        contentView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    @objc private func scheduleDelivery() {
        if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) {
            RequestedServiceManager.sharedInstance.setDropOffRequestType(requestType: .driverDropoff)
            self.pushViewController(SchedulingDropoffViewController(state: .schedulingDelivery, booking: booking), animated: true)
        }
    }
    
}
