//
//  GroupedVerticalStepView.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class GroupedVerticalStepView: UIView {
    
    private var steps: [Step] = []
    private var stepViews: [StepView] = []
    
    init(steps: [Step]) {
        super.init(frame: .zero)
        steps.forEach { step in
            addStep(step: step)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addStep(step: Step) {
        
        let stepView = StepView(step: step)
        addSubview(stepView)
        
        let lastBottom = stepViews.count * StepView.height
        
        stepView.snp.makeConstraints{ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(lastBottom)
            make.height.equalTo(StepView.height)
        }
        
        stepViews.append(stepView)
        steps.append(step)
    }
    
    func updateStep(step: Step) {
        stepViews.forEach { stepView in
            if stepView.step.id == step.id {
                updateStep(step: step)
            }
        }
        
        var indexInList = 0
        
        for (index, element) in steps.enumerated() {
            if element.id == step.id {
                indexInList = index
                break
            }
        }
        
        steps[indexInList] = step
    }
    
}
