//
//  DebugTableViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 5/2/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class DebugTableViewController: UITableViewController {

    convenience init() {
        self.init(style: .grouped)
    }

    /// Set in subclass' viewDidLoad() to customize.
    var settings: [(title: String, cellModels: [DebugTableViewCellModel])] = []

    /// Subclasses are encouraged to register their own custom UITableViewCells.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(DebugValueTableViewCell.self, forCellReuseIdentifier: DebugValueTableViewCell.className)
        self.tableView.register(DebugSubtitleTableViewCell.self, forCellReuseIdentifier: DebugSubtitleTableViewCell.className)
    }

    // MARK:- UITableViewDataSource

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settings[section].title
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.settings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings[section].cellModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.settings[indexPath.section].cellModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellReuseIdentifier, for: indexPath)
        cell.accessoryType = .none
        cell.detailTextLabel?.text = nil
        cell.textLabel?.text = model.title
        model.valueClosure?(cell)
        return cell
    }

    // MARK:- UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = self.settings[indexPath.section].cellModels[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) {
            model.actionClosure?(cell)
            model.valueClosure?(cell)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
