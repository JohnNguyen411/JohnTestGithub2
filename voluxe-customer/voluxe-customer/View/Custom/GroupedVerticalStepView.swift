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
            make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(StepView.height)))
        }
        
        stepViews.append(stepView)
        steps.append(step)
        
        height = stepViews.count * Int(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(StepView.height)))

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
    
    func resetSteps() {
        
        for (index, step) in steps.enumerated() {
            step.state = index == 0 ? .done : .todo
        }
        
        for (index, stepView) in stepViews.enumerated() {
            stepView.step.state = index == 0 ? .done : .todo
            stepView.updateStep(step: stepView.step, index: index)
            stepView.setCurrent(isCurrent: index == 0)
        }
    }
    
    func stepViewforIndex(_ index: Int) -> StepView? {
        for (i, stepView) in stepViews.enumerated() {
            if index == i {
                return stepView
            }
        }
        return nil
    }
    
}
