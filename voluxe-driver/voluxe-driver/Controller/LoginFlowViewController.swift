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
