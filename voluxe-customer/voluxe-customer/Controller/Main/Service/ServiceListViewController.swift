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
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ServiceCell.self, forCellReuseIdentifier: ServiceCell.reuseId)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
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
            MBProgressHUD.hide(for: self.view, animated: true)
            }.onFailure { error in
                Logger.print(error)
                MBProgressHUD.hide(for: self.view, animated: true)
        }        
    }
    
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func showServices(services: [RepairOrderType]) {
        self.services = services
        self.tableView.reloadData()
        
        let viewHeight = self.view.frame.height
        let servicesHeight = CGFloat(services.count) * ServiceCell.height
        if servicesHeight < CGFloat(viewHeight - ServiceCell.height) {
            tableView.snp.remakeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(servicesHeight)
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
        return ServiceCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServiceCell.reuseId, for: indexPath) as! ServiceCell
        // Similar to above, first check if there is a valid section of table.
        // Then we check that for the section there is a row.
        if let services = services {
            let service = services[indexPath.row]
            cell.setService(service: service.name!)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(ServiceDetailViewController(service: services![indexPath.row], canSchedule: true), animated: true)
    }
    
}
