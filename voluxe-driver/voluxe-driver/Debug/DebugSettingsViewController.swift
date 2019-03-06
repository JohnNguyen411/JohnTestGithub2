//
//  DebugSettingsViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 10/29/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class DebugSettingsViewController: DebugTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(close))
        self.navigationItem.title = "Debug"
        self.settings = [self.applicationSettings(),
                         self.networkSettings(),
                         self.featureSettings()]
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

        settings += [DebugTableViewCellModel(title: "Host",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.text = DriverAPI.api.host.string
            },
                                             actionClosure:
            {
                [weak self] cell in
                self?.confirmHostChange()
            }
        )]
        
        settings += [DebugTableViewCellModel(title: "Disable Alert Sound",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = (UserDefaults.standard.disableAlertSound ? .checkmark : .none)
        },
                                             actionClosure:
            {
                _ in
                UserDefaults.standard.disableAlertSound = !UserDefaults.standard.disableAlertSound
        }
            )]

        return ("Application", settings)
    }

    private func networkSettings() -> (String, [DebugTableViewCellModel]) {

        var settings: [DebugTableViewCellModel] = []

        settings += [DebugTableViewCellModel(title: "Inject Login Required (E2001)",
                                             cellReuseIdentifier: DebugSubtitleTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = UserDefaults.standard.injectLoginRequired ? .checkmark : .none
                cell.detailTextLabel?.text = "Will cause an alert loop if DriverAPI.logout() is called"
            },
                                             actionClosure:
            {
                cell in
                UserDefaults.standard.injectLoginRequired = !UserDefaults.standard.injectLoginRequired
            }
        )]

        settings += [DebugTableViewCellModel(title: "Inject Update Required (E3006)",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = UserDefaults.standard.injectUpdateRequired ? .checkmark : .none
            },
                                             actionClosure:
            {
                cell in
                UserDefaults.standard.injectUpdateRequired = !UserDefaults.standard.injectUpdateRequired
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
            }
        )]

        return ("Network", settings)
    }

    private func featureSettings() -> (String, [DebugTableViewCellModel]) {

        var settings: [DebugTableViewCellModel] = []

        settings += [DebugTableViewCellModel(title: "GridLayout",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                cell in
                self.navigationController?.pushViewController(GridLayoutViewController(), animated: true)
            }
        )]

        settings += [DebugTableViewCellModel(title: "DriverManager",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                cell in
                self.navigationController?.pushViewController(DriverManagerViewController(), animated: true)
            }
        )]

        settings += [DebugTableViewCellModel(title: "RequestManager",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                cell in
                self.navigationController?.pushViewController(RequestManagerViewController(), animated: true)
            }
        )]

        settings += [DebugTableViewCellModel(title: "UploadManager",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                cell in
                self.navigationController?.pushViewController(UploadManagerViewController(), animated: true)
            }
        )]

        settings += [DebugTableViewCellModel(title: "Document Inspection",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                cell in
                let controller = InspectionPhotosViewController(type: .document)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        )]

        settings += [DebugTableViewCellModel(title: "Loaner Inspection",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                cell in
                let controller = InspectionPhotosViewController(type: .loaner)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        )]

        settings += [DebugTableViewCellModel(title: "Vehicle Inspection",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                cell in
                let controller = InspectionPhotosViewController(type: .vehicle)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        )]

        settings += [DebugTableViewCellModel(title: "Driver Selfie",
                                             cellReuseIdentifier: DebugValueTableViewCell.className,
                                             valueClosure:
            {
                cell in
                cell.accessoryType = .disclosureIndicator
            },
                                             actionClosure:
            {
                cell in
                let controller = SelfieViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        )]

        return ("Feature Debug", settings)
    }
}

extension DebugSettingsViewController {

    func confirmHostChange() {

        let controller = UIAlertController(title: "Switch Host",
                                           message: "Select the new host/environment for the app.  Note that switching hosts will relaunch the app and discard current operations like photo uploads.",
                                           preferredStyle: .actionSheet)

        for host in RestAPIHost.allCases {
            guard host != DriverAPI.api.host else { continue }
            let action = UIAlertAction(title: host.string, style: .destructive) {
                _ in
                AppController.shared.relaunch(host)
                self.dismiss(animated: true)
            }
            controller.addAction(action)
        }

        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(action)

        self.present(controller, animated: true, completion: nil)
    }
}
