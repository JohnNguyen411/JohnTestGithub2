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
        
        for (index, step) in steps.enumerated() {
            addStep(step: step, index: index)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addStep(step: Step, index: Int) {
        
        let stepView = StepView(step: step, index: index)
        stepView.setCurrent(isCurrent: index == 0)
        
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
        var indexInList = 0

        for (index, stepView) in stepViews.enumerated() {
            if stepView.step.id == step.id {
                stepView.updateStep(step: step, index: index)
                indexInList = index
                stepView.setCurrent(isCurrent: true)
            } else {
                // not current
                stepView.setCurrent(isCurrent: false)
            }
        }
        
        steps[indexInList] = step
    }
    
}
