//
//  RequestViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class RequestViewController: UIViewController {

    // MARK: Data

    // TODO completed
    // TODO can redo once completed
    struct Step {
        let title: String
        let nextTitle: String
    }

    // TODO localize
    var stepIndex = 0
    let steps: [Step] = [Step(title: "Review Service", nextTitle: "Slide to start service"),
                         Step(title: "Get Vehicle and Paperwork", nextTitle: "slide to begin drive"),
                         Step(title: "Drive to Customer", nextTitle: "slide when you've arrived"),
                         Step(title: "Arrive at Customer", nextTitle: "slide to inspect vehicle"),
                         Step(title: "Photo Customer Vehicle", nextTitle: ""),
                         Step(title: "Receive Loaner", nextTitle: "slide to inspect loaner"),
                         Step(title: "Photo Loaner", nextTitle: ""),
                         Step(title: "Exchange keys", nextTitle: "slide to return to dealership"),
                         Step(title: "Return to Dealership", nextTitle: "slide when you've arrived"),
                         Step(title: "Record Loaner Mileage", nextTitle: "slide to end service")]

    // MARK: Layout

    private let swipeNextView = SwipeNextView()

    // MARK: Lifecycle

    // TODO should not be allowed to start service unless day of
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.swipeNextView.title = self.steps.first?.nextTitle
        self.navigationItem.title = self.steps.first?.title.capitalized
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_chevron"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(backButtonTouchUpInside))
        self.addActions()
    }

    // TODO present request for review
    // then if accepted capture RequestManager.requestDidChange()
    convenience init(with request: Request) {
        self.init()
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light

        Layout.add(subview: self.swipeNextView, pinnedToBottomOf: self.view)
        self.swipeNextView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.swipeNextView.addBottomSafeAreaCoverView()
    }

    // MARK: Stack navigation

    private func currentStep() -> Step {
        return self.steps[self.stepIndex]
    }

    // TODO how to update nav bar title?
    private func update(animated: Bool = true) {
        let step = self.currentStep()
        self.navigationItem.title = step.title.capitalized
        self.swipeNextView.title = step.nextTitle
    }

    @discardableResult
    private func nextStep() -> Bool {
        guard self.stepIndex < (self.steps.count - 1) else { return false }
        self.stepIndex += 1
        self.update()
        return true
    }

    @discardableResult
    private func previousStep() -> Bool {
        guard self.stepIndex > 0 else { return false }
        self.stepIndex -= 1
        self.update()
        return true
    }

    // MARK: Actions

    private func addActions() {
        self.swipeNextView.nextClosure = {
            guard self.nextStep() == false else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func backButtonTouchUpInside() {
        guard self.previousStep() == false else { return }
        self.navigationController?.popViewController(animated: true)
    }
}
