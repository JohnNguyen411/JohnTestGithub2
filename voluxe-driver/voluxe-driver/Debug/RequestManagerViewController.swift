//
//  RequestManagerViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 11/27/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class RequestManagerViewController: UIViewController {

    // MARK:- Table data sources

    private let requestsTableDataSource = RequestsTableDataSource()
    private let inspectionsTableDataSource = InspectionsTableDataSource()

    // MARK:- Layout

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.text = "Tap a request to make active, then add inspections.  Note that the request type and state determines which inspections can be added."
        return label
    }()

    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("\u{21BB}", for: .normal)
        button.addTarget(self, action: #selector(startButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    private let requestsTable: UITableView = {
        let table = UITableView()
        table.allowsMultipleSelection = false
        table.layer.borderColor = UIColor.lightGray.cgColor
        table.layer.borderWidth = 2
        table.layer.cornerRadius = 20
        return table
    }()

    private let documentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Document", for: .normal)
        button.addTarget(self, action: #selector(documentButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    private let loanerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loaner", for: .normal)
        button.addTarget(self, action: #selector(loanerButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    private let vehicleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Vehicle", for: .normal)
        button.addTarget(self, action: #selector(vehicleButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.addTarget(self, action: #selector(clearButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    private let inspectionsTable: UITableView = {
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
        self.requestsTable.dataSource = self.requestsTableDataSource
        self.requestsTable.delegate = self
        self.inspectionsTable.dataSource = self.inspectionsTableDataSource

        RequestManager.shared.requestDidChangeClosure = {
            [weak self] request in
            self?.updateUI()
        }

        // TODO clean up
        RequestManager.shared.requestsDidChangeClosure = {
            [weak self] requests in
            self?.updateUI()
        }

        RequestManager.shared.offlineInspectionsDidChangeClosure = {
            [weak self] inspections in
            self?.updateUI()
        }
    }

    deinit {
        // TODO unregister from RequestManager
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationItem.title = "RequestManager"
        self.view.backgroundColor = .white

        let scrollView = Layout.scrollView(in: self)
        let contentView = Layout.verticalContentView(in: scrollView)
        let gridLayout = GridLayout.fourColumns()
        let gridView = contentView.addGridLayoutView(with: gridLayout)

        gridView.add(subview: self.instructionLabel, from: 1, to: 3)
        self.instructionLabel.pinToSuperviewTop(spacing: 20)

        gridView.add(subview: self.startButton, to: 4)
        self.startButton.pinToSuperviewTop(spacing: 20)

        gridView.add(subview: self.requestsTable, from: 1, to: 4)
        self.requestsTable.pinTopToBottomOf(view: self.instructionLabel, spacing: 20)
        self.requestsTable.heightAnchor.constraint(equalToConstant: 200).isActive = true

        gridView.add(subview: self.documentButton, to: 1)
        self.documentButton.pinTopToBottomOf(view: self.requestsTable, spacing: 20)

        gridView.add(subview: self.loanerButton, to: 2)
        self.loanerButton.pinTopToBottomOf(view: self.requestsTable, spacing: 20)

        gridView.add(subview: self.vehicleButton, to: 3)
        self.vehicleButton.pinTopToBottomOf(view: self.requestsTable, spacing: 20)

        gridView.add(subview: self.clearButton, to: 4)
        self.clearButton.pinTopToBottomOf(view: self.requestsTable, spacing: 20)

        gridView.add(subview: self.inspectionsTable, from: 1, to: 4)
        self.inspectionsTable.pinTopToBottomOf(view: self.clearButton, spacing: 20)
        Layout.pinToSuperviewBottom(view: self.inspectionsTable)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RequestManager.shared.set(driver: DriverManager.shared.driver)
    }

    // MARK:- Actions

    @objc func startButtonTouchUpInside() {
        if RequestManager.shared.isStarted {
            RequestManager.shared.stop()
            self.startButton.stopSpinning()
        } else {
            RequestManager.shared.start()
            self.startButton.startSpinning()
        }
    }

    @objc func documentButtonTouchUpInside() {
        let photo = UIColor.random().image(size: CGSize(width: 1024, height: 1024))
        RequestManager.shared.addDocumentInspection(photo: photo)
    }

    @objc func loanerButtonTouchUpInside() {
        let photo = UIColor.random().image(size: CGSize(width: 1024, height: 1024))
        RequestManager.shared.addLoanerInspection(photo: photo)
    }

    @objc func vehicleButtonTouchUpInside() {
        let photo = UIColor.random().image(size: CGSize(width: 1024, height: 1024))
        RequestManager.shared.addVehicleInspection(photo: photo)
    }

    @objc func clearButtonTouchUpInside() {
        RequestManager.shared.clear()
    }

    // MARK:- UI updates

    private func updateUI() {
        let manager = RequestManager.shared
        let request = manager.request
        let inspections = manager.offlineInspections()
        let enabled = request != nil
        self.documentButton.isEnabled = enabled && (request?.isPickup ?? false)
        self.loanerButton.isEnabled = enabled && (request?.loanerVehicleRequested ?? false)
        self.vehicleButton.isEnabled = enabled
        self.clearButton.isEnabled = !inspections.isEmpty
        self.requestsTable.reloadData()
        self.inspectionsTable.reloadData()

        let spin = manager.isStarted
        spin ? self.startButton.startSpinning() : self.startButton.stopSpinning()
    }
}

// MARK:- Table data sources

class RequestsTableDataSource: NSObject, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RequestManager.shared.requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let request = RequestManager.shared.requests[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") {
            cell.update(with: request)
            return cell
        } else {
            return UITableViewCell(with: request)
        }
    }
}

