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
        
        if hasBackButton() {
            self.navigationItem().leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_chevron"), style: .plain, target: self, action: #selector(backButtonTouchUpInside))
        }
        
        if hasNextButton() {
            self.navigationItem().rightBarButtonItem = UIBarButtonItem(title: .localized(.next), style: .plain, target: self, action: #selector(nextButtonTouchUpInside))
            self.navigationItem().rightBarButtonItem?.tintColor = UIColor.Volvo.brightBlue
        }
        
    }
    
    deinit {
        self.saveStepState()
    }
    
    // MARK: Actions
    @objc func nextButtonTouchUpInside() {}
    
    @objc func backButtonTouchUpInside() {}
    
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
    
    func hasBackButton() -> Bool {
        return false
    }
    
    func hasNextButton() -> Bool {
        return false
    }
    
    func nextButtonTitle(_ title: String) {
        self.navigationItem().rightBarButtonItem?.title = title
    }
    
    func nextButtonEnabled(enabled: Bool) {
        self.navigationItem().rightBarButtonItem?.isEnabled = enabled
    }
    
    private func navigationItem() -> UINavigationItem {
        if let navigationItem = self.navigationController?.topViewController?.navigationItem {
            return navigationItem
        }
        return self.navigationItem
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
