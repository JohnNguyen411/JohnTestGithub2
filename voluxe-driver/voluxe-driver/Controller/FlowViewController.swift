//
//  FlowViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class FlowViewController: UIViewController, StepViewControllerDelegate {

    // MARK: Data

    private let direction: FlowDirection
    private var steps: [Step] = []
    private var currentIndex = -1
    private var currentVC: StepViewController?

    // MARK: Lifecycle
    
    init(steps: [Step], direction: FlowDirection) {
        self.direction = direction
        super.init(nibName: nil, bundle: nil)
        self.steps = steps
        if let step = steps.first { self.navigationItem.title = step.title.capitalized }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentIndex == -1 {
            _ = pushNextStep()
        }
    }
    
    // MARK: StepViewControllerDelegate

    func popStep() -> Bool {
        if currentIndex == 0 {
            return false
        }
        currentIndex -= 1
        let step = steps[currentIndex]
        if let vc = FlowViewController.controllerForStep(step: step) {
            vc.flowDelegate = self
            if let currentVC = self.currentVC {
                animate(oldViewController: currentVC, toViewController: vc, action: .pop)
            } else {
                add(asChildViewController: vc)
            }
            
            currentVC = vc
            updateTitle()
            return true
        }
        return false
    }
    
    func pushNextStep() -> Bool {
        if currentIndex == steps.count-1 {
            return false
        }
        currentIndex += 1
        let nextStep = steps[currentIndex]
        if let nextVC = FlowViewController.controllerForStep(step: nextStep) {
            nextVC.flowDelegate = self
            if let currentVC = self.currentVC {
                animate(oldViewController: currentVC, toViewController: nextVC, action: .push)
            } else {
                add(asChildViewController: nextVC)
            }
            currentVC = nextVC
            updateTitle()
            return true
        }
        return false
    }
    
    func updateTitle() {
        let step = steps[currentIndex]
        self.navigationItem.title = step.title.capitalized
    }
    
    // MARK: - Utils
    
    private func animate(oldViewController: StepViewController, toViewController newViewController: StepViewController, action: FlowNavigationAction) {
        
        oldViewController.willMove(toParent: nil)
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(newViewController)
        let startingConstraints = self.addSubviewController(subViewController: newViewController, toView: self.view, action: action)
        
        self.view.layoutIfNeeded()
        
        self.transition(from: oldViewController, to: newViewController, duration: 0.30, options: .curveEaseInOut, animations: {
            
            // new view constraints
            NSLayoutConstraint.deactivate(startingConstraints)
            let newContraints = self.endConstaints(for: newViewController.view, toView: self.view, action: action)
            NSLayoutConstraint.activate(newContraints)
            
            oldViewController.view.alpha = 0
            
            self.view.layoutIfNeeded()

        }, completion: { (finished) in
            
            newViewController.didMove(toParent: self)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParent()
            
        })
        
    }
    
    private func addSubviewController(subViewController: StepViewController, toView parentView: UIView, action: FlowNavigationAction) -> [NSLayoutConstraint] {
        self.view.layoutIfNeeded()
        let subView = subViewController.view!
        parentView.addSubview(subView)
        
        let startingConstaints = self.startConstaints(for: subView, toView: parentView, action: action)
        
        NSLayoutConstraint.activate(startingConstaints)
        return startingConstaints
    }
    
    private func startConstaints(for subView: UIView, toView parentView: UIView, action: FlowNavigationAction) ->  [NSLayoutConstraint] {
        if direction == .horizontal {
            if action == .push {
                return [
                    subView.leadingAnchor.constraint(equalTo: parentView.trailingAnchor),
                    subView.topAnchor.constraint(equalTo: parentView.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
                    subView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
                ]
            } else {
                return [
                    subView.trailingAnchor.constraint(equalTo: parentView.leadingAnchor),
                    subView.topAnchor.constraint(equalTo: parentView.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
                    subView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
                ]
            }
        } else {
            return []
        }
        
    }
    
    private func endConstaints(for subView: UIView, toView parentView: UIView, action: FlowNavigationAction) ->  [NSLayoutConstraint] {
        if direction == .horizontal {
            if action == .push {
                return [
                    subView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    subView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    subView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
                ]
            } else {
                return [
                    subView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    subView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    subView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
                ]
            }
        } else {
            return []
        }
        
        
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        self.addChild(viewController)
        
        // Add Child View as Subview
        self.view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private static func controllerForStep(step: Step) -> StepViewController? {
        if step.controllerName == LoginViewController.className {
            return LoginViewController()
        } else if step.controllerName == ForgotPasswordViewController.className {
            return ForgotPasswordViewController(step: step)
        } else if step.controllerName == ConfirmPhoneViewController.className {
            return ConfirmPhoneViewController(step: step)
        } else if step.controllerName == PhoneVerificationViewController.className {
            return PhoneVerificationViewController(step: step)
        } else if step.controllerName == SelfieViewController.className {
            return SelfieViewController(step: step)
        }
        return nil
    }
    
}

extension FlowViewController {
    static func loginSteps(for driver: Driver) -> [Step] {
        var steps: [Step] = []

        if driver.passwordResetRequired {
            steps.append(ForgotPasswordStep())
        }
        if !driver.workPhoneNumberVerified {
            steps.append(PhoneNumberStep())
            steps.append(Step(title:Localized.confirmPhoneNumber, controllerName: PhoneVerificationViewController.className))
        }
        if driver.photoUrl == nil || driver.photoUrl?.count == 0 {
            steps.append(Step(title:Localized.photographYourself, controllerName: SelfieViewController.className))
        }
        return steps
    }
}


class Step {
    let title: String
    let controllerName: String
    
    init(title: String, controllerName: String) {
        self.title = title
        self.controllerName = controllerName
    }
}

class StepView: UIView {

//    private var step: Step

    convenience init() {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.Debug.red
    }

    convenience init(with step: Step) {
        self.init()
//        self.step = step
    }
}

enum FlowDirection {
    case horizontal
    case vertical
}

enum FlowNavigationAction {
    case push
    case pop
}