class InspectionsTableDataSource: NSObject, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RequestManager.shared.offlineInspections().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inspection = RequestManager.shared.offlineInspections()[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InspectionCell") {
            cell.update(with: inspection)
            return cell
        } else {
            return UITableViewCell(with: inspection)
        }
    }
}

// MARK:- Table delegates

extension RequestManagerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView == self.requestsTable else { return }
        let request = RequestManager.shared.requests[indexPath.row]
        RequestManager.shared.select(request: request)
    }
}

// MARK:- Debug output extension

fileprivate extension Request {

    var typeString: String {
        switch self.type {
            case .advisorPickup: return "Advisor drop off"
            case .advisorDropoff: return "Advisor pick up"
            case .dropoff: return "Drop off"
            case .pickup: return "Pick up"
        }
    }

    var locationString: String {
        guard let location = self.location else { return "No location" }
        return location.address
    }

    var documentInspectionString: String {
        guard let documents = self.documents else { return "No document inspections" }
        return "Document inspections (\(documents.count))"
    }

    var loanerInspectionString: String {
        guard let inspection = self.loanerInspection else { return "No loaner inspection" }
        return "Loaner inspection \(inspection.id)"
    }

    var vehicleInspectionString: String {
        guard let inspection = self.vehicleInspection else { return "No vehicle inspection" }
        return "Vehicle inspection \(inspection.id)"
    }
}

// MARK:- Table cell extension for models

fileprivate extension UITableViewCell {

    convenience init(reuseIdentifier: String) {
        self.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.numberOfLines = 0
        self.detailTextLabel?.textColor = UIColor.gray
    }

    convenience init(with request: Request) {
        self.init(reuseIdentifier: "RequestCell")
        self.update(with: request)
    }

    func update(with request: Request) {
        self.textLabel?.text = "Request \(request.id)"
        var text = "\(request.typeString) - \(request.state.uppercased())\n"
        text = "\(text)\(request.locationString)\n"
        text = "\(text)\(request.documentInspectionString)\n"
        text = "\(text)\(request.loanerInspectionString)\n"
        text = "\(text)\(request.vehicleInspectionString)\n"
        self.detailTextLabel?.text = text
        let selected = RequestManager.shared.isSelected(request: request)
        self.accessoryType = selected ? .checkmark : .none
        self.backgroundColor = selected ? Color.Debug.blue : nil
    }

    convenience init(with inspection: OfflineInspection) {
        self.init(reuseIdentifier: "InspectionCell")
        self.update(with: inspection)
    }

    func update(with offlineInspection: OfflineInspection) {
        var text = ""
        if let request = offlineInspection.request { text = "Request \(request.id)"}
        if let inspection = offlineInspection.inspection { text = "\(text), Inspection \(inspection.id)" }
        self.textLabel?.text = text
        text = "\(offlineInspection.type.rawValue), \(offlineInspection.data.count) bytes"
        if offlineInspection.isUploaded { text = "\(text), added to UploadManager" }
        self.detailTextLabel?.text = text
    }
}
