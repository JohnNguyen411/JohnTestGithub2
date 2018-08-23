//
//  ScheduledSelfDropoff.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 8/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class ScheduledSelfDropoff: BaseViewController {
    
    let dealershipNameLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansProBold(size: 14)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let dealershipNoteLabel: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = .volvoSansProRegular(size: 14)
        textView.backgroundColor = .clear
        textView.isEditable = false
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
    
    let mapVC = MapViewController()
    let vehicle: Vehicle
    
    init(vehicle: Vehicle, screen: AnalyticsEnums.Name.Screen) {
        self.vehicle = vehicle
        mapItButton = VLButton(type: .blueSecondary, title: (.GetDirections as String).uppercased(), kern: UILabel.uppercasedKern(), event: .getDirections, screen: screen)
        scheduleDeliveryButton = VLButton(type: .grayPrimary, title: (.ScheduleDelivery as String).uppercased(), kern: UILabel.uppercasedKern(), event: .scheduleDelivery, screen: screen)
        super.init(screen: screen)
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
        
        setTitle(title: .SelfPickup)
        
        mapItButton.contentHorizontalAlignment = .right
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(dealershipNameLabel)
        contentView.addSubview(dealershipNoteLabel)
        contentView.addSubview(self.mapVC.view)
        contentView.addSubview(dealershipAddressLabel)
        contentView.addSubview(mapItButton)
        self.view.addSubview(deliveryLabel)
        self.view.addSubview(scheduleDeliveryButton)
        
        let adaptedMarging = ViewUtils.getAdaptedHeightSize(sizeInPoints: 20)
        
        scrollView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self.view, edges: UIEdgeInsetsMake(ViewUtils.getAdaptedHeightSize(sizeInPoints: BaseViewController.defaultTopYOffset), adaptedMarging, adaptedMarging, adaptedMarging))
        }
        
        contentView.snp.makeConstraints { make in
            make.left.top.width.height.equalTo(scrollView)
        }
        
        dealershipNoteLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(160)
        }
        
        dealershipNameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dealershipNoteLabel.snp.bottom).offset(adaptedMarging)
        }
        
        dealershipAddressLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(dealershipNameLabel.snp.bottom).offset(5)
        }
        
        mapItButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dealershipAddressLabel.snp.bottom).offset(adaptedMarging)
        }
        
        mapVC.view.snp.makeConstraints { make in
            make.top.equalTo(mapItButton.snp.bottom).offset(adaptedMarging)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        deliveryLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(adaptedMarging)
            make.right.equalToSuperview().offset(-adaptedMarging)
            make.bottom.equalTo(scheduleDeliveryButton.snp.top).offset(-adaptedMarging)
        }
        
        scheduleDeliveryButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-adaptedMarging)
            make.left.equalToSuperview().offset(adaptedMarging)
            make.equalsToBottom(view: self.view, offset: -adaptedMarging)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
    }
    
    private func fillViews(booking: Booking) {
        if let dealership = booking.dealership, let location = dealership.location {
            dealershipAddressLabel.text = location.address
            dealershipNameLabel.text = dealership.name
            
            if let coordinates = location.getLocation() {
                mapVC.updateRequestLocation(location: coordinates)
                mapItButton.addTarget(self, action: #selector(mapIt), for: .touchUpInside)

            } else {
                mapVC.view.isHidden = true
                mapItButton.isHidden = true
            }
            
            
        }
    }
    
    @objc private func mapIt() {
        
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: self.vehicle) else { return }
        guard let dealership = booking.dealership else { return }
        guard let location = dealership.location else { return }
        
        if let coordinates = location.getLocation() {
            LocationUtils.launchNavigationToLocation(location: coordinates, usingWaze: false)
        }
        
    }
    
}
