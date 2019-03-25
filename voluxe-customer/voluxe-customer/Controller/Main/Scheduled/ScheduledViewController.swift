//
//  ScheduledViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/16/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift
import CoreLocation
import GoogleMaps
import SwiftEventBus
import MBProgressHUD
import SDWebImage

class ScheduledViewController: BaseVehicleViewController, DriverInfoViewControllerProtocol {
    
    private static let ETARefreshThrottle: Double = 30
    
    private static let mapViewHeight = 160
    private static let driverViewHeight = 55
    
    private var state: ServiceState? = nil
    
    var states: [ServiceState] = []
    var driverLocations: [CLLocationCoordinate2D] = []
    
    // UITest
    let testView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    
    var steps: [Step] = []
    private var driver: Driver?
    
    var verticalStepView: GroupedVerticalStepView? = nil
    let mapVC = MapViewController()
    
    private let mapViewContainer = UIView(frame: .zero)
    private let driverViewContainer = UIView(frame: .zero)
    private let driverIcon: UIImageView
    let changeButton: VLButton

    let timeWindowView = TimeWindowView()
    
    let driverName: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.font = .volvoSansProMedium(size: 14)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let driversLicenseInsuranceLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeDarkGray()
        titleLabel.text = .localized(.viewScheduleServiceStatusReminderPickup)
        titleLabel.font = .volvoSansProRegular(size: 14)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    private var lastRefresh: Date? = nil

    private let driverContact: VLButton
    private var driverInfoViewController: DriverInfoViewController?
    
