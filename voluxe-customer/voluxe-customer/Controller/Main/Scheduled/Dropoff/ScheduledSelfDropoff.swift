//
//  ScheduledSelfDropoff.swift
//  voluxe-customer
//
//  Created by Johan Giroux on 8/16/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class ScheduledSelfDropoff: BaseViewController {
    
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
        return titleLabel
    }()
    
    let deliveryLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansProRegular(size: 14)
        titleLabel.textAlignment = .left
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
        mapItButton = VLButton(type: .blueSecondary, title: (.ShowDetails as String).uppercased(), kern: UILabel.uppercasedKern(), event: .mapIt, screen: screen)
        scheduleDeliveryButton = VLButton(type: .bluePrimary, title: (.ScheduleDelivery as String).uppercased(), kern: UILabel.uppercasedKern(), event: .scheduleDelivery, screen: screen)
        super.init(screen: screen)
        self.mapVC.screen = screen

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: self.vehicle) {
            self.fillViews(booking: booking)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(dealershipNoteLabel)
        contentView.addSubview(self.mapVC.view)
        contentView.addSubview(dealershipAddressLabel)
        contentView.addSubview(mapItButton)
        contentView.addSubview(deliveryLabel)
        contentView.addSubview(scheduleDeliveryButton)
        
        let adaptedMarging = ViewUtils.getAdaptedHeightSize(sizeInPoints: 20)
        
        scrollView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self.view, edges: UIEdgeInsetsMake(adaptedMarging, adaptedMarging, adaptedMarging, adaptedMarging))
        }
        
        contentView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self.scrollView)
        }
        
        dealershipNoteLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(200)
        }
        
        mapItButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(dealershipAddressLabel)
        }
        
        dealershipAddressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dealershipNoteLabel.snp.bottom).offset(20)
            make.right.equalTo(mapItButton.snp.left)
        }
        
        mapVC.view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        deliveryLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mapVC.view.snp.bottom).offset(20)
        }
        
        scheduleDeliveryButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(deliveryLabel.snp.bottom).offset(20)
        }
        
    }
    
    private func fillViews(booking: Booking) {
        if let dealership = booking.dealership, let location = dealership.location {
            dealershipAddressLabel.text = location.address
            
            if let coordinates = location.getLocation() {
                mapVC.updateRequestLocation(location: coordinates)
                mapItButton.addTarget(self, action: #selector(mapIt), for: .touchUpInside)

            } else {
                mapVC.view.isHidden = true
                mapItButton.isHidden = true
            }
            
            
        }
    }
    
    @objc private func mapIt(coordinates: CLLocationCoordinate2D) {
        
    }
    
}
