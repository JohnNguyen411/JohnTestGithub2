//
//  NewServiceViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/12/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

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
    
    let tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
    var services: [ServiceGroup]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showServices(services: [ServiceGroup(name: String.MilestoneServices, services: nil), ServiceGroup(name: String.RecallServices, services: nil), ServiceGroup(name: String.OtherMaintenanceRepairs, services: nil)])
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.view.addSubview(introLabel)
        self.view.addSubview(tableView)
        
        //todo constraints

        
    }
    
    private func showServices(services: [ServiceGroup]) {
        self.services = services
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
            cell.setService(service: groupService[indexPath.row].name!)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: false)
    }
    
}
