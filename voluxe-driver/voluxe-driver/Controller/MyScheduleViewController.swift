//
//  MyScheduleViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/11/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class MyScheduleViewController: UIViewController {

    // MARK:- Data

    private var titlesAndRequests: [(String, [Request])] = []
    private var hasCurrentRequests = false
    private var hasFutureRequests = false
    private var noRequests = false

    // MARK:- Layout

    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RequestTableViewCell")
        tableView.addTopOverScrollView(with: UIColor.Volvo.background.light)
        return tableView
    }()

    private let topOverScrollView: UIView = {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.Volvo.background.light
        return view
    }()

    private let noRequestsView: UIView = {
        let label = UILabel.forAutoLayout()
        label.font = Font.Volvo.subtitle1
        label.numberOfLines = 0
        label.text = Unlocalized.noScheduledRequests
        label.textColor = UIColor.Volvo.granite
        let view = GridLayoutView(layout: .volvoAgent())
        view.isHidden = true
        view.add(subview: label, from: 2, to: 5)
        label.pinToSuperviewTop(spacing: 70)
        return view
    }()

    // MARK:- Lifecycle

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.navigationItem.title = Unlocalized.mySchedule.capitalized
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Volvo.background.light
        Layout.fill(view: self.view, with: self.tableView, useSafeArea: false)
        Layout.fill(view: self.view, with: self.noRequestsView)
        self.startRequestManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppController.shared.requestPushPermissions()
//        self.startRequestManager()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        RequestManager.shared.requestsDidChangeClosure = nil
        RequestManager.shared.stop()
    }

    // MARK:- Updating latest data

    private func startRequestManager() {

        OfflineTaskManager.shared.start()
        
        self.update(with: RequestManager.shared.requests)

        RequestManager.shared.requestsDidChangeClosure = {
            [weak self] requests in
            self?.update(with: requests)
        }

        RequestManager.shared.start()
    }

    // It's important to detail the data structure that is produced because it is
    // used directly in the delegate to hide/show sections.  Essentially the data
    // is an array of tuples with (String, [Request]).  Each tuple is the section
    // title to be shown an array of Request to populate the cell:
    //  Section 0 = (Current, [])
    //  Section 1 = (Upcoming Today, [])
    //  Section 3 = (<future 1>, [])
    //  Section 4 = (<future 2>, [])
    //  Section 5 = (<future 3>, [])
    // Note that Current and Upcoming will ALWAYS be included in the structure
    // even if there are no requests for that section.  This guarantees that
    // there will always be at least TWO sections and anything more is optional.
    // This greatly simplifies the delegate callback logic.
    private func update(with requests: [Request]) {

        Thread.assertIsMainThread()
        self.titlesAndRequests = []

        let current = requests
            .filter { $0.state == .started &&
                      Calendar.current.isDateInToday($0.dealershipTimeSlot.from) }
            .sorted { $0.dealershipTimeSlot.from < $1.dealershipTimeSlot.from }
        self.titlesAndRequests += [(Unlocalized.currentService, current)]

        let today = requests
            .filter { $0.state == .requested &&
                      Calendar.current.isDateInToday($0.dealershipTimeSlot.from) }
            .sorted { $0.dealershipTimeSlot.from < $1.dealershipTimeSlot.from }
        self.titlesAndRequests += [(Unlocalized.upcomingToday, today)]

        // this adds sections for each of the 7 days from the current date
        // each section is appropriately titled by a request during that date
        // these sections are optional i.e. may not have any results whereas
        // Current and Upcoming sections are always there, but possibly with
        // no results
        for i in 1...6 {
            let requests = requests
                .filter { $0.state == .requested && $0.dealershipTimeSlot.from.isDuring(daysFromNow: i) }
                .sorted { $0.dealershipTimeSlot.from < $1.dealershipTimeSlot.from }
            if requests.count > 0 {
                let date = requests[0].dealershipTimeSlot.from
                let title = i == 1 ? Unlocalized.tomorrow : DateFormatter.requestSectionHeader.string(from: date)
                self.titlesAndRequests += [(title, requests)]
            }
        }

        // calculate some state based on the filtered requests
        // these are used elsewhere to save additional calculations
        self.hasCurrentRequests = current.count > 0 || today.count > 0
        self.hasFutureRequests = self.titlesAndRequests.count > 2
        self.noRequests = !self.hasCurrentRequests && !self.hasFutureRequests

        // the table background color needs to change depending on requests
        // if there are future requests, the entire table may not fill the
        // bottom of the screen
        let disabled = self.hasFutureRequests || self.noRequests
        let color = disabled ? UIColor.Volvo.background.dark : UIColor.Volvo.background.light
        self.tableView.backgroundColor = color

        // additionally hide/show the "No requests" view
        self.noRequestsView.isHidden = self.hasCurrentRequests || self.hasFutureRequests

        // TODO https://app.asana.com/0/858610969087925/941718004229101/f
        // TODO how to prevent jumping when scrolling?
        self.tableView.reloadData()
    }
}

