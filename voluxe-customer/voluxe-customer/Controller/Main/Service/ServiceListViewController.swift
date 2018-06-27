//
//  ServiceListViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import MBProgressHUD
import RealmSwift

class ServiceListViewController: BaseViewController {
    
    var services: [RepairOrderType]?
    let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
    
    let vehicle: Vehicle
    
    init(vehicle: Vehicle, title: String) {
        self.vehicle = vehicle
        super.init(screenNameEnum: .serviceMilestone)
        self.title = title.capitalized
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CheckmarkCell.self, forCellReuseIdentifier: CheckmarkCell.reuseId)
        tableView.isHidden = true
        tableView.separatorStyle = .none
        
        showProgressHUD()
        RepairOrderAPI().getRepairOrderTypes().onSuccess { services in
            if let services = services?.data?.result {
                if let realm = try? Realm() {
                    try? realm.write {
                        realm.add(services, update: true)
                    }
                    
                    let filteredResults = realm.objects(RepairOrderType.self).filter("name != 'Custom'")
                    self.showServices(services: Array(filteredResults))
                }
            }
            self.hideProgressHUD()
            }.onFailure { error in
                Logger.print(error)
                self.hideProgressHUD()
        }
        
        self.navigationItem.title = self.title
    }
    
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview()
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
        }
        
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-20, height: 1))
        separator.backgroundColor = .luxeLightestGray()
        
        self.tableView.tableFooterView = separator
        
    }
    
    private func showServices(services: [RepairOrderType]) {
        self.tableView.isHidden = false
        self.services = services
        self.tableView.reloadData()
        
        let viewHeight = self.view.frame.height
        let servicesHeight = CGFloat(services.count) * CheckmarkCell.height
        if servicesHeight < CGFloat(viewHeight - CheckmarkCell.height) {
            tableView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview()
                make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
                make.height.equalTo(servicesHeight+1)
            }
        }
        
    }
}

extension ServiceListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let services = services {
            return services.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CheckmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckmarkCell.reuseId, for: indexPath) as! CheckmarkCell
        // Similar to above, first check if there is a valid section of table.
        // Then we check that for the section there is a row.
        if let services = services {
            let service = services[indexPath.row]
            cell.setTitle(title: service.name!)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        VLAnalytics.logEventWithName(AnalyticsConstants.eventClickServiceMilestone, screenName: screenName, index: indexPath.row)
        self.pushViewController(ServiceDetailViewController(vehicle: vehicle, service: services![indexPath.row], canSchedule: true), animated: true, backLabel: .Back)
    }
    
}
