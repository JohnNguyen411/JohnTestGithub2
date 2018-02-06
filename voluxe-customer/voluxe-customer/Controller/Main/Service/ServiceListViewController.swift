//
//  ServiceListViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/1/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class ServiceListViewController: BaseViewController {
    
    var mockRoutineServices: [Service] = [Service(name: "Oil Change", price: 100.0), Service(name: "Rotate/Balance Tires", price: 100.0), Service(name: "Check Fluids", price: 100.0),
                                          Service(name: "Battery Inspection", price: 100.0), Service(name: "Replace Cabin Air Filter", price: 100.0), Service(name: "Replace Engine Air Filter", price: 100.0),
                                          Service(name: "Replace Spark Plugs", price: 100.0)]
    
    var mockRepairsServices: [Service] = [Service(name: "Replace Windshield", price: 100.0), Service(name: "Replace Window", price: 100.0), Service(name: "Repair Body", price: 100.0),
                                          Service(name: "Touch up Paint", price: 100.0), Service(name: "Another Repair", price: 100.0), Service(name: "Another Repair", price: 100.0)]
    
    
    var services: [ServiceGroup]?
    let tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
    
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
        
        showServices(services: [ServiceGroup(name: "Routine Services", services: mockRoutineServices), ServiceGroup(name: "Repairs", services: mockRoutineServices)])
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func showServices(services: [ServiceGroup]) {
        self.services = services
        tableView.reloadData()
    }
    
}

extension ServiceListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let groupServices = services {
            if let services = groupServices[section].services {
                return services.count
            }
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
        if let groupService = services {
            if let serviceList = groupService[indexPath.section].services {
                let service = serviceList[indexPath.row]
                cell.setService(service: service.name!)
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let services = services {
            return services.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ServiceCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let services = services {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: ServiceCell.height))
            view.backgroundColor = UIColor.clear
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: ServiceCell.height))
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textColor = UIColor.luxeDarkGray()
            label.text = services[section].name?.uppercased()
            view.addSubview(label)
            return view
        }
        return nil
    }
    
}
