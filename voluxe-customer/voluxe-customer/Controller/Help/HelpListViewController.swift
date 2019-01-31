//
//  HelpListViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/26/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class HelpListViewController: BaseViewController {
    
    static let volvoPhoneNumber = "+12017324028" // Harisson
    static let volvoEmail = "volvosupport@luxe.com"
    
    let helpSection: HelpSection
    
    let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
    let user: Customer?
    var booking: Booking?
    
    // provide a booking and request object
    init(helpSection: HelpSection, booking: Booking? = nil, request: Request? = nil) {
        user = UserManager.sharedInstance.getCustomer()
        self.booking = booking
        self.helpSection = helpSection
        super.init(screen: .helpList)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = .localized(.help)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdIndicator)
        tableView.isScrollEnabled = true
    
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
        }
    }
}

extension HelpListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpSection.sections.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdIndicator, for: indexPath) as! SettingsCell
        cell.setText(text: .localized(helpSection.sections[indexPath.row].title))
        cell.setCellType(type: .indicator)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingsCell.height
    }
    
    
}

extension HelpListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let helpDetail = helpSection.sections[indexPath.row]
        var actions: [HelpAction] = []
        if helpSection.type == .booking {
            if let booking = self.booking, let dealership = booking.dealership {
                if let phoneNumber = dealership.phoneNumber {
                    let actionCall = HelpAction(title: .localized(.viewHelpOptionDetailCallDealer), type: .call, value: phoneNumber)
                    actions.append(actionCall)
                }
                if let email = dealership.email {
                    let actionEmail = HelpAction(title: .localized(.viewHelpOptionDetailEmailDealer), type: .email, value: email)
                    actions.append(actionEmail)
                }
            }
        } else if helpSection.type == .app {
            if helpDetail.title == .viewTosContentTermsOfServiceTitle {
                let actionWebview = HelpAction(title: .localized(.viewTosContentTermsOfServiceTitle), type: .webview, value: .localized(.viewTosContentTermsOfServiceUrl))
                actions.append(actionWebview)
            } else if helpDetail.title == .viewTosContentPrivacyPolicyTitle {
                let actionWebview = HelpAction(title: .localized(.viewTosContentPrivacyPolicyTitle), type: .webview, value: .localized(.viewTosContentPrivacyPolicyUrl))
                actions.append(actionWebview)
            } else {
                let actionCall = HelpAction(title: .localized(.viewHelpOptionDetailCallVolvo), type: .call, value: HelpListViewController.volvoPhoneNumber)
                let actionEmail = HelpAction(title: .localized(.viewHelpOptionDetailEmailVolvo), type: .email, value: HelpListViewController.volvoEmail)
                actions.append(actionCall)
                actions.append(actionEmail)
            }
        }
        self.pushViewController(HelpDetailViewController(type: self.helpSection.type, helpDetail: helpDetail, actions: actions), animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SettingsCell.height))
        view.backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SettingsCell.height))
        label.font = .volvoSansProMedium(size: 13)
        label.textColor = UIColor.luxeGray()
        label.text = helpSection.title.uppercased()
        view.addSubview(label)
        return view
    }
}


