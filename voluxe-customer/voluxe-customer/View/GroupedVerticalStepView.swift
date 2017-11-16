//
//  GroupedVerticalStepView.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/15/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class GroupedVerticalStepView: UIView {
    
    var height = 0
    
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
        
        stepView.snp.makeConstraints{ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(height)
            make.height.equalTo(StepView.height)
        }
        
        stepViews.append(stepView)
        steps.append(step)
        
        height = stepViews.count * StepView.height

    }
    
    func updateStep(step: Step) {
        stepViews.forEach { stepView in
            if stepView.step.id == step.id {
                stepView.updateStep(step: step)
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
