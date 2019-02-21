//
//  StepViewController.swift
//  voluxe-driver
//
//  Created by Johan Giroux on 1/18/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class StepViewController: UIViewController {
    
    // MARK: Data
    var flowDelegate: StepViewControllerDelegate?
    var step: Step?
    
    init(step: Step? = nil) {
        self.step = step
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = step?.title.capitalized
    }
    
    convenience init(title: String) {
        self.init()
        self.navigationItem.title = title.capitalized
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.restoreStepState()
    }
    
    deinit {
        self.saveStepState()
    }
    
    // MARK: Step Navigation
    func pushNextStep() -> Bool {
        if let flowDelegate = self.flowDelegate {
            self.saveStepState()
            return flowDelegate.pushNextStep()
        }
        return false
    }
    
    func popStep() -> Bool {
        if let flowDelegate = self.flowDelegate {
            self.saveStepState()
            return flowDelegate.popStep()
        }
        return false
    }
    
    func hideBackButton(_ hide: Bool) {
        if let flowDelegate = self.flowDelegate {
            flowDelegate.hideBackButton(hide)
        }
    }
    
    
    // MARK: Step Data
    func saveStepState() {
        // must override method if you want to save data to step, otherwise silently do nothing
    }
    
    func restoreStepState() {
        // must override method if you want to restore data from step, otherwise silently do nothing
    }
    
}

protocol StepViewControllerDelegate {
    /***
     * popStep: pop current view controller and go back to the previous step
     *  @return Bool: true if pop succeeded false if not
     ***/
    @discardableResult
    func popStep() -> Bool
    
    /***
     * pushNextStep: push the next view controller and stack the current one
     *  @return Bool: true if push succeeded false if not
     ***/
    @discardableResult
    func pushNextStep() -> Bool
    
    func hideBackButton(_ hide: Bool)
}