    init(vehicle: Vehicle, state: ServiceState, screen: AnalyticsEnums.Name.Screen) {
        changeButton = VLButton(type: .blueSecondary, title: String.localized(.change).uppercased(), kern: UILabel.uppercasedKern(), event: .changeDropoff, screen: screen)
        driverContact = VLButton(type: .blueSecondary, title: String.localized(.contact).uppercased(), kern: UILabel.uppercasedKern(), event: .contactDriver, screen: screen)
        driverIcon = UIImageView.makeRoundImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35), photoUrl: nil, defaultImage: UIImage(named: "driver_placeholder"))
        super.init(vehicle: vehicle, state: state, screen: screen)
        generateSteps()

        self.mapVC.screen = screen

        verticalStepView = GroupedVerticalStepView(steps: steps)
        verticalStepView?.accessibilityIdentifier = "verticalStepView"
        mapVC.view.accessibilityIdentifier = "mapVC.view"
        timeWindowView.accessibilityIdentifier = "timeWindowView"
        testView.accessibilityIdentifier = "testView"
        
        driverIcon.isUserInteractionEnabled = true
        driverName.isUserInteractionEnabled = true
        
        let driverIconTap = UITapGestureRecognizer(target: self, action: #selector(self.driverTap(_:)))
        driverIcon.addGestureRecognizer(driverIconTap)
        let driverTap = UITapGestureRecognizer(target: self, action: #selector(self.driverTap(_:)))
        driverName.addGestureRecognizer(driverTap)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateSteps() {}

    override func viewDidLoad() {
        super.viewDidLoad()
      
        driverContact.setActionBlock { [weak self] in
            self?.contactDriverActionSheet()
        }
        
        driverViewContainer.isHidden = true
        let mapHeight = ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(ScheduledViewController.mapViewHeight + ScheduledViewController.driverViewHeight))
        
        mapVC.view.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(mapHeight)
        }
        
        ViewUtils.addShadow(toView: mapViewContainer)
        updateBookingIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftEventBus.onMainThread(self, name: "updateBookingIfNeeded") { result in
            // UI thread
            self.updateBookingIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let driverInfoViewController = self.driverInfoViewController {
            driverInfoViewController.dismiss(animated: true, completion: nil)
        }
        SwiftEventBus.unregister(self, name: "updateBookingIfNeeded")
    }
    
    
    
    override func setupViews() {
        super.setupViews()
        
        mapViewContainer.backgroundColor = .white
        
        if let verticalStepView = verticalStepView {
            
            self.view.addSubview(verticalStepView)
            self.view.addSubview(mapViewContainer)
            self.view.addSubview(driversLicenseInsuranceLabel)
            self.view.addSubview(timeWindowView)
            
            mapViewContainer.addSubview(driverViewContainer)
            driverViewContainer.addSubview(driverIcon)
            driverViewContainer.addSubview(driverName)
            driverViewContainer.addSubview(driverContact)
            
            verticalStepView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(ViewUtils.getAdaptedWidthSize(sizeInPoints: 30))
                make.top.equalToSuperview().offset(ViewUtils.getAdaptedHeightSize(sizeInPoints: BaseViewController.defaultTopYOffset))
                make.trailing.equalToSuperview().offset(ViewUtils.getAdaptedWidthSize(sizeInPoints: -30))
                make.height.equalTo(verticalStepView.height) // already adapter inside
            }
            
            mapViewContainer.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(ViewUtils.getAdaptedWidthSize(sizeInPoints: 25))
                make.trailing.equalToSuperview().offset(ViewUtils.getAdaptedWidthSize(sizeInPoints: -25))
                make.top.equalTo(verticalStepView.snp.bottom)
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(ScheduledViewController.mapViewHeight + ScheduledViewController.driverViewHeight)))
            }
            
            mapViewContainer.addSubview(mapVC.view)
            mapVC.view.snp.makeConstraints { (make) -> Void in
                make.leading.trailing.top.equalToSuperview()
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(ScheduledViewController.mapViewHeight)))
            }
            
            driverViewContainer.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(mapVC.view.snp.bottom)
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(ScheduledViewController.driverViewHeight)))
            }
            
            driverIcon.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(ViewUtils.getAdaptedWidthSize(sizeInPoints: 10))
                make.centerY.equalToSuperview()
                make.width.height.equalTo(ViewUtils.getAdaptedWidthSize(sizeInPoints: 35))
            }
            
            driverName.snp.makeConstraints { make in
                make.leading.equalTo(driverIcon.snp.trailing).offset(ViewUtils.getAdaptedWidthSize(sizeInPoints: 10))
                make.centerY.trailing.equalToSuperview()
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: 35))
            }
            
            driverContact.snp.makeConstraints { make in
                make.centerY.trailing.equalToSuperview()
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: 35))
                make.width.equalTo(ViewUtils.getAdaptedWidthSize(sizeInPoints: 100))
            }
            
            timeWindowView.snp.makeConstraints { make in
                make.leading.bottom.trailing.equalToSuperview()
                make.height.equalTo(TimeWindowView.height)
            }
            
            driversLicenseInsuranceLabel.snp.makeConstraints { make in
                make.leading.equalTo(mapViewContainer)
                make.trailing.equalToSuperview()
                make.top.equalTo(mapViewContainer.snp.bottom).offset(ViewUtils.getAdaptedHeightSize(sizeInPoints: 6, smallerOnly: false))
            }

            // Adds a filler view below the time window filling in
            // the white space on an iPhone X.  SnapKit does not seem
            // to support expressing a height outside of the safe area,
            // which is weird because snp.bottom should refer to the
            // bottom of the superview, but alas it does not work.  Instead
            // a fixed height of 100 is used as a workaround.
            let view = UIView()
            view.backgroundColor = .luxeCharcoalGrey()
            self.view.addSubview(view)
            view.snp.makeConstraints {
                make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(timeWindowView.snp.bottom)
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: 100))
            }
        }
        
        if let stepView = verticalStepView?.stepViewforIndex(0) {
            
            self.view.addSubview(changeButton)
            changeButton.isHidden = true
            
            changeButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(ViewUtils.getAdaptedWidthSize(sizeInPoints: -22))
                make.top.equalTo(stepView).offset(ViewUtils.getAdaptedHeightSize(sizeInPoints: 7))
            }
        }
    }
    
    override func stateDidChange(state: ServiceState) {
        if self.state != nil && (state == .pickupScheduled  || state == .dropoffScheduled) {
            // reset if needed
            hideDriver()
            resetState(state: state)
        }
        // check type
        if let type = StateServiceManager.sharedInstance.getType(vehicleId: vehicle.id), type == .advisorDropoff || type == .advisorPickup {
            // nothing to do here
            AppController.sharedInstance.loadViewForVehicle(vehicle: vehicle, state: state)
            return
        }
        self.state = state
        super.stateDidChange(state: state)
        self.updateState(id: state, stepState: .done)
        
        if state == .enRouteForDropoff || state == .enRouteForPickup || state == .nearbyForPickup || state == .nearbyForDropoff {
            SwiftEventBus.onMainThread(self, name: "driverLocationUpdate") { result in
                // UI thread
                self.driverLocationUpdate()
            }
        } else {
            SwiftEventBus.unregister(self, name: "driverLocationUpdate")
        }
    }
    
    private func hideDriver() {
        driverViewContainer.animateAlpha(show: false)
        UIView.animate(withDuration: 0.25, animations: {
            self.mapVC.view.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(ScheduledViewController.mapViewHeight + ScheduledViewController.driverViewHeight)))
            }
        })
        self.driver = nil
    }
    
    func newDriver(driver: Driver) {
        
        if self.driver == nil || self.driver?.id != driver.id {
            self.driver = driver
            driverViewContainer.animateAlpha(show: true)
            UIView.animate(withDuration: 0.25, animations: {
                self.mapVC.view.snp.updateConstraints { (make) -> Void in
                    make.height.equalTo(ViewUtils.getAdaptedHeightSize(sizeInPoints: CGFloat(ScheduledViewController.mapViewHeight)))
                }
            })
        } else {
            return
        }
        
        driverName.text = driver.name
        if let iconUrl = driver.iconUrl {
            driverIcon.sd_setImage(with: URL(string: iconUrl))
        }
    }
    
    private func updateState(id: ServiceState, stepState: StepState) {
        for step in steps {
            if step.id == id {
                step.state = stepState
                verticalStepView?.updateStep(step: step)
                break
            } else if stepState == .done {
                if step.id.rawValue < id.rawValue {
                    step.state = .done
                    verticalStepView?.updateStep(step: step)
                }
            }
        }
        mapVC.updateServiceState(state: id)
    }
    
    private func resetState(state: ServiceState) {
        verticalStepView?.resetSteps()
        mapVC.updateServiceState(state: state)
    }
    
    func driverLocationUpdate() {
        
    }
    
    func updateBookingIfNeeded() {
        
    }
    
    
    func getEta(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) {
        if lastRefresh == nil || lastRefresh!.timeIntervalSinceNow < -ScheduledViewController.ETARefreshThrottle {
            lastRefresh = Date()
            
            weak var weakSelf = self

            VolvoValetCustomerAPI.distance(origin: VolvoValetCustomerAPI.coordinatesToString(coordinate: fromLocation), destination: VolvoValetCustomerAPI.coordinatesToString(coordinate: toLocation), mode: nil) { distanceMatrix, error in
                
                if error != nil {
                    Logger.print("\(error?.code?.rawValue ?? "") \(error?.message ?? "")")
                    Analytics.trackCallGoogle(endpoint: .distance, error: error)
                } else {
                    Analytics.trackCallGoogle(endpoint: .distance)
                    
                    guard let weakSelf = weakSelf else { return }
                    
                    if let distanceMatrix = distanceMatrix {
                        weakSelf.mapVC.updateETA(eta: distanceMatrix.getEta())
                        weakSelf.timeWindowView.setETA(eta: distanceMatrix.getEta())
                    }
                }
            }
        }
    }
    
    func contactDriverActionSheet() {
        let alertController = UIAlertController(title: .localized(.popupContactTitle), message: nil, preferredStyle: .actionSheet)
        
        let textButton = UIAlertAction(title: .localized(.popupContactText), style: .default, handler: { (action) -> Void in
            self.contactDriver(mode: "text_only")
        })
        
        let callButton = UIAlertAction(title: .localized(.popupContactCall), style: .default, handler: { (action) -> Void in
            self.contactDriver(mode: "voice_only")
        })
        
        let cancelButton = UIAlertAction(title: .localized(.cancel), style: .cancel, handler: { (action) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(textButton)
        alertController.addAction(callButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func contactDriver(mode: String) {
        
        guard let customerId = UserManager.sharedInstance.customerId() else { return }
        guard let booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle) else { return }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        VolvoValetCustomerAPI.contactDriver(customerId: customerId, bookingId: booking.id, mode: mode) { contact, error in
            if let contactDriver = contact {
                MBProgressHUD.hide(for: self.view, animated: true)
                if mode == "text_only" {
                    // sms
                    let number = "sms:\(contactDriver.textPhoneNumber ?? "")"
                    guard let url = URL(string: number) else { return }
                    UIApplication.shared.open(url)
                } else {
                    let number = "telprompt:\(contactDriver.voicePhoneNumber ?? "")"
                    guard let url = URL(string: number) else { return }
                    UIApplication.shared.open(url)
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showOkDialog(title: .localized(.error), message: .localized(.errorUnknown), dialog: .error, screen: self.screen)
            }
        }
    }
    
    @objc func driverTap(_ tapGesture: UITapGestureRecognizer) {
        if let driver = self.driver {
            
            Analytics.trackClick(button: .showDriver, screen: screen)
            self.navigationController?.view.blurByLuxe()

            driverInfoViewController = DriverInfoViewController(driver: driver, delegate: self)
            
            SDWebImageManager.shared().loadImage(with: URL(string: driver.iconUrl ?? ""), options: SDWebImageOptions.allowInvalidSSLCertificates, progress: nil, completed: { (image, data, error, cacheType, finished, url) in
                if let driverViewController = self.driverInfoViewController, image != nil {
                    driverViewController.roundImageView.image = image
                    driverViewController.modalPresentationStyle = .overCurrentContext
                    driverViewController.modalTransitionStyle = .crossDissolve
                    self.navigationController?.present(driverViewController, animated: true, completion: nil)
                }
            })
        }
    }
    
    func onDismiss() {
        self.navigationController?.view.unblurByLuxe()
    }
    
    
    
}
