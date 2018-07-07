//
//  HelpBookingView.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class HelpBookingView: UIView {

    static let height = 270
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()

    var title: String?
    var request: Request?
    
    var booking: Booking? {
        didSet {
            if let booking = self.booking {
                if let dropoffRequest = booking.dropoffRequest, dropoffRequest.getState() == .completed {
                    self.request = dropoffRequest
                    title = String.YourLastDelivery.uppercased()
                    titleLabel.text = title
                    titleLabel.addUppercasedCharacterSpacing()
                    fillRequest(request: dropoffRequest, dealership: booking.dealership)
                } else if let pickupRequest = booking.pickupRequest {
                    self.request = pickupRequest
                    title = String.YourLastPickup.uppercased()
                    titleLabel.text = title
                    fillRequest(request: pickupRequest, dealership: booking.dealership)
                    titleLabel.addUppercasedCharacterSpacing()
                }
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = String.YourLastDelivery.uppercased()
        titleLabel.font = .volvoSansProMedium(size: 13)
        titleLabel.textColor = .luxeGray()
        titleLabel.addUppercasedCharacterSpacing()
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel(frame: .zero)
        dateLabel.font = .volvoSansProMedium(size: 14)
        dateLabel.textColor = .luxeDarkGray()
        dateLabel.backgroundColor = .clear
        dateLabel.numberOfLines = 1
        return dateLabel
    }()
    
    private let dealershipLabel: UILabel = {
        let dealershipLabel = UILabel(frame: .zero)
        dealershipLabel.font = .volvoSansProMedium(size: 13)
        dealershipLabel.textColor = .luxeGray()
        dealershipLabel.backgroundColor = .clear
        dealershipLabel.numberOfLines = 1
        return dealershipLabel
    }()
    
    private let disclosureIndicatorImageView = UIImageView(image: UIImage(named: "disclosureIndicator"))
    private let mapViewVC = MapViewController()
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
        self.addSubview(dealershipLabel)
        self.addSubview(disclosureIndicatorImageView)
        self.addSubview(mapViewVC.view)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().offset(35)
        }
        self.mapViewVC.view.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.right.left.equalToSuperview()
            make.height.equalTo(155)
        }
        self.dateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(self.mapViewVC.view.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(35)
        }
        self.disclosureIndicatorImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(dateLabel)
            make.width.equalTo(8)
            make.height.equalTo(13)
        }
        self.dealershipLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(self.dateLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(35)
        }
    }
    
    private func fillRequest(request: Request, dealership: Dealership?) {
        if let location = request.location {
            mapViewVC.updateRequestLocation(location: location.getLocation()!, withZoom: 15)
        }
        
        if let timeSlot = request.timeSlot, let date = timeSlot.from {
            let dateTime = formatter.string(from: date)
            dateLabel.text = "\(dateTime), \(timeSlot.getTimeSlot(calendar: Calendar.current, showAMPM: true) ?? "")"
        }
        
        if let driver = request.driver, let dealership = dealership {
            dealershipLabel.text = "\(driver.name ?? ""), \(dealership.name ?? "")"
        }
        
        
    }
    
}
