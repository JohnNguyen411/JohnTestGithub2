//
//  SettingsViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/6/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class SettingsViewController: BaseViewController, SettingsCellProtocol {
    
    let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
    let user: Customer?
    var vehicles: [Vehicle]?
    var vehicleCount = 0
    
    init() {
        user = UserManager.sharedInstance.getCustomer()
        vehicles = UserManager.sharedInstance.getVehicles()
        if let vehicles = vehicles {
            vehicleCount = vehicles.count
        }
        super.init(screen: .settings)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdIndicator)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdToogle)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // update data
        vehicles = UserManager.sharedInstance.getVehicles()
        if let vehicles = vehicles {
            vehicleCount = vehicles.count
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setNavigationBarItem()
    }
    
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.equalsToTop(view: self.view, offset: BaseViewController.defaultTopYOffset)
        }
    }
    
    func getTitleForSection(section: Int) -> String {
        if section == 0 {
            return UserManager.sharedInstance.yourVolvoStringTitle()
        } else if section == 1 {
            return .yourAccount
        } else {
            return .viewSettingsDistanceUnitHeader
        }
    }
    
    func getTextForIndexPath(indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            if let vehicles = vehicles, vehicleCount > indexPath.row{
                return vehicles[indexPath.row].vehicleDescription()
            }
            return .viewSettingsVolvoAddNewLabel
        } else if indexPath.section == 1 {
            return (user?.email)!
        } else {
            return .viewSettingsDistanceUnitTitle
        }
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // need at least one for "Add a New Volvo"
            if let vehicles = vehicles {
                return vehicles.count + 1
            }
            return 1
        } else if section == 1 {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CheckmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SettingsCell
        var text = getTextForIndexPath(indexPath: indexPath)
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdToogle, for: indexPath) as! SettingsCell
            cell.setCellType(type: .uiswitch)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdIndicator, for: indexPath) as! SettingsCell
            if indexPath.section == 0 && indexPath.row >= vehicleCount {
                cell.setCellType(type: .button)
                text = text.uppercased()
            } else {
                cell.setCellType(type: .indicator)
            }
        }
        cell.setText(text: text)
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CheckmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: SettingsCell.height))
        view.backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: SettingsCell.height))
        label.font = .volvoSansProMedium(size: 13)
        label.textColor = UIColor.luxeGray()
        label.text = getTitleForSection(section: section).uppercased()
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            var vehicle: Vehicle?
            if let vehicles = vehicles, vehicles.count > indexPath.row {
                vehicle = vehicles[indexPath.row]
            }
            if let vehicle = vehicle {
                Analytics.trackClick(button: .settingsVehicle, screen: self.screen)
                self.pushViewController(SettingsCarViewController(vehicle: vehicle), animated: true)
            } else {
                Analytics.trackClick(button: .settingsAddVehicle, screen: self.screen)
                self.pushViewController(FTUEAddVehicleViewController(), animated: true)
            }
        } else if indexPath.section == 1 {
            Analytics.trackClick(button: .settingsAccount, screen: self.screen)
            self.pushViewController(AccountSettingsViewController(), animated: true)
        }
    }
    
    func switchChanged(_ cell: UITableViewCell) {
        //todo change from miles to km etc
        //tableView.indexPath(for: cell)
    }
    
    func onEditClicked(_ cell: UITableViewCell) {
    }
    
}

