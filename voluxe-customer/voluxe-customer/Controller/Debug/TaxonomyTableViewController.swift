//
//  TaxonomyTableViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 6/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class TaxonomyTableViewController: UITableViewController {

    private var events: [(title: String, array: [String])] = []

    init() {
        super.init(style: .grouped)
        self.navigationItem.title = "Taxonomy"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.initEvents()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initEvents() {

        let analytics = FBAnalytics()
        var names: [String] = []
        analytics.trackOutputClosure = {
            name, params in
            names += [name]
        }

        self.events += [(title: "Details", array: ["Tap to copy event names"])]

        names = []
        for name in AnalyticsEnums.Name.API.allCases { analytics.trackCall(api: name) }
        self.events += [(title: AnalyticsEnums.Event.call.rawValue, array: names.sorted())]

        names = []
        for name in AnalyticsEnums.Name.Button.allCases { analytics.trackClick(button: name) }
        self.events += [(title: AnalyticsEnums.Event.click.rawValue, array: names.sorted())]

        names = []
        for name in AnalyticsEnums.Name.Permission.allCases { analytics.trackChangePermission(permission: name, granted: true) }
        self.events += [(title: AnalyticsEnums.Event.change.rawValue, array: names.sorted())]

        names = []
        for name in AnalyticsEnums.Name.Screen.allCases { analytics.trackView(screen: name) }
        self.events += [(title: AnalyticsEnums.Event.view.rawValue, array: names.sorted())]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.events.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.events[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let event = self.events[section]
        return event.array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let event = self.events[indexPath.section]
        cell.textLabel?.text = event.array[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.section == 0, indexPath.row == 0 else { return }
        var strings: [String] = []
        for i in 1..<self.events.count { strings += self.events[i].array }
        UIPasteboard.general.strings = strings
    }
}
