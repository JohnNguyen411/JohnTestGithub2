//
//  ServiceMultiselectListViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/13/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class ServiceMultiselectListViewController: BaseViewController {
    
    let introLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .WhatPartRequiresService
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let introLabelBold: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .SelectAllThatApply
        textView.font = .volvoSansProMedium(size: 12)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
    let confirmButton = VLButton(type: .bluePrimary, title: (.Next as String).uppercased(), kern: UILabel.uppercasedKern(), actionBlock: nil)

    let vehicle: Vehicle
    let repairOrderType: RepairOrderType
    var services: [String]?
    var selected = [Int: Bool]()
    
    init(vehicle: Vehicle, repairOrderType: RepairOrderType) {
        self.vehicle = vehicle
        self.repairOrderType = repairOrderType
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
        tableView.register(CheckableTableViewCell.self, forCellReuseIdentifier: CheckableTableViewCell.reuseId)
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        showServices(services: [.VehicleExt, .VehicleInt, .UnderTheHood, .IDontKnow])
        
        confirmButton.setActionBlock {
            guard let services = self.services else {
                return
            }
            var selectedService: [String] = []
            for dictElement in self.selected.enumerated() {
                if dictElement.element.value {
                    selectedService.append(services[dictElement.element.key])
                }
            }
            self.pushViewController(OtherServiceViewController(vehicle: self.vehicle, repairOrderType: self.repairOrderType, services: selectedService), animated: true, backLabel: .Back)
        }
        
        self.navigationItem.title = .OtherMaintenance
    }
    
    override func setupViews() {
        super.setupViews()
        
        let containerView = UIView(frame: .zero)
        self.view.addSubview(containerView)

        containerView.addSubview(introLabel)
        containerView.addSubview(introLabelBold)
        containerView.addSubview(tableView)
        containerView.addSubview(confirmButton)
                
        containerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        introLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        introLabelBold.snp.makeConstraints { make in
            make.left.right.equalTo(introLabel)
            make.top.equalTo(introLabel.snp.bottom).offset(5)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalTo(introLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(introLabelBold.snp.bottom).offset(30)
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
        }
        
        let separator = UIView(frame: CGRect(x: 20, y: 0, width: self.view.frame.width-20, height: 1))
        separator.backgroundColor = .luxeLightestGray()
        
        self.tableView.tableFooterView = separator
        
    }
    
    private func showServices(services: [String]) {
        self.services = services
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension ServiceMultiselectListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let services = services {
            return services.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CheckableTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckableTableViewCell.reuseId, for: indexPath) as! CheckableTableViewCell
        if let services = services {
            var selectedRow = selected[indexPath.row]
            if selectedRow == nil {
                selectedRow = false
            }
            cell.setText(text: services[indexPath.row], selected: selectedRow!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let rowSelected = selected[indexPath.row] {
            selected[indexPath.row] = !rowSelected
        } else {
            selected[indexPath.row] = true
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
