//
//  LoginViewController.swift
//  voluxe-driver
//
//  Created by Christoph on 12/18/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: Layout
    
    // Panel view that will have rounded corners on iPhone X style screens.
    private let panelView: UIView = {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.Volvo.background.light
        view.layer.cornerRadius = view.hasTopNotch ? 40 : 0
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 7
        return view
    }()
    
    // Button that fills the entire screen behind the rounded panel view.
    private let dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.Volvo.black.withAlphaComponent(0.67)
        return button
    }()
    
    private let selfieButton: UIButton = {
        let button = ProfileButton().usingAutoLayout()
        let image = UIImage(named: "avatar_empty")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let changeInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(Unlocalized.changeContactInfo, for: .normal)
        button.setTitleColor(UIColor.Volvo.brightBlue, for: .normal)
        button.titleLabel?.font = Font.Intermediate.regular
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let changePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(Unlocalized.changePassword, for: .normal)
        button.setTitleColor(UIColor.Volvo.brightBlue, for: .normal)
        button.titleLabel?.font = Font.Intermediate.regular
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(Unlocalized.signOut, for: .normal)
        button.setTitleColor(UIColor.Volvo.brightBlue, for: .normal)
        button.titleLabel?.font = Font.Intermediate.regular
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let headerView: UIView = {
        let view = UIView.forAutoLayout()
        view.backgroundColor = UIColor.Volvo.darkestGrey
        view.layer.cornerRadius = view.hasTopNotch ? 40 : 0
        view.layer.maskedCorners = [.layerMaxXMinYCorner]
        return view
    }()
    
    private let driverNameLabel = Label.whiteTitle()
    
    private let dealershipLabel = Label.taskText()
    private let contactCallView = ImagedLabel(extraSpacing: 5)
    
    private let gpsProviderTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.rowHeight = ProfileViewController.gpsRowHeight
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RequestTableViewCell")
        return tableView
    }()
    
    private let gpsProviderLabel = Label.taskText(with: .localized(.viewDrawerNavigationPreferenceTitle))
    

    // MARK: DATA
    private let gpsProviders = NavigationHelper.shared.deviceSupportedProviders()
    
    private static let gpsRowHeight: CGFloat = 46
    private static let maxTableViewItemHeight: CGFloat = 3
    private static let maxTableViewHeight: CGFloat = ProfileViewController.gpsRowHeight * ProfileViewController.maxTableViewItemHeight
    
    private static let leadingMargin: CGFloat = 15

    // MARK: Lifecycle
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.addActions()
        self.modalPresentationStyle = .overCurrentContext
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.gpsProviderLabel.font = Font.Small.medium
        self.dealershipLabel.font = Font.Small.medium

        self.gpsProviderTableView.contentInsetAdjustmentBehavior = .never
        self.gpsProviderTableView.delegate = self
        self.gpsProviderTableView.dataSource = self
        self.gpsProviderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        self.contactCallView.setText(.localized(.viewDrawerContactDealershipCall), image:  UIImage(named: "icon_call"))
        
        // this is necessary to allow transparent black background
        self.view.isOpaque = false
        
        // grid view fills entire screen
        let gridView = GridLayoutView(layout: GridLayout.volvoAgent())
        Layout.fill(view: self.view, with: gridView, useSafeArea: false)
        
        // dismiss fills entire view underneath panel view
        Layout.fill(view: gridView, with: self.dismissButton, useSafeArea: false)
        
        gridView.addSubview(self.panelView)
        let topConstant: CGFloat = gridView.hasTopNotch ? 0 : -20
        let trailingAnchor = gridView.trailingAnchor(for: 5)
        self.panelView.leadingAnchor.constraint(equalTo: gridView.leadingAnchor).isActive = true
        self.panelView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.panelView.pinToSuperviewTop(spacing: topConstant)
        self.panelView.pinBottomToSuperviewBottom()
        
        self.panelView.addSubview(self.headerView)
        self.headerView.pinTopToSuperview()
        self.headerView.pinLeadingToSuperView()
        self.headerView.pinTrailingToSuperView()
        self.headerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.headerView.addSubview(self.selfieButton)
        self.selfieButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        self.selfieButton.leadingAnchor.constraint(equalTo: panelView.leadingAnchor,
                                                   constant: ProfileViewController.leadingMargin).isActive = true
        self.selfieButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        self.selfieButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        self.headerView.addSubview(self.driverNameLabel)
        self.driverNameLabel.pinLeadingToSuperView(constant: 96)
        self.driverNameLabel.centerYAnchor.constraint(equalTo: selfieButton.centerYAnchor).isActive = true
        
        if let dealerships = DriverManager.shared.dealerships, dealerships.count == 1 {
            self.dealershipLabel.text = dealerships[0].name
            self.panelView.addSubview(self.dealershipLabel)
            self.dealershipLabel.pinTopToBottomOf(view: self.headerView, spacing: 20)
            self.dealershipLabel.pinLeadingToSuperView(constant: ProfileViewController.leadingMargin)
            self.dealershipLabel.sizeToFit()
        }
        
        // call dealership Button
        self.contactCallView.translatesAutoresizingMaskIntoConstraints = false
        self.panelView.addSubview(self.contactCallView)
        self.contactCallView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        if self.dealershipLabel.superview == nil {
            self.contactCallView.pinTopToBottomOf(view: self.headerView, spacing: 20)
        } else {
            self.contactCallView.pinTopToBottomOf(view: self.dealershipLabel, spacing: 20)
        }
        self.contactCallView.pinLeadingToSuperView(constant: ProfileViewController.leadingMargin)
        self.contactCallView.pinTrailingToSuperView()

        let separator = UIView.forAutoLayout()
        separator.heightAnchor.constraint(equalToConstant: UIView.onePx()).isActive = true
        separator.backgroundColor = UIColor.Volvo.fog
        
        self.panelView.addSubview(separator)
        separator.pinTopToBottomOf(view: self.contactCallView, spacing: 10)
        separator.pinLeadingToSuperView()
        separator.pinTrailingToSuperView()
        
        self.panelView.addSubview(self.gpsProviderLabel)
        self.gpsProviderLabel.pinLeadingToSuperView(constant: ProfileViewController.leadingMargin)
        self.gpsProviderLabel.pinTopToBottomOf(view: separator, spacing: 56)
        
        self.panelView.addSubview(self.gpsProviderTableView)
        self.gpsProviderTableView.pinLeadingToSuperView()
        self.gpsProviderTableView.pinTrailingToSuperView()

        self.gpsProviderTableView.pinTopToBottomOf(view: gpsProviderLabel, spacing: 10)
        if gpsProviders.count > Int(ProfileViewController.maxTableViewItemHeight) {
            self.gpsProviderTableView.heightAnchor.constraint(equalToConstant: ProfileViewController.maxTableViewHeight).isActive = true
            self.gpsProviderTableView.isScrollEnabled = true
        } else {
            self.gpsProviderTableView.heightAnchor.constraint(equalToConstant: CGFloat(gpsProviders.count) * ProfileViewController.gpsRowHeight).isActive = true
            self.gpsProviderTableView.isScrollEnabled = false
        }
        
        if gpsProviders.count <= 1 {
            gpsProviderLabel.isHidden = true
            gpsProviderTableView.isHidden =  true
        }
        
        // BOTTOM AREA
        
        self.panelView.addSubview(self.logoutButton)
        self.logoutButton.pinLeadingToSuperView(constant: ProfileViewController.leadingMargin)
        self.logoutButton.pinBottomToSuperviewBottom(spacing: -20, useSafeArea: false)

        self.panelView.addSubview(self.changePasswordButton)
        self.changePasswordButton.pinLeadingToSuperView(constant: ProfileViewController.leadingMargin)
        self.changePasswordButton.pinBottomToTopOf(view: self.logoutButton, spacing: -10)
        
        self.panelView.addSubview(self.changeInfoButton)
        self.changeInfoButton.pinLeadingToSuperView(constant: ProfileViewController.leadingMargin)
        self.changeInfoButton.pinBottomToTopOf(view: self.changePasswordButton, spacing: -10)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let photo = DriverManager.shared.driverPhoto {
            self.selfieButton.setImage(photo, for: .normal)
        } else if let photoURL = DriverManager.shared.driver?.photoUrl {
            let url = URL(string: photoURL)
            self.selfieButton.kf.setImage(with: url, for: .normal)
        }
        self.driverNameLabel.text = "\(DriverManager.shared.driver?.firstName ?? "") \(DriverManager.shared.driver?.lastName ?? "")"
        self.driverNameLabel.sizeToFit()
    }
    
    // MARK: Actions
    
    private func addActions() {
        self.dismissButton.addTarget(self, action: #selector(dismissButtonTouchUpInside), for: .touchUpInside)
        self.selfieButton.addTarget(self, action: #selector(selfieButtonTouchUpInside), for: .touchUpInside)
        self.changeInfoButton.addTarget(self, action: #selector(changeInfoButtonTouchUpInside), for: .touchUpInside)
        self.changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTouchUpInside), for: .touchUpInside)
        self.logoutButton.addTarget(self, action: #selector(logoutButtonTouchUpInside), for: .touchUpInside)
        
        self.contactCallView.isUserInteractionEnabled = true
        let callDealershipTap = UITapGestureRecognizer(target: self, action: #selector(self.callDealershipTouchUpInside))
        self.contactCallView.addGestureRecognizer(callDealershipTap)
    }
    
    @objc func callDealershipTouchUpInside() {
        guard let dealerships = DriverManager.shared.dealerships else {
            return
        }
        
        Analytics.trackClick(button: .leftPanelCallDealership)
        
        if dealerships.count == 1 {
            self.callNumber(phoneNumber: dealerships[0].phoneNumber)
        } else if dealerships.count > 1 {
            // show action sheets dealerships
            self.dealershipsActionSheet(dealerships: dealerships)
        }
    }
    
    func callNumber(phoneNumber: String) {
        let number = "telprompt:\(phoneNumber)"
        guard let url = URL(string: number) else { return }
        UIApplication.shared.open(url)
    }
    
    func dealershipsActionSheet(dealerships: [Dealership]) {
        
        let controller = UIAlertController(title: .localized(.popupChooseDealershipTitle),
                                           message: nil,
                                           preferredStyle: .actionSheet)
        
        for dealership in dealerships {
            let action = UIAlertAction(title: dealership.name, style: .default) {
                _ in
                self.callNumber(phoneNumber: dealership.phoneNumber)
                self.dismiss(animated: true)
            }
            controller.addAction(action)
        }
        
        
        let action = UIAlertAction(title: .localized(.cancel), style: .cancel, handler: nil)
        controller.addAction(action)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func dismissButtonTouchUpInside() {
        AppController.shared.hideProfile()
    }
    
    @objc func selfieButtonTouchUpInside() {
        Analytics.trackClick(button: .leftPanelProfilePhoto)
        let controller = SelfieViewController()
        AppController.shared.mainController(push: controller, prefersProfileButton: false)
        AppController.shared.hideProfile(animated: true)
    }
    
    @objc func changeInfoButtonTouchUpInside() {
        
        guard DriverManager.shared.driver != nil else { return }
        
        Analytics.trackClick(button: .leftPanelChangePhone)
        
        let controller = LoginFlowViewController(steps: LoginFlowViewController.changePhoneNumberSteps(), direction: .horizontal)
        AppController.shared.mainController(push: controller, prefersProfileButton: false)
        AppController.shared.hideProfile(animated: true)
    }
    
    @objc func changePasswordButtonTouchUpInside() {
        
        Analytics.trackClick(button: .leftPanelChangePassword)
        
        let controller = ForgotPasswordViewController()
        AppController.shared.mainController(push: controller, prefersProfileButton: false)
        AppController.shared.hideProfile()
    }
    
    @objc func logoutButtonTouchUpInside() {
        // check if active request
        
        Analytics.trackClick(button: .leftPanelLogout)
        
        var showConfirmationDialog = false
        if RequestManager.shared.requests.count > 0 {
            let current = RequestManager.shared.requests
                .filter { $0.state == .started &&
                    Calendar.current.isDateInToday($0.dealershipTimeSlot.from) }
                .sorted { $0.dealershipTimeSlot.from < $1.dealershipTimeSlot.from }
            if current.count > 0 {
                showConfirmationDialog = true
            }
        }
        
        if showConfirmationDialog {
            let alert = AppController.shared.buildAlertDestructive(title: .localized(.signout), message: .localized(.popupSignoutConfirmationMessage), cancelButtonTitle: .localized(.cancel), destructiveButtonTitle: .localized(.signout), destructiveCompletion: {
                self.signout()
            })
            
            self.present(alert, animated: true, completion: nil)
        } else {
            self.signout()
        }
    }
    
    private func signout() {
        AppController.shared.logout()
        AppController.shared.hideProfile()
    }
    
    // MARK: Animations
    
    func preparePresentAnimation() {
        self.view.isHidden = true
    }
    
    func playPresentAnimation(completion: (() -> ())? = nil) {
        
        self.view.isHidden = false
        self.dismissButton.alpha = 0
        self.panelView.layer.shadowOpacity = 0
        let x = -self.panelView.bounds.size.width
        self.panelView.transform = CGAffineTransform(translationX: x, y: 0)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [UIView.AnimationOptions.curveEaseOut],
                       animations:
            {
                self.dismissButton.alpha = 1
                self.panelView.layer.shadowOpacity = 0.7
                self.panelView.transform = CGAffineTransform.identity
        },
                       completion:
            {
                finish in
                completion?()
        })
    }
    
    func playDismissAnimation(completion: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [UIView.AnimationOptions.curveEaseIn],
                       animations:
            {
                self.dismissButton.alpha = 0
                self.panelView.layer.shadowOpacity = 0
                let x = -self.panelView.bounds.size.width
                self.panelView.transform = CGAffineTransform(translationX: x, y: 0)
        },
                       completion:
            {
                finish in
                completion?()
        })
    }
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.gpsProviderTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = self.gpsProviders[indexPath.row].providerName
        cell.selectionStyle = .blue
        cell.tintColor = UIColor.Volvo.brightBlue
        cell.textLabel?.font = Font.Intermediate.regular
        
        if self.gpsProviders[indexPath.row].providerKey == NavigationHelper.shared.bestAvailableGPSProvider() {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gpsProviders.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedProvider = self.gpsProviders[indexPath.row]
        UserDefaults.standard.preferredGPSProvider = selectedProvider.providerKey.rawValue
        
        if selectedProvider.providerKey == .waze {
            Analytics.trackClick(button: .leftPanelWaze)
        } else if selectedProvider.providerKey == .googleMaps {
            Analytics.trackClick(button: .leftPanelGoogleMaps)
        } else {
            Analytics.trackClick(button: .leftPanelAppleMaps)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewSeparator = UIView.forAutoLayout()
        tableViewSeparator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: UIView.onePx()) // 1.0 / [UIScreen mainScreen].scale
        tableViewSeparator.backgroundColor = UIColor.Volvo.fog
        return tableViewSeparator
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIView.onePx()
    }
}
