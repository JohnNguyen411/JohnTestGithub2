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

    private let inspectionControl: UISegmentedControl = {
        let control = UISegmentedControl(items: InspectionType.descriptions())
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

    private let statusField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.isUserInteractionEnabled = false
        field.placeholder = "inited"
        field.textAlignment = .center
        return field
    }()

    private let uploadsTable: UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.layer.borderColor = UIColor.lightGray.cgColor
        table.layer.borderWidth = 2
        table.layer.cornerRadius = 20
        return table
    }()

    // MARK:- Lifecycle

    convenience init() {

        self.init(nibName: nil, bundle: nil)
        self.uploadsTable.dataSource = self

        UploadManager.shared.statusChangeClosure = {
            [weak self] status, text in
            guard let me = self else { return }
            me.updateButtons(status: status)
            me.statusField.text = status.rawValue
        }

        UploadManager.shared.uploadsDidChangeClosure = {
            [weak self] uploads in
            self?.uploadsTable.reloadData()
        }
    }

    deinit {
        UploadManager.shared.statusChangeClosure = nil
        UploadManager.shared.uploadsDidChangeClosure = nil
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

        gridView.add(subview: self.statusField, from: 1, to: 6)
        self.statusField.pinTopToBottomOf(view: self.resetButton, spacing: 20)

        gridView.add(subview: self.uploadsTable, from: 1, to: 6)
        self.uploadsTable.pinTopToBottomOf(view: self.statusField, spacing: 20)
        Layout.pinToSuperviewBottom(view: self.uploadsTable)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }

    // MARK:- Data source

    private func currentInspection(completion: @escaping (Request?, Inspection?, InspectionType?) -> ()) {

        guard let request = RequestManager.shared.request else {
            DispatchQueue.main.async() { completion(nil, nil, nil) }
            return
        }

        guard let type = InspectionType(rawValue: self.inspectionControl.selectedSegmentIndex) else {
            DispatchQueue.main.async() { completion(nil, nil, nil) }
            return
        }

        switch type {
            case .document: self.documentInspection(request: request) {
                inspection in
                completion(request, inspection, type)
            }
            case .vehicle: self.vehicleInspection(request: request) {
                inspection in
                completion(request, inspection, type)
            }
            case .loaner: self.loanerInspection(request: request) {
                inspection in
                completion(request, inspection, type)
            }
            case .unknown: assertionFailure("InspectionType must not be unknown")
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
        self.currentInspection() {
            [weak self] request, inspection, type in
            guard let me = self else { return }
            me.updateUI()
            guard let request = request else { return }
            guard let inspection = inspection else { return }
            guard let type = type else { return }
            let image = UIColor.random().image(size: CGSize(width: 1024, height: 1024))
            let (route, parameters) = request.uploadRoute(for: inspection, of: type)
            guard let upload = Upload(route: route, parameters: parameters, image: image) else { return }
            UploadManager.shared.upload(upload)
            self?.updateUI()
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
        let request = RequestManager.shared.request
        self.requestTextField.text = request != nil ? "Request \(request!.id)" : nil
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
        control.isEnabled = (RequestManager.shared.request != nil)
        guard let request = RequestManager.shared.request else { return }
        control.setEnabled(request.isPickup, forSegmentAt: InspectionType.document.rawValue)
        control.setEnabled(request.isPickup, forSegmentAt: InspectionType.vehicle.rawValue)
        control.setEnabled(request.loanerVehicleRequested ?? false, forSegmentAt: InspectionType.loaner.rawValue)
        control.setEnabled(false, forSegmentAt: InspectionType.unknown.rawValue)
    }
}

// MARK:- Extension for upload route

extension Request {

    func uploadRoute(for inspection: Inspection,
                     of type: InspectionType) -> (String, RestAPIParameters?)
    {
        if type == .document {
            let route = "\(self.route)/documents/\(inspection.id)/photos"
            return (route, nil)
        }
        else if type == .loaner || type == .vehicle {
            let route = "v1/vehicle-inspection-photos"
            let parameters = ["vehicle_inspection_id": inspection.id]
            return (route, parameters)
        }
        else {
            // TODO https://app.asana.com/0/858610969087925/935159618076287/f
            // TODO Log.assert()
            assertionFailure("Unsupported InspectionType")
            return ("Unsupported route", nil)
        }
    }
}

// MARK:- Uploads table data source

extension UploadManagerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UploadManager.shared.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let uploads = UploadManager.shared.currentUploads()
        let upload = uploads[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.update(with: upload)
            return cell
        } else {
            return UITableViewCell(with: upload)
        }
    }
}

// MARK:- Table cell for uploads

extension UITableViewCell {

    convenience init(with upload: Upload) {
        self.init(style: .subtitle, reuseIdentifier: "cell")
        self.textLabel?.adjustsFontSizeToFitWidth = true
        self.detailTextLabel?.numberOfLines = 0
        self.detailTextLabel?.textColor = UIColor.gray
        self.update(with: upload)
    }

    func update(with upload: Upload) {
        self.textLabel?.text = upload.route
        var text = "\(DateFormatter.localizedString(from: upload.date, dateStyle: .short, timeStyle: .medium))"
        for (data, mimeType) in upload.datasAndMimeTypes() {
            text = "\(text)\n\(data.count) bytes, \(mimeType)"
        }
        self.detailTextLabel?.text = text
    }
}

// MARK:- Extension to get array of descriptions

extension InspectionType {

    static func descriptions() -> [String] {
        var strings: [String] = []
        for type in self.allCases { strings += [type.description] }
        return strings
    }
}