// MARK:- Extension for future request section headers

fileprivate extension DateFormatter {

    static let requestSectionHeader: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
}

// MARK:- Extension for table data source

extension MyScheduleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titlesAndRequests.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let (_, requests) = self.titlesAndRequests[section]
        return requests.count
    }

    private func request(for indexPath: IndexPath) -> Request? {
        let (_, requests) = self.titlesAndRequests[indexPath.section]
        return requests[indexPath.row]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTableViewCell",
                                                 for: indexPath)
        cell.selectionStyle = .none
        if let request = self.request(for: indexPath) { cell.update(with: request) }
        return cell
    }
}

// MARK:- Extension for table section headers

extension MyScheduleViewController: UITableViewDelegate {

    // The section header is stylized based on when a request is scheduled.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let (title, _) = self.titlesAndRequests[section]
        switch section {
            case 0: return UITableViewHeaderFooterView.requestSectionHeader(text: title)
            case 1: return UITableViewHeaderFooterView.requestSectionHeader(text: title,
                                                                            separator: !self.hasCurrentRequests,
                                                                            separatorIsFullWidth: false)
            case 2: return UITableViewHeaderFooterView.requestSectionHeader(backgroundColor: UIColor.Volvo.background.dark,
                                                                            text: title,
                                                                            separator: true)
            default: return UITableViewHeaderFooterView.requestSectionHeader(backgroundColor: UIColor.Volvo.background.dark,
                                                                            text: title,
                                                                            separator: true,
                                                                            separatorIsFullWidth: false)
        }
    }

    // The height of the header is based purely on whether there are
    // requests to be rendered.  If not, the view height is simply 0.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let (_, requests) = self.titlesAndRequests[section]
        guard requests.count > 0 else { return 0 }
        return 62
    }

    // This returns a footer view, but only for the "Upcoming" section
    // but only when there are current requests followed by future requests.
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard self.hasCurrentRequests, self.hasFutureRequests else { return nil }
        let view = UIView.forAutoLayout()
        view.backgroundColor = .white
        return view
    }

    // This sets the height for the "Upcoming" footer only but only
    // when there are current requests followed by future requests.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard self.hasCurrentRequests, self.hasFutureRequests else { return 0 }
        switch section {
            case 1: return 20
            default: return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (_, requests) = self.titlesAndRequests[indexPath.section]
        let request = requests[indexPath.row]
        self.navigationController?.pushViewController(RequestViewController(with: request), animated: true)
    }
}

// MARK:- Extension for request section header view

fileprivate extension UITableViewHeaderFooterView {

    static func withBackgroundView(color: UIColor) -> UITableViewHeaderFooterView {
        let view = UITableViewHeaderFooterView(frame: .zero)
        view.backgroundView = UIView.forAutoLayout()
        view.backgroundView?.backgroundColor = color
        return view
    }

    static func requestSectionHeader(backgroundColor: UIColor = .white,
                                     text: String,
                                     separator: Bool = false,
                                     separatorIsFullWidth: Bool = true) -> UITableViewHeaderFooterView
    {
        let gridView = GridLayoutView(layout: .volvoAgent())

        let label = UILabel()
        label.font = Font.Volvo.caption
        label.text = text
        label.textColor = UIColor.Volvo.granite
        gridView.add(subview: label, from: 2, to: 6)
        label.heightAnchor.constraint(equalTo: gridView.heightAnchor).isActive = true

        if separator {
            let separatorView = UIView.forAutoLayout()
            separatorView.backgroundColor = UIColor.Volvo.table.separator
            gridView.addSubview(separatorView)
            let leadingAnchor = separatorIsFullWidth ? gridView.leadingAnchor : gridView.leadingAnchor(for: 1)
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            separatorView.trailingAnchor.constraint(equalTo: gridView.trailingAnchor).isActive = true
            separatorView.pinToSuperviewTop()
            separatorView.constrain(height: 1)
        }

        let view = UITableViewHeaderFooterView.withBackgroundView(color: backgroundColor)
        Layout.fill(view: view.contentView, with: gridView, useSafeArea: false)
        return view
    }
}

