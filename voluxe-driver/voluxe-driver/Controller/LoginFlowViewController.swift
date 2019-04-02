//
//  LoginFlowViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/22/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class LoginFlowViewController: FlowViewController {
    
    override func viewDidLoad() {
        self.containerView = self.view
        super.viewDidLoad()
    }

    override func controllerForStep(step: Step) -> StepViewController? {
        var stepVC: StepViewController?
        if step.controllerName == LoginViewController.className {
            stepVC = LoginViewController()
        } else if step.controllerName == ForgotPasswordViewController.className {
            stepVC =  ForgotPasswordViewController(step: step)
        } else if step.controllerName == ConfirmPhoneViewController.className {
            stepVC =  ConfirmPhoneViewController(step: step)
        } else if step.controllerName == PhoneVerificationViewController.className {
            stepVC =  PhoneVerificationViewController(step: step)
        } else if step.controllerName == SelfieViewController.className {
            stepVC =  SelfieViewController(step: step)
        }
        
        if stepVC != nil {
            stepVC!.flowDelegate = self
        }
        
        return stepVC
    }
}

extension LoginFlowViewController {
    
    static func changePhoneNumberSteps() -> [Step] {
        return [PhoneNumberStep(), Step(title:Unlocalized.confirmPhoneNumber, controllerName: PhoneVerificationViewController.className)]
    }
    
    static func loginSteps(for driver: Driver) -> [Step] {
        var steps: [Step] = []
        
        if driver.passwordResetRequired ?? false {
            steps.append(ForgotPasswordStep())
        }
        if !(driver.workPhoneNumberVerified ?? false) {
            steps.append(PhoneNumberStep())
            steps.append(Step(title:Unlocalized.confirmPhoneNumber, controllerName: PhoneVerificationViewController.className))
        }
        if driver.photoUrl == nil || driver.photoUrl?.count == 0 {
            steps.append(Step(title:Unlocalized.photographYourself, controllerName: SelfieViewController.className))
        }
        return steps
    }
}
