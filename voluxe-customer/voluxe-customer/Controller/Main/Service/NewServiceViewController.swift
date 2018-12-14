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
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let vehicle: Vehicle
    let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
    var services: [String]?
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        super.init(screen: .serviceNew)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = .NewService

        self.showProgressHUD()
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CheckmarkCell.self, forCellReuseIdentifier: CheckmarkCell.reuseId)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        CustomerAPI.repairOrderTypes() { services, error in
            self.hideProgressHUD()
            
            if error != nil {
                Logger.print("\(error?.code?.rawValue ?? "") \(error?.message ?? "")")
            } else {
                if let realm = try? Realm() {
                    try? realm.write {
                        realm.deleteAll(RepairOrderType.self)
                        realm.add(services)
                    }
                }
                
                var containsCustom = false
                for service in services {
                    if service.getCategory() == .custom {
                        containsCustom = true
                        break
                    }
                }
                
                if containsCustom {
                    self.showServices(repairOrderTypes: [String.MilestoneServices, String.OtherMaintenanceRepairs])
                } else {
                    self.showServices(repairOrderTypes: [String.MilestoneServices])
                }
            }
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(introLabel)
        self.view.addSubview(tableView)

        let labelHeight = introLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height

        introLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.top.equalTo(introLabel.snp.bottom).offset(BaseViewController.defaultTopYOffset)
            make.height.equalTo(CheckmarkCell.height*2+1)
        }
        
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-20, height: 1))
        separator.backgroundColor = .luxeLightestGray()
        
        self.tableView.tableFooterView = separator
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
        return CheckmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckmarkCell.reuseId, for: indexPath) as! CheckmarkCell
        if let groupService = services {
            cell.setTitle(title: groupService[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let groupService = services, indexPath.row == 0 {
            Analytics.trackClick(button: .serviceMilestone, screen: self.screen)
            self.pushViewController(ServiceListViewController(vehicle: vehicle, title: groupService[indexPath.row]), animated: true)
        } else {
            if let realm = try? Realm() {
                
                if let filteredResults = realm.objects(RepairOrderType.self, predicate: "category = '\(RepairOrderCategory.custom.rawValue)'").first {
                    Analytics.trackClick(button: .serviceCustom, screen: self.screen)
                    self.pushViewController(ServiceMultiselectListViewController(vehicle: vehicle, repairOrderType: filteredResults), animated: true)
                }
            }
        }
    }
    
}