// MARK:- Extension for custom Request cell content

fileprivate extension UITableViewCell {

    // Returns the Request specific content view at the root
    // of the table view cell's content view.  If one does not
    // exist, it is created and filled into the cell content view.
    private func contentView() -> RequestCellContentView {

        if let contentView = self.contentView.subviews.first as? RequestCellContentView {
            return contentView
        }

        let contentView = RequestCellContentView()
        Layout.fill(view: self.contentView, with: contentView, useSafeArea: false)
        return contentView
    }

    func update(with request: Request) {
        let contentView = self.contentView()
        contentView.update(with: request)
    }
}

// MARK:- Class for request cell content

fileprivate class RequestCellContentView: GridLayoutView {

    private let typeImageView: UIImageView = {
        let image = UIImage(named: "delivery_to_do")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .topLeft
        return imageView
    }()

    private let loanerImageView: UIImageView = {
        let image = UIImage(named: "loaner_icon")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .topRight
        return imageView
    }()

    private let primaryLabel: UILabel = {
        let label = UILabel.forAutoLayout()
        label.font = Font.Volvo.subtitle1
        label.textColor = UIColor.Volvo.black
        return label
    }()

    private let secondaryLabel: UILabel = {
        let label = UILabel.forAutoLayout()
        label.font = Font.Volvo.subtitle2
        label.textColor = UIColor.Volvo.slate
        return label
    }()

    convenience init() {
        self.init(layout: GridLayout.volvoAgent())
        self.viewDidLoad()
    }

    private func viewDidLoad() {

        self.add(subview: self.typeImageView, to: 1)
        self.typeImageView.pinToSuperviewTop(spacing: 3)

        self.add(subview: self.primaryLabel, from: 2, to: 5)
        self.primaryLabel.constrain(height: 20)
        self.primaryLabel.pinToSuperviewTop()

        self.add(subview: self.loanerImageView, to: 6)
        self.loanerImageView.pinToSuperviewTop(spacing: 3)

        self.add(subview: self.secondaryLabel, from: 2, to: 5)
        self.secondaryLabel.constrain(height: 20)
        self.secondaryLabel.pinTopToBottomOf(view: self.primaryLabel)
    }

    func update(with request: Request) {
        let color = request.isUpcoming ? UIColor.Volvo.background.dark : UIColor.Volvo.background.light
        self.backgroundColor = color
        self.primaryLabel.text = "\(request.timeRangeString) \(request.typeString)"
        self.secondaryLabel.text = request.locationString
        self.typeImageView.image = request.imageForType()
        self.loanerImageView.isHidden = (request.loanerVehicleRequested ?? false) == false
    }
}

// MARK:- Extension for specific Request formatting

fileprivate extension Request {

    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }()

    var timeRangeString: String {
        let fromString = Request.timeFormatter.string(from: self.dealershipTimeSlot.from)
        let toString = Request.timeFormatter.string(from: self.dealershipTimeSlot.to)
        let string = "\(fromString)-\(toString)"
        return string
    }

    var typeString: String {
        return self.isPickup ? "Pickup" : "Delivery"
    }

    var locationString: String {
        guard let location = self.location else { return "No location" }
        return location.cityStreetAddressString
    }

    var isUpcoming: Bool {
        return self.dealershipTimeSlot.from.isLaterThanToday()
    }

    func imageForType() -> UIImage? {
        let upcoming = self.isUpcoming
        if self.isPickup {
            return upcoming ? UIImage(named: "pickup_to_do_grey") : UIImage(named: "pickup_to_do")
        } else {
            return upcoming ? UIImage(named: "delivery_to_do_grey") : UIImage(named: "delivery_to_do")
        }
    }
}
