//
//  UploadManagerViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 11/19/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class UploadManagerViewController: UIViewController {

    // MARK:- Active request context

    var driver: Driver?
    var request: Request?

    // MARK:- UI declarations

    private let requestTextField: UITextField = {
        let field = UITextField()
        field.isUserInteractionEnabled = false
        field.borderStyle = .roundedRect
        field.placeholder = "No active request"
        return field
    }()

    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.addTarget(self, action: #selector(createButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    enum InspectionType: Int, CaseIterable, CustomStringConvertible {

        case document = 0
        case vehicle
        case loaner

        var description: String {
            switch self {
                case .document: return "Document"
                case .loaner: return "Loaner"
                case .vehicle: return "Vehicle"
            }
        }

        static func strings() -> [String] {
            var strings: [String] = []
            for type in self.allCases { strings += [type.description] }
            return strings
        }
    }

    private let inspectionControl: UISegmentedControl = {
        let control = UISegmentedControl(items: InspectionType.strings())
        control.selectedSegmentIndex = 0
        return control
    }()

    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "Start uploading after creating uploads"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private let startToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(startToggleValueChanged), for: .valueChanged)
        return toggle
    }()

    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload", for: .normal)
        button.addTarget(self, action: #selector(uploadButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.addTarget(self, action: #selector(resetButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    private let statusTextView: UITextView = {
        let view = UITextView(frame: CGRect.zero)
        view.isEditable = false
        view.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 20
        return view
    }()

    // MARK:- Lifecycle

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        UploadManager.shared.statusChangeClosure = {
            [weak self] status, text in
            guard let me = self else { return }
            me.updateButtons(status: status)
            me.statusTextView.selectedRange = NSRange(location: 0, length: 0)
            me.statusTextView.insertText("\(status.rawValue)\n")
        }
    }

    deinit {
        UploadManager.shared.statusChangeClosure = nil
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationItem.title = "UploadManager"
        self.view.backgroundColor = .white

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridView = contentView.addGridLayoutView()

        gridView.add(subview: self.requestTextField, from: 1, to: 4)
        self.requestTextField.pinToSuperviewTop(spacing: 20)

        gridView.add(subview: self.createButton, from: 5, to: 6)
        self.createButton.pinToSuperviewTop(spacing: 20)

        gridView.add(subview: self.inspectionControl, from: 1, to: 6)
        self.inspectionControl.pinTopToBottomOf(view: self.requestTextField, spacing: 20)

        gridView.add(subview: self.startToggle, to: 1)
        self.startToggle.pinTopToBottomOf(view: self.inspectionControl, spacing: 20)

        gridView.add(subview: self.startLabel, from: 2, to: 6)
        self.startLabel.pinTopToBottomOf(view: self.inspectionControl, spacing: 20)
        self.startLabel.heightAnchor.constraint(equalTo: self.startToggle.heightAnchor).isActive = true

        gridView.add(subview: self.uploadButton, from: 1, to: 3)
        self.uploadButton.pinTopToBottomOf(view: self.startLabel, spacing: 20)

        gridView.add(subview: self.resetButton, from: 4, to: 6)
        self.resetButton.pinTopToBottomOf(view: self.startLabel, spacing: 20)

        gridView.add(subview: self.statusTextView, from: 1, to: 6)
        self.statusTextView.pinTopToBottomOf(view: self.uploadButton, spacing: 20)
        Layout.pinToSuperviewBottom(view: self.statusTextView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
        self.currentRequest() {
            [weak self] request in
            self?.updateUI()
        }
    }

    // MARK:- Data source

    // TODO https://app.asana.com/0/857710273846914/894650916838382/f
    // TODO replace with DriverManager
    private func currentDriver(completion: @escaping (Driver?) -> ()) {

        if let driver = self.driver {
            DispatchQueue.main.async() { completion(driver) }
            return
        }

        DriverAPI.login(email: "christoph@luxe.com", password: "shenoa7777") {
            driver, error in
            completion(driver)
        }
    }

    // TODO https://app.asana.com/0/857710273846914/865596318171593/f
    // TODO replace with RequestManager
    private func currentRequest(completion: @escaping (Request?) -> ()) {

        if let request = self.request {
            DispatchQueue.main.async() { completion(request) }
            return
        }

        self.currentDriver() {
            driver in
            guard let driver = driver else { return }
            DriverAPI.today(for: driver) {
                [weak self] requests, error in
                self?.request = requests.first
                completion(requests.first)
            }
        }
    }

    private func currentInspection(completion: @escaping (Inspection?) -> ()) {

        guard let request = self.request else {
            DispatchQueue.main.async() { completion(nil) }
            return
        }

        guard let type = InspectionType(rawValue: self.inspectionControl.selectedSegmentIndex) else {
            DispatchQueue.main.async() { completion(nil) }
            return
        }

        switch type {
            case .document: self.documentInspection(request: request, completion: completion)
            case .vehicle: self.vehicleInspection(request: request, completion: completion)
            case .loaner: self.loanerInspection(request: request, completion: completion)
        }
    }

    // Document inspections are not re-used, so create a new one each time.
    private func documentInspection(request: Request, completion: @escaping (Inspection?) -> ()) {
        DriverAPI.createDocumentInspection(for: request) {
            inspection, error in
            completion(inspection)
        }
    }

    private func vehicleInspection(request: Request, completion: @escaping (Inspection?) -> ()) {

        if let inspection = request.vehicleInspection {
            DispatchQueue.main.async() { completion(inspection) }
            return
        }

        DriverAPI.createVehicleInspection(for: request) {
            inspection, error in
            completion(inspection)
        }
    }

    private func loanerInspection(request: Request, completion: @escaping (Inspection?) -> ()) {

        if let inspection = request.loanerInspection {
            DispatchQueue.main.async() { completion(inspection) }
            return
        }

        DriverAPI.createLoanerInspection(for: request) {
            inspection, error in
            completion(inspection)
        }
    }

    // MARK:- Actions

    @objc func createButtonTouchUpInside() {
        self.currentRequest() {
            [weak self] request in
            self?.updateUI()
            guard let request = request else { return }
            self?.currentInspection() {
                [weak self] inspection in
                self?.updateUI()
                guard let inspection = inspection else { return }
                for _ in 1...10 {
                    let photo = UIColor.random().image()
                    guard let route = DriverAPI.routeToUploadPhoto(inspection: inspection, request: request) else { continue }
                    UploadManager.shared.upload(photo, to: route)
                }
                self?.updateUI()
            }
        }
    }

    @objc func uploadButtonTouchUpInside() {
        UploadManager.shared.start()
    }

    @objc func resetButtonTouchUpInside() {
        UploadManager.shared.clear()
    }

    @objc func startToggleValueChanged() {
        UploadManager.shared.startOnUpload = self.startToggle.isOn
        self.updateButtons()
    }

    // MARK:- UI updates

    private func updateUI() {
        self.updateButtons()
        self.updateControls()
        self.updateFields()
    }

    private func updateFields() {
        self.requestTextField.text = self.request != nil ? "Request \(request!.id)" : "No active request"
    }

    private func updateButtons(status: UploadManager.Status? = nil) {

        let status = status ?? .idle

        let manager = UploadManager.shared
        self.startToggle.isOn = manager.startOnUpload

        let count = manager.count()
        let title = count > 0 ? "Upload (\(count))" : "Upload"
        self.uploadButton.setTitle(title, for: .normal)
        self.uploadButton.isEnabled = !manager.startOnUpload && count > 0 && status == .idle
    }

    private func updateControls() {
        let control = self.inspectionControl
        control.isEnabled = (self.request != nil)
        guard let request = self.request else { return }
        control.setEnabled(request.isPickup, forSegmentAt: InspectionType.document.rawValue)
        control.setEnabled(request.isPickup, forSegmentAt: InspectionType.vehicle.rawValue)
        control.setEnabled(request.loanerVehicleRequested ?? false, forSegmentAt: InspectionType.loaner.rawValue)
    }
}
