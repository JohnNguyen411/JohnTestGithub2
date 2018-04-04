//
//  LeftPanelActiveBooking.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/4/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class LeftPanelActiveBooking: UIView {
    
    let redDot = UIImageView(frame: .zero)
    
    let activeBookingLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = .volvoSansLight(size: 16)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let booking: Booking
    var isShowingNotif: Bool = false
    
    init(booking: Booking) {
        self.booking = booking
        super.init(frame: .zero)
        
        if let vehicle = booking.vehicle {
            activeBookingLabel.text = vehicle.vehicleDescription()
        }
        
        redDot.image = UIImage(named: "red_dot")
        showRedDot(show: false)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) { 
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        self.addSubview(redDot)
        self.addSubview(activeBookingLabel)
        
        redDot.snp.makeConstraints{ make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(5)
        }
        
        activeBookingLabel.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.left.equalTo(redDot.snp.right).offset(2)
            make.height.equalToSuperview()
        }
    }
    
    func showRedDot(show: Bool) {
        redDot.isHidden = !show
        self.isShowingNotif = show
    }
    
}
