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
import SwiftEventBus

class BaseViewController: UIViewController, PresentrDelegate, VLPresentrViewDelegate {
    
    
    
    static let defaultTopYOffset: CGFloat = 36.0
    static let fakeYOrigin: CGFloat = -555.0
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    let screen: AnalyticsEnums.Name.Screen?

    let presentrCornerRadius: CGFloat = 4.0
    var currentPresentr: Presentr?
    var currentPresentrVC: VLPresentrViewController?
    
    var keyboardShowing = false
    var keyboardHeight: CGFloat = 0
    
    var shouldShowNotifBadge: Bool?

    init(screen: AnalyticsEnums.Name.Screen? = nil) {
        self.screen = screen
        super.init(nibName: nil, bundle: nil)
        self.setDefaultBarButtonItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewUtils.screenSize = self.view.frame.size
        styleViews()
        setupViews()
        styleNavigationBar(navigationBar: self.navigationController?.navigationBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logViewScreen()
        if let shouldShowNotifBadge = shouldShowNotifBadge {
            showNotifBadge(shouldShowNotifBadge)
        }
        
        SwiftEventBus.onMainThread(self, name: "requestNotifPermission", handler: { result in
            self.showNotificationPermissionModal(dismissOnTap: false)
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    func setTitle(title: String?) {
        if let title = title {
            self.navigationItem.title = title
        }
        self.title = title
    }
    
    func styleViews() {
        self.view.backgroundColor = .white
    }
    
    func setupViews() {}
    
    func stateDidChange(state: ServiceState) {}
    
    private func setGradientBackground() {
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
        customPresenter.backgroundOpacity = 0
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
    
    func showNotificationPermissionModal(dismissOnTap: Bool) {
        if let appDelegate = self.appDelegate, !NotificationPermissionViewController.isShowing {
            let permissionVC = NotificationPermissionViewController(title: .AllowNotifications,
                                                                    screen: .requestNotifications,
                                                                    delegate: appDelegate)
            permissionVC.view.accessibilityIdentifier = "permissionVC"
            permissionVC.sizeDelegate = self
            currentPresentrVC = permissionVC
            currentPresentr = buildPresenter(heightInPixels: CGFloat(currentPresentrVC!.height()), dismissOnTap: dismissOnTap)
            customPresentViewController(currentPresentr!, viewController: currentPresentrVC!, animated: true, completion: nil)
            NotificationPermissionViewController.isShowing = true
        }
    }
    
    func closePresenter() {}
    
    func onSizeChanged() {
        guard let currentPresentrVC = self.currentPresentrVC else { return }
        // increase size of presenter
        let newHeight = CGFloat(currentPresentrVC.height())
        let presentationType = getPresenterPresentationType(heightInPixels: newHeight, customYOrigin: BaseViewController.fakeYOrigin)
        currentPresentr?.currentPresentationController?.updateToNewFrame(presentationType: presentationType)
    }

    func logViewScreen() {
        guard let screen = self.screen else { return }
        Analytics.trackView(screen: screen)
    }
    
    func showNotifBadge(_ shouldShowBadge: Bool) {
        if shouldShowBadge {
            let added = self.navigationItem.leftBarButtonItem?.addBadge()
            if let added = added, !added {
                shouldShowNotifBadge = shouldShowBadge
            }
        } else {
            self.navigationItem.leftBarButtonItem?.removeBadge()
            shouldShowNotifBadge = false
        }
    }
    
}

extension UIViewController {
    
    func setNavigationBarItem() {
        if let image = UIImage(named: "ic_menu") {
            self.addLeftBarButtonWithImage(image)
        }
        AppController.sharedInstance.slideMenuController?.removeLeftGestures()
        AppController.sharedInstance.slideMenuController?.removeRightGestures()
        AppController.sharedInstance.slideMenuController?.addLeftGestures()
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
            NSAttributedStringKey.font : UIFont.volvoSansProMedium(size: 16),
            NSAttributedStringKey.foregroundColor : UIColor.luxeCobaltBlue()],
                                          for: UIControlState.normal)
        
        barButton.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.volvoSansProMedium(size: 16),
            NSAttributedStringKey.foregroundColor : UIColor.luxeLightGray()],
                                         for: UIControlState.selected)
        
        barButton.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont.volvoSansProMedium(size: 16),
            NSAttributedStringKey.foregroundColor : UIColor.luxeLightGray()],
                                         for: UIControlState.disabled)
    }
    
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        AppController.sharedInstance.slideMenuController?.removeLeftGestures()
        AppController.sharedInstance.slideMenuController?.removeRightGestures()
    }

    func showOkDialog(title: String,
                      message: String,
                      completion: (() -> ())? = nil,
                      dialog: AnalyticsEnums.Name.Screen? = nil,
                      screen: AnalyticsEnums.Name.Screen? = nil)
    {
        showDialog(title: title,
                   message: message,
                   buttonTitle: String.Ok.uppercased(),
                   completion: completion,
                   dialog: dialog,
                   screen: screen)
    }

    func showDialog(title: String,
                    message: String,
                    buttonTitle: String,
                    completion: (() -> ())? = nil,
                    dialog: AnalyticsEnums.Name.Screen? = nil,
                    screen: AnalyticsEnums.Name.Screen? = nil)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        if let screen = screen { Analytics.trackView(screen: screen) }

        // Submit button
        let button = UIAlertAction(title: buttonTitle, style: .default) {
            _ in
            Analytics.trackClick(button: .dismissDialog, screen: screen)
            completion?()
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDialog(title: String,
                    message: String,
                    cancelButtonTitle: String,
                    okButtonTitle: String,
                    okCompletion: @escaping (() -> ()),
                    dialog: AnalyticsEnums.Name.Screen? = nil,
                    screen: AnalyticsEnums.Name.Screen? = nil)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        if let screen = screen { Analytics.trackView(screen: screen) }
        
        // cancel button
        let backAction = UIAlertAction(title: cancelButtonTitle, style: .default) {
            _ in
            Analytics.trackClick(button: .dismissDialog, screen: screen)
            alert.dismiss(animated: true, completion: nil)
        }
        
        // OK button
        let submitAction = UIAlertAction(title: okButtonTitle, style: .default) {
            _ in
            Analytics.trackClick(button: .okDialog, screen: screen)
            alert.dismiss(animated: true, completion: nil)
            okCompletion()
        }
        
        alert.addAction(backAction)
        alert.addAction(submitAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showDestructiveDialog(title: String,
                               message: String,
                               cancelButtonTitle: String,
                               destructiveButtonTitle: String,
                               destructiveCompletion: @escaping (() -> ()),
                               dialog: AnalyticsEnums.Name.Screen? = nil,
                               screen: AnalyticsEnums.Name.Screen? = nil)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        if let screen = screen { Analytics.trackView(screen: screen) }

        // Submit button
        let backAction = UIAlertAction(title: cancelButtonTitle, style: .default) {
            _ in
            Analytics.trackClick(button: .dismissDialog, screen: screen)
            alert.dismiss(animated: true, completion: nil)
        }
        
        // Delete button
        let deleteAction = UIAlertAction(title: destructiveButtonTitle, style: .destructive) {
            _ in
            Analytics.trackClick(button: .destructiveDialog, screen: screen)
            alert.dismiss(animated: true, completion: nil)
            destructiveCompletion()
        }
        
        alert.addAction(backAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }

    private func getViewForHUD() -> UIView {
        if let view = AppController.sharedInstance.currentViewController?.view {
            return view
        }
        else if let navigationController = self.navigationController {
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
