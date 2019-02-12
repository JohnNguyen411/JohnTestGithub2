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
    var currentVC: StepViewController?

    var currentIndex = -1
    var steps: [Step] = []
    
    // MARK: View
    
    // need to be provided by sublass before adding subview
    var containerView: UIView?

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
        pushNextStep()
    }
    
    func refreshSteps() {
        // override if need to refresh steps
    }
    
    // MARK: StepViewControllerDelegate
    
    @discardableResult
    func refreshUI() -> Bool {
        self.refreshSteps()
        if self.steps.count <= currentIndex {
            return false
        }
        
        let step = self.steps[currentIndex]
        if let vc = self.controllerForStep(step: step) {
            self.add(asChildViewController: vc)
            self.currentVC = vc
            self.updateTitle()
            return true
        }
        return false
    }

    @discardableResult
    func popStep() -> Bool {
        //self.refreshSteps()
        if self.currentIndex <= 0 || self.steps.count <= currentIndex {
            return false
        }
        self.currentIndex -= 1
        let step = self.steps[currentIndex]
        
        return pop(step: step)
    }
    
    func pop(step: Step) -> Bool {
        let step = self.steps[currentIndex]
        if let vc = self.controllerForStep(step: step) {
            if let currentVC = self.currentVC {
                self.animate(oldViewController: currentVC, toViewController: vc, action: .pop)
            } else {
                self.add(asChildViewController: vc)
            }
            
            self.currentVC = vc
            self.updateTitle()
            return true
        }
        return false
    }
    
    @discardableResult
    func pushNextStep() -> Bool {
        //self.refreshSteps()
        if self.currentIndex == self.steps.count-1 {
            return false
        }
        self.currentIndex += 1
        let nextStep = self.steps[currentIndex]
        if let nextVC = self.controllerForStep(step: nextStep) {
            if let currentVC = self.currentVC {
                self.animate(oldViewController: currentVC, toViewController: nextVC, action: .push)
            } else {
                self.add(asChildViewController: nextVC)
            }
            self.currentVC = nextVC
            self.updateTitle()
            return true
        }
        return false
    }
    
    func updateTitle() {
        let step = self.steps[currentIndex]
        self.navigationItem.title = step.title.capitalized
    }
    
    // MARK: - Utils
    
    private func animate(oldViewController: StepViewController, toViewController newViewController: StepViewController, action: FlowNavigationAction) {
        
        oldViewController.willMove(toParent: nil)
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(newViewController)
        let startingConstraints = self.addSubviewController(subViewController: newViewController, toView: self.containerView, action: action)
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.30, delay: 0, options: .curveEaseInOut, animations: {
            // new view constraints
            NSLayoutConstraint.deactivate(startingConstraints)
            let newContraints = self.endConstaints(for: newViewController.view, toView: self.containerView, action: action)
            NSLayoutConstraint.activate(newContraints)
            
            oldViewController.view.alpha = 0
            
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            
            newViewController.didMove(toParent: self)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParent()
        })

        /*
        // TODO: Fix transition bug on Inspection Camera
        self.transition(from: oldViewController, to: newViewController, duration: 0.30, options: .curveEaseInOut, animations: {
            
            // new view constraints
            NSLayoutConstraint.deactivate(startingConstraints)
            let newContraints = self.endConstaints(for: newViewController.view, toView: self.containerView, action: action)
            NSLayoutConstraint.activate(newContraints)
            
            oldViewController.view.alpha = 0
            
            self.view.layoutIfNeeded()

        }, completion: { (finished) in
            
            newViewController.didMove(toParent: self)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParent()
            
        })
 */
        
    }
    
    private func addSubviewController(subViewController: StepViewController, toView parentView: UIView?, action: FlowNavigationAction) -> [NSLayoutConstraint] {
        guard let parentView = parentView else { return [] }
        
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
                //pop
                return [
                    subView.trailingAnchor.constraint(equalTo: parentView.leadingAnchor),
                    subView.topAnchor.constraint(equalTo: parentView.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
                    subView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
                ]
            }
        } else {
            // vertical
            if action == .push {
                return [
                    subView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                    subView.topAnchor.constraint(equalTo: parentView.bottomAnchor),
                    subView.heightAnchor.constraint(equalTo: parentView.heightAnchor),
                    subView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
                ]
            } else {
                // pop
                return [
                    subView.bottomAnchor.constraint(equalTo: parentView.topAnchor),
                    subView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                    subView.widthAnchor.constraint(equalTo: parentView.widthAnchor),
                    subView.heightAnchor.constraint(equalTo: parentView.heightAnchor)
                ]
            }
        }
        
    }
    
    private func endConstaints(for subView: UIView, toView parentView: UIView?, action: FlowNavigationAction) ->  [NSLayoutConstraint] {
        guard let parentView = parentView else { return [] }

        if direction == .horizontal {
            if action == .push {
                return [
                    subView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                    subView.topAnchor.constraint(equalTo: parentView.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
                    subView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
                ]
            } else {
                return [
                    subView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                    subView.topAnchor.constraint(equalTo: parentView.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
                    subView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
                ]
            }
        } else {
            // vertical
            if action == .push {
                return [
                    subView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                    subView.topAnchor.constraint(equalTo: parentView.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
                    subView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
                ]
            } else {
                // pop
                return [
                    subView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                    subView.topAnchor.constraint(equalTo: parentView.topAnchor),
                    subView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
                    subView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
                ]
            }
        }
        
        
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        self.addChild(viewController)
        
        // Add Child View as Subview
        self.containerView?.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = self.containerView?.bounds ?? .zero
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
    
    // must be overriden
    func controllerForStep(step: Step) -> StepViewController? {
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
            steps.append(Step(title:Unlocalized.confirmPhoneNumber, controllerName: PhoneVerificationViewController.className))
        }
        if driver.photoUrl == nil || driver.photoUrl?.count == 0 {
            steps.append(Step(title:Unlocalized.photographYourself, controllerName: SelfieViewController.className))
        }
        return steps
    }
}


class Step {
    let title: String
    let controllerName: String
    let swipeTitle: String?
    let nextTitle: String?
    
    init(title: String, controllerName: String, swipeTitle: String?  = nil, nextTitle: String? = nil) {
        self.nextTitle = nextTitle
        self.swipeTitle = swipeTitle
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
