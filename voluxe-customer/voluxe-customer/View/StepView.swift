//
//  StepView.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SnapKit

class StepView: UIView {
    
    static let height = 50
    
    var step: Step
    
    let icon = UIImageView(frame: .zero)
    let line = UIImageView(frame: .zero)
    
    let titleView: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansLightBold(size: 18)
        titleLabel.textAlignment = .left
        return titleLabel
    }()

    init(step: Step) {
        self.step = step
        super.init(frame: .zero)
        updateStep(step: step)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        
        line.image = UIImage(named: "short_line")
        
        addSubview(titleView)
        addSubview(line)
        addSubview(icon)
        
        line.snp.makeConstraints{ make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(3)
        }
        
        icon.snp.makeConstraints{ make in
            make.left.top.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        titleView.snp.makeConstraints{ make in
            make.right.equalToSuperview()
            make.left.equalTo(icon).offset(20)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(20)
        }
    }
    
    func updateStep(step: Step) {
        self.step = step
        
        titleView.text = step.text
        if step.state == .todo {
            line.image = UIImage(named: "padded_dots")
        } else {
            line.image = UIImage(named: "checked_circle")
        }
    }
}
