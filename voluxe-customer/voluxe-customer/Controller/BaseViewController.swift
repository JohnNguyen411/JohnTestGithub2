//
//  BaseViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/30/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var keyboardShowing = false
    var keyboardHeight: CGFloat = 0
    
    let blockingLoadingView = UIAlertController(title: nil, message: "", preferredStyle: .alert)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleViews()
        setupViews()
    }
    
    func styleViews() {
        
        blockingLoadingView.view.tintColor = UIColor.black
        let loadingIndicator = UIActivityIndicatorView(frame: .zero) as UIActivityIndicatorView
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingIndicator.color = .luxeDarkBlue()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        
        blockingLoadingView.view.addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        self.view.backgroundColor = .white
        setGradientBackground()
    }
    
    func setupViews() {}
    
    func stateDidChange(state: ServiceState) {}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor.white.cgColor
        let colorBottom = UIColor.luxeLinearGradient().cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    //MARK: Keyboard management
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        //override if needed
        keyboardShowing = true
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        //override if needed
        keyboardShowing = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func showBlockingLoading() {
        self.blockingLoadingView.view.alpha = 0
        present(blockingLoadingView, animated: false, completion: {
            self.blockingLoadingView.view.snp.remakeConstraints { make in
                make.width.height.equalTo(150)
                make.center.equalToSuperview()
            }
            self.blockingLoadingView.view.animateAlpha(show: true)
        })
    }
    
    func hideBlockingLoading() {
        blockingLoadingView.dismiss(animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func setNavigationBarItem() {
        if let image = UIImage(named: "ic_menu_black_24dp") {
            self.addLeftBarButtonWithImage(image)
        }
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
    
}
