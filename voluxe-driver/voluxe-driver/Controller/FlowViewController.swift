//
//  FlowViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class StepViewController: UIViewController {

    convenience init(title: String = "NO TITLE") {
        self.init(nibName: nil, bundle: nil)
        self.navigationItem.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}

class FlowViewController: UIViewController {

    // MARK: Data

    private var steps: [Step] = []

    // MARK: Lifecycle

    convenience init(steps: [Step]) {
        self.init(nibName: nil, bundle: nil)
        self.steps = steps
        if let step = steps.first { self.navigationItem.title = step.title }

        // TODO move to class?
        let label = UILabel(text: "\u{2039}")
        let item = UIBarButtonItem(customView: label)
        self.navigationItem.backBarButtonItem = item
    }

    override func loadView() {
        self.view = StepView()
    }
}

struct Step {
    let title: String
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
