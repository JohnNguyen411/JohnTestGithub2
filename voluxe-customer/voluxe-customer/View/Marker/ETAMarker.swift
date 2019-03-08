//
//  ETAMarker.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SnapKit

class ETAMarker: UIView {
    
    let etaValue: UILabel = {
        let etaValue = UILabel()
        etaValue.textColor = .white
        etaValue.font = .volvoSansProMedium(size: 16)
        etaValue.textAlignment = .center
        etaValue.numberOfLines = 1
        return etaValue
    }()
    
    let etaLabel: UILabel = {
        let etaLabel = UILabel()
        etaLabel.textColor = .white
        etaLabel.font = .volvoSansProRegular(size: 9)
        etaLabel.textAlignment = .center
        etaLabel.numberOfLines = 1
        return etaLabel
    }()
    
   
    let icon = UIImageView(image: UIImage(named: "markerDot"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(icon)
        self.addSubview(etaLabel)
        self.addSubview(etaValue)

        icon.frame = self.frame
        etaValue.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview().offset(1)
            make.width.equalToSuperview()
        }
        
        etaLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(1)
            make.top.equalTo(etaValue.snp.bottom).offset(-2)
            make.width.equalToSuperview()
            make.height.equalTo(8)
        }
    }
    
    func setETA(eta: GMTextValueObject?) {
        if let eta = eta, let seconds = eta.value {
            let etaInMin = "\(seconds/60)"
            etaValue.text = etaInMin
        }
        
        if etaValue.text != nil && !(etaValue.text?.isEmpty)! {
            etaLabel.text = String.localized(.min).lowercased()
            icon.image = UIImage(named: "markerBlank")
        } else {
            etaLabel.text = ""
            icon.image = UIImage(named: "markerDot")
        }
    }
    
    func hideEta() {
        etaLabel.text = ""
        etaValue.text = ""
        icon.image = UIImage(named: "markerDot")
    }
    
}
