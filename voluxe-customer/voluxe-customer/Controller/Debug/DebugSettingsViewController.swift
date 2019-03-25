//
//  DebugSettingsViewController.swift
//  voluxe-customer
//
//  Created by Christoph on 5/2/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import Firebase

class DebugSettingsViewController: DebugTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(close))
        self.navigationItem.title = "Debug"
        self.settings = [self.applicationSettings(),
                         self.featureSettings(),
                         self.userSettings(),
                         self.bookingsSettings(),
                         self.networkSettings(),
                         self.analyticsSettings()]
    }

    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }

    private func applicationSettings() -> (String, [DebugTableViewCellModel]) {

        var settings: [DebugTableViewCellModel] = []

        settings += [DebugTableViewCellModel(title: "Version",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.detailTextLabel?.text = Bundle.main.versionAndBuild
            },
                                             actionClosure: nil)]

        settings += [DebugTableViewCellModel(title: "Bundle",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.detailTextLabel?.text = Bundle.main.bundleIdentifier
        },
                                             actionClosure: nil)]

        settings += [DebugTableViewCellModel(title: "Fonts",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                [unowned self] _ in
                self.navigationController?.pushViewController(DebugFontViewController(), animated: true)
            }
        )]

        return ("Application", settings)
    }

    private func featureSettings() -> (String, [DebugTableViewCellModel]) {

        var settings: [DebugTableViewCellModel] = []

        settings += [DebugTableViewCellModel(title: "UITextField vs VLTextField AutoFill",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                [unowned self] _ in
                let controller = AutoFillViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        )]

        settings += [DebugTableViewCellModel(title: "Login AutoFill",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                [unowned self] _ in
                let controller = FTUELoginViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        )]

        return ("Feature Debug", settings)
    }

    private func userSettings() -> (String, [DebugTableViewCellModel]) {

        var settings: [DebugTableViewCellModel] = []

        settings += [DebugTableViewCellModel(title: "customer_id",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                let id = UserManager.sharedInstance.customerId() ?? 0
                let text = (id != 0 ? "\(id)" : "Unknown")
                cell.detailTextLabel?.text = text
            },
                                             actionClosure: nil)]

        settings += [DebugTableViewCellModel(title: "Vehicles",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                let vehicles = UserManager.sharedInstance.getVehicles()
                let ids = self.ids(for: vehicles)?.joined(separator: ", ") ?? "no ids"
                let text = "\(vehicles?.count ?? 0) (\(ids))"
                cell.detailTextLabel?.text = text
            },
                                             actionClosure: nil)]

        return ("User", settings)
    }

    private func ids(for vehicles: [Vehicle]?) -> [String]? {
        #if swift(>=4.1)
            return vehicles?.compactMap { "\($0.id)" }
        #else
            return vehicles?.flatMap { "\($0.id)" }
        #endif
    }

    private func bookingsSettings() -> (String, [DebugTableViewCellModel]) {

        var settings: [DebugTableViewCellModel] = []

        let bookings = UserManager.sharedInstance.getActiveBookings()

        // active bookings
        for booking in bookings {
            let title = "\(booking.id)"
            settings += [DebugTableViewCellModel(title: title,
                                                 cellReuseIdentifier: DebugValueTableViewCell.className,
                                                 valueClosure:
                {
                    cell in
                    cell.detailTextLabel?.text = "\(booking.state) for vehicle \(booking.vehicleId)"
                },
                                                 actionClosure: nil)]
        }

        // no active bookings
        if bookings.isEmpty {
            settings += [DebugTableViewCellModel(title: "No active bookings",
                                                 cellReuseIdentifier: DebugValueTableViewCell.className,
                                                 valueClosure: nil,
                                                 actionClosure: nil)]
        }

        return ("Bookings", settings)
    }

    private func analyticsSettings() -> (String, [DebugTableViewCellModel]) {

        var settings: [DebugTableViewCellModel] = []

        settings += [DebugTableViewCellModel(title: "Taxonomy",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                [unowned self] _ in
                let controller = TaxonomyTableViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        )]

        settings += [DebugTableViewCellModel(title: "Disable Firebase",
                                             cellReuseIdentifier: DebugSubtitleTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = (UserDefaults.standard.disableFirebase ? .checkmark : .none)
                cell.detailTextLabel?.text = "Requires relaunch to take effect"
            },
                                             actionClosure:
            {
                _ in
                UserDefaults.standard.disableFirebase = !UserDefaults.standard.disableFirebase
            }
        )]

        return ("Analytics", settings)
    }

    private func networkSettings() -> (String, [DebugTableViewCellModel]) {

        var settings: [DebugTableViewCellModel] = []

        settings += [DebugTableViewCellModel(title: "Enable logging",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = (UserDefaults.standard.enableAlamoFireLogging ? .checkmark : .none)
            },
                                             actionClosure:
            {
                _ in
                UserDefaults.standard.enableAlamoFireLogging = !UserDefaults.standard.enableAlamoFireLogging
                //TODO: figure out logging for AlamoFire5
                /*
                 UserDefaults.standard.enableAlamoFireLogging = !UserDefaults.standard.enableAlamoFireLogging
                if UserDefaults.standard.enableAlamoFireLogging {
                    NetworkActivityLogger.shared.level = .debug
                    NetworkActivityLogger.shared.startLogging()
                } else {
                    NetworkActivityLogger.shared.level = .off
                    NetworkActivityLogger.shared.stopLogging()
                }
                 */
            }
        )]
        
        settings += [DebugTableViewCellModel(title: "Environment",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
        {
                cell in
                cell.detailTextLabel?.text = UserDefaults.standard.apiHost.rawValue
                
        }, actionClosure: {
            _ in
            let alert = UIAlertController(title: "Environment", message: "Changing environment will log you out", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: RestAPIHost.development.rawValue, style: .default, handler: { (action) in
                self.changeEnvironment(host: RestAPIHost.development)
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: RestAPIHost.staging.rawValue, style: .default, handler: { (action) in
                self.changeEnvironment(host: RestAPIHost.staging)
                alert.dismiss(animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: RestAPIHost.production.rawValue, style: .default, handler: { (action) in
                self.changeEnvironment(host: RestAPIHost.production)
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        )]

        return ("Network", settings)
    }
    
    private func changeEnvironment(host: RestAPIHost) {
        if UserDefaults.standard.apiHost != host {
            UserDefaults.standard.apiHost = host
            UserManager.sharedInstance.logout()
            VolvoValetCustomerAPI.reloadHost()
            AppController.sharedInstance.startApp()
            close()
        }
        

    }
}
