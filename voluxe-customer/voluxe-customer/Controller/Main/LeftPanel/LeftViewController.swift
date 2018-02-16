//
//  LeftViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/1/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import SnapKit

enum LeftMenu: Int {
    case main = 0
    case settings
    case logout
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    var tableView = UITableView(frame: .zero)
    var menus = [String.YourVolvos, String.Settings, String.Logout]
    var mainNavigationViewController: UIViewController!
    var mainViewController: MainViewController!
    var imageHeaderView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.imageHeaderView = UIImageView(frame: .zero)
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.register(LeftPanelTableViewCell.self, forCellReuseIdentifier: LeftPanelTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(imageHeaderView)
        self.view.addSubview(tableView)
        
        let tableH = CGFloat(menus.count) * LeftPanelTableViewCell.height()
        
        imageHeaderView.snp.makeConstraints { (make) -> Void in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(160)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(imageHeaderView.snp.bottom)
            make.height.equalTo(tableH)
        }
    }
    
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainNavigationViewController, close: true)
        case .settings:
            weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.navigationController?.pushViewController(SettingsViewController(), animated: true)
            closeLeft()
        case .logout:
            UserManager.sharedInstance.logout()
            weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.startApp()
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LeftPanelTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = LeftPanelTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: LeftPanelTableViewCell.identifier)
        cell.setData(menus[indexPath.row])
        return cell
        
    }
    
    
}
