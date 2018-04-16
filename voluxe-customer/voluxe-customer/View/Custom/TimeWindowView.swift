//
//  TimeWindowView.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class TimeWindowView: UIView {
    
    static let height = 100
    
    let labelContainer = UIView(frame: .zero)
    
    let titleView: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = .volvoSansLight(size: 38)
        titleLabel.textAlignment = .center
        titleLabel.text = "6:00 - 9:00"
        return titleLabel
    }()
    
    let subtitleView: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = .volvoSansLightBold(size: 10)
        titleLabel.textAlignment = .center
        titleLabel.text = (.PickupWindow as String).uppercased()
        titleLabel.addCharacterSpacing(kernValue: UILabel.uppercasedKern())
        return titleLabel
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        self.backgroundColor = .luxeTundora()
        
        addSubview(labelContainer)
        labelContainer.addSubview(titleView)
        labelContainer.addSubview(subtitleView)
        
        labelContainer.snp.makeConstraints { make in
            make.center.width.equalToSuperview()
            make.height.equalTo(70)
        }
        
        titleView.snp.makeConstraints { make in
            make.centerX.width.top.equalToSuperview()
            make.height.equalTo(40)
        }
        
        subtitleView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(10)
            make.height.equalTo(10)
        }
    }
    
    func setETA(eta: GMTextValueObject?) {
        var date = Date()
        
        if let eta = eta, let seconds = eta.value {
            date = Calendar.current.date(byAdding: .second, value: seconds, to: date)!
            let dateString : String = DateFormatter.dateFormat(fromTemplate: "j:mm", options: 0, locale: Locale.current)!
            let formatter = DateFormatter()
            formatter.dateFormat = dateString
            titleView.text = formatter.string(from: date)
        }
        
        subtitleView.text = (.EstimatedPickupTime as String).uppercased()

    }
    
    func setTimeWindows(timeWindows: String) {
        subtitleView.text = (.PickupWindow as String).uppercased()
        titleView.text = timeWindows
    }
}
