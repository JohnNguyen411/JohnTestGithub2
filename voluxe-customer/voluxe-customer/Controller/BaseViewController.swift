//
//  BaseViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 10/30/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Firebase

class BaseViewController: UIViewController, PresentrDelegate {
    
    static let fakeYOrigin: CGFloat = -555.0
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    let screenName: String
    let presentrCornerRadius: CGFloat = 4.0
    var currentPresentr: Presentr?
    var currentPresentrVC: VLPresentrViewController?
    
    var keyboardShowing = false
    var keyboardHeight: CGFloat = 0
    
    init(screenName: String) {
        self.screenName = screenName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleViews()
        setupViews()
        styleNavigationBar(navigationBar: self.navigationController?.navigationBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logViewScreen(screenName: self.screenName)
    }
    
    func setTitle(title: String?) {
        if let title = title {
            self.navigationController?.title = title
            self.navigationController?.navigationItem.title = title
            self.navigationController?.navigationBar.topItem?.title = title
            self.navigationItem.title = title
        }
        self.title = title
    }
    
    func setRightButtonTitle(rightButtonTitle: String) {
        let rightItem = UIBarButtonItem(title: rightButtonTitle, style: .plain, target: self, action: #selector(onRightClicked))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func pushViewController(_ controller: UIViewController, animated: Bool, backLabel: String) {
        self.navigationController?.pushViewController(controller, animated: animated)
        let backItem = UIBarButtonItem(title: backLabel, style: .plain, target: self, action: #selector(onBackClicked))
        navigationItem.backBarButtonItem = backItem
    }
    
    func styleViews() {
        
        self.view.backgroundColor = .white
        setGradientBackground()
    }
    
    func setupViews() {}
    
    func stateDidChange(state: ServiceState) {}
    
    @objc func onBackClicked() {
        self.onBackClicked(analyticEventName: nil)
    }

    @objc func onRightClicked() {
        self.onRightClicked(analyticEventName: nil)
    }
    
    @objc func onBackClicked(analyticEventName: String? = nil) {
        if let analyticEventName = analyticEventName {
            VLAnalytics.logEventWithName(analyticEventName, screenName: screenName)
        } else {
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickNavigationLeft, screenName: screenName)
        }
    }
    
    @objc func onRightClicked(analyticEventName: String? = nil) {
        if let analyticEventName = analyticEventName {
            VLAnalytics.logEventWithName(analyticEventName, screenName: screenName)
        } else {
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickNavigationRight, screenName: screenName)
        }
    }
        
        
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
        
        let viewH = UIScreen.main.bounds.height + presentrCornerRadius
        let viewW = Double(self.view.frame.width)
        
        let percH = heightInPixels / viewH
        let leftRightMargin = (viewW - (viewW * widthPerc))/2
        let height = ModalSize.fluid(percentage: Float(percH))
        
        var yOrigin = customYOrigin
        if yOrigin == BaseViewController.fakeYOrigin {
            yOrigin = viewH - heightInPixels
        }
        
        if keyboardShowing {
            yOrigin -= keyboardHeight
        }
        
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: leftRightMargin, y: Double(yOrigin)))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        return customType
    }
    
    func logViewScreen(screenName: String) {
        // send event when screen name isn't empty, little trick for same VC with state change (MainViewController, ServiceCarViewController)
        if screenName.count > 0 {
            VLAnalytics.logEventWithName(AnalyticsConstants.eventViewScreen, paramName: AnalyticsConstants.paramScreenName, paramValue: screenName)
        }
    }
    
}

extension UIViewController {
    
    func setNavigationBarItem(showNotif: Bool = false) {
        if showNotif {
            if let image = UIImage(named: "ic_menu_black_notif") {
                self.addLeftBarButtonWithImage(image)
            }
        } else {
            if let image = UIImage(named: "ic_menu_black_24dp") {
                self.addLeftBarButtonWithImage(image)
            }
        }
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    
    func styleNavigationBar(navigationBar: UINavigationBar?) {
        if let navigationBar = navigationBar {
            navigationBar.isTranslucent = false
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.tintColor = .luxeCobaltBlue()
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        }
    }
    
    static func styleBarButtonItem(barButton: UIBarButtonItem) {
        barButton.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.volvoSansLightBold(size: 16),
            NSAttributedStringKey.foregroundColor : UIColor.luxeCobaltBlue()],
                                          for: UIControlState.normal)
        
        barButton.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.volvoSansLightBold(size: 16),
            NSAttributedStringKey.foregroundColor : UIColor.luxeLightGray()],
                                         for: UIControlState.selected)
        
        barButton.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.volvoSansLightBold(size: 16),
            NSAttributedStringKey.foregroundColor : UIColor.luxeLightGray()],
                                         for: UIControlState.disabled)
    }
    
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func showOkDialog(title: String, message: String, completion: (() -> Swift.Void)? = nil, analyticDialogName: String, screenName: String?) {
        showDialog(title: title, message: message, buttonTitle: String.Ok.uppercased(), completion: completion, analyticDialogName: analyticDialogName, screenName: screenName)
    }
    
    func showDialog(title: String, message: String, buttonTitle: String, completion: (() -> Swift.Void)? = nil, analyticDialogName: String, screenName: String?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let params = getAnalyticsParamsForDialog(analyticDialogName, screenName: screenName)
        VLAnalytics.logEventWithName(AnalyticsConstants.eventViewDialog, parameters: params)
        
        // Submit button
        let button = UIAlertAction(title: buttonTitle, style: .default, handler: { (action) -> Void in
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickDimissDialog, parameters: params)
            if let completion = completion {
                completion()
            }
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDestructiveDialog(title: String, message: String, cancelButtonTitle: String, destructiveButtonTitle: String, destructiveCompletion: @escaping (() -> Swift.Void), analyticDialogName: String, screenName: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let params = getAnalyticsParamsForDialog(analyticDialogName, screenName: screenName)
        VLAnalytics.logEventWithName(AnalyticsConstants.eventViewDialog, parameters: params)
        // Submit button
        let backAction = UIAlertAction(title: cancelButtonTitle, style: .default, handler: { (action) -> Void in
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickDimissDialog, parameters: params)
            alert.dismiss(animated: true, completion: nil)
        })
        
        // Delete button
        let deleteAction = UIAlertAction(title: destructiveButtonTitle, style: .destructive, handler: { (action) -> Void in
            VLAnalytics.logEventWithName(AnalyticsConstants.eventClickDestructiveDialog, parameters: params)
            alert.dismiss(animated: true, completion: nil)
            destructiveCompletion()
        })
        
        alert.addAction(backAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getAnalyticsParamsForDialog(_ dialogName: String, screenName: String?) -> [String: String] {
        if let screenName = screenName {
            return [AnalyticsConstants.paramDialogName : dialogName, AnalyticsConstants.paramScreenName: screenName]
        }
        return [:]
    }
    
    private func getViewForHUD() -> UIView {
        if let navigationController = self.navigationController {
           return navigationController.view
        }
        return self.view
    }
    
    func showProgressHUD() {
        MBProgressHUD.showAdded(to: getViewForHUD(), animated: true)
    }
    
    func hideProgressHUD() {
        MBProgressHUD.hide(for: getViewForHUD(), animated: true)
    }
    
}
