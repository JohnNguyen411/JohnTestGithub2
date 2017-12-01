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
    let testView = UIView(frame: .zero)

    let titleView: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansLightBold(size: 18)
        titleLabel.textAlignment = .left
        return titleLabel
    }()

    init(step: Step, index: Int) {
        self.step = step
        super.init(frame: .zero)
        setupViews()
        updateStep(step: step, index: index)
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
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(11)
            make.width.equalTo(2)
        }
        
        icon.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(1)
            make.height.width.equalTo(24)
        }
        
        titleView.snp.makeConstraints{ make in
            make.right.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(20)
            make.top.equalToSuperview().offset(3)
            make.height.equalTo(20)
        }
    }
    
    func updateStep(step: Step, index: Int) {
        self.step = step
        
        titleView.text = step.text
        if step.state == .todo {
            animateImageChange(image: UIImage(named: "padded_dot"))
        } else {
            animateImageChange(image: UIImage(named: "checked_circle"))
            if testView.superview == nil {
                testView.accessibilityIdentifier = "stepview\(index)"
                self.addSubview(testView)
                testView.snp.makeConstraints { make in
                    make.top.right.equalToSuperview()
                    make.width.height.equalTo(1)
                }
            }
        }
    }
    
    func animateImageChange(image: UIImage?) {
        if let image = image {
            UIView.transition(with: self.icon,
                              duration:0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.icon.image = image },
                              completion: nil)
        }
    }
}
