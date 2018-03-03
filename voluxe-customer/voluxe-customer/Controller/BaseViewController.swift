//
//  BaseViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/30/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, PresentrDelegate {
    
    static let fakeYOrigin: CGFloat = -555.0
    
    let presentrCornerRadius: CGFloat = 4.0
    var currentPresentr: Presentr?
    var currentPresentrVC: VLPresentrViewController?
    
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
    
    //MARK: PresentR
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        currentPresentr = nil
        currentPresentrVC = nil
        return true
    }
    
    func buildPresenter(heightInPixels: CGFloat, dismissOnTap: Bool) -> Presentr {
        let customType = getPresenterPresentationType(heightInPixels: heightInPixels, customYOrigin: BaseViewController.fakeYOrigin)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = presentrCornerRadius
        customPresenter.blurBackground = true
        customPresenter.blurStyle = UIBlurEffectStyle.light
        customPresenter.dismissOnSwipe = false
        customPresenter.keyboardTranslationType = .moveUp
        customPresenter.dismissOnTap = dismissOnTap
        
        let shadow = PresentrShadow(shadowColor: .black, shadowOpacity: 0.8, shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 4.0)
        customPresenter.dropShadow = shadow
        
        return customPresenter
    }
    
    func getPresenterPresentationType(heightInPixels: CGFloat, customYOrigin: CGFloat) -> PresentationType {
        let widthPerc = 0.95
        let width = ModalSize.fluid(percentage: Float(widthPerc))
        
        let viewH = self.view.frame.height + AppDelegate.getNavigationBarHeight() + statusBarHeight() + presentrCornerRadius
        let viewW = Double(self.view.frame.width)
        
        let percH = heightInPixels / viewH
        let leftRightMargin = (viewW - (viewW * widthPerc))/2
        let height = ModalSize.fluid(percentage: Float(percH))
        
        var yOrigin = customYOrigin
        if yOrigin == BaseViewController.fakeYOrigin {
            yOrigin = viewH - heightInPixels
        }
        
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: leftRightMargin, y: Double(yOrigin)))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        return customType
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
    
    func showOkDialog(title: String, message: String, completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        // Submit button
        let okButton = UIAlertAction(title: .Ok, style: .default, handler: { (action) -> Void in
            if let completion = completion {
                completion()
            }
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
