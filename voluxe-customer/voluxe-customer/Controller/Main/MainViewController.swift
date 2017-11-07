//
//  MainViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/1/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

class MainViewController: BaseViewController {
    
    static var navigationBarHeight: CGFloat = 0
    var schedulePickupViewController: SchedulePickupViewController?
    
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem()
        if let navigationController = self.navigationController {
            MainViewController.navigationBarHeight = navigationController.navigationBar.frame.size.height
        }
    }
    
    override func setupViews() {
        schedulePickupViewController = SchedulePickupViewController()
        if let view = schedulePickupViewController?.view {
            self.view.addSubview(view)
        
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    static func getNavigationBarHeight() -> CGFloat {
        return MainViewController.navigationBarHeight
    }
}

extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
