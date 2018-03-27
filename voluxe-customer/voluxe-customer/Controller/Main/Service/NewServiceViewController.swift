//
//  NewServiceViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/12/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import RealmSwift
import MBProgressHUD

class NewServiceViewController: BaseViewController {
    
    let introLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .NewServiceIntro
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let vehicle: Vehicle
    let tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
    var services: [String]?
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
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
        tableView.isScrollEnabled = false
        
        RepairOrderAPI().getRepairOrderTypes().onSuccess { services in
            if let services = services?.data?.result {
                if let realm = try? Realm() {
                    try? realm.write {
                        realm.add(services, update: true)
                    }
                    
                    self.showServices(repairOrderTypes: [String.MilestoneServices, String.OtherMaintenanceRepairs])
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
        
        self.view.addSubview(introLabel)
        self.view.addSubview(tableView)
        let labelHeight = introLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height

        introLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(introLabel)
            make.top.equalTo(introLabel.snp.bottom).offset(20)
            make.height.equalTo(ServiceCell.height*4)
        }
        
    }
    
    private func showServices(repairOrderTypes: [String]) {
        self.services = repairOrderTypes
        tableView.reloadData()
    }
    
    
}

extension NewServiceViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        if let groupService = services {
            cell.setService(service: groupService[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(ServiceListViewController(vehicle: vehicle), animated: true)
        } else {
            if let realm = try? Realm() {
                if let filteredResults = realm.objects(RepairOrderType.self).filter("category = '\(RepairOrderCategory.custom.rawValue)'").first {
                    self.navigationController?.pushViewController(ServiceMultiselectListViewController(vehicle: vehicle, repairOrderType: filteredResults), animated: true)
                }
            }
        }
    }
    
}
