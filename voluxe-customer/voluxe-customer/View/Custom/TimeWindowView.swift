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
        titleLabel.font = .volvoSansProLight(size: 38)
        titleLabel.textAlignment = .center
        titleLabel.text = "-:-- - -:--"
        return titleLabel
    }()
    
    let subtitleView: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = .volvoSansProMedium(size: 10)
        titleLabel.textAlignment = .center
        titleLabel.text = (.PickupWindow as String).uppercased()
        titleLabel.addUppercasedCharacterSpacing()
        return titleLabel
    }()

    // TODO move to static creator func
    let shinyView: ShinyView = {
        let view = VLShinyView(frame: CGRect.zero)
        view.alpha = 0.5
        view.axis = .all
        view.colors = VLShinyView.luxeColors
        view.clipsToBounds = true
        view.scale = 3
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.shinyView.stopUpdates()
    }
    
    private func setupViews() {
        
        self.backgroundColor = .luxeCharcoalGrey()
        
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

        self.insertSubview(self.shinyView, at: 0)
        self.shinyView.snp.makeConstraints {
            (make) -> Void in
            make.edges.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.shinyView.startUpdates()
    }
    
    func setETA(eta: GMTextValueObject?) {
        var date = Date()
        if let eta = eta, let seconds = eta.value {
            date = Calendar.current.date(byAdding: .second, value: seconds, to: date)!
            let dateString : String = DateFormatter.dateFormat(fromTemplate: "j:mm", options: 0, locale: Locale.current)!
            let formatter = DateFormatter()
            formatter.dateFormat = dateString
            titleView.text = formatter.string(from: date).lowercased()
        }
    }
    
    func setTimeWindows(timeWindows: String) {
        titleView.text = timeWindows
    }

    func setSubtitle(text: String) {
        subtitleView.text = text.uppercased()
        subtitleView.addUppercasedCharacterSpacing()
    }
}
