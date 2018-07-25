//
//  HelpViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class HelpViewController: BaseViewController {
    
    static let helpSectionBooking: [HelpDetail] = [HelpDetail(title: .MyVehicleWasDamaged, description: .MyVehicleWasDamagedDetail), HelpDetail(title: .ILostAnItem, description: .ILostAnItemDetail), HelpDetail(title: .MyPickupDeliveryLocationWasWrong, description: .MyPickupDeliveryLocationWasWrongDetail), HelpDetail(title: .MyDriverWasLate, description: .MyDriverWasLateDetail), HelpDetail(title: .IMissedMyPickupDelivery, description: .IMissedMyPickupDeliveryDetail), HelpDetail(title: .MyDriverDidntMatchThePicture, description: .MyDriverDidntMatchThePictureDetail), HelpDetail(title: .ICouldntContactMyDriver, description: .ICouldntContactMyDriverDetail), HelpDetail(title: .MyDriverWasUnprofessional, description: .MyDriverWasUnprofessionalDetail), HelpDetail(title: .SomethingUnsafeHappened, description: .SomethingUnsafeHappenedDetail), HelpDetail(title: .ThereWasAnIssueWithMyLoanerVehicle, description: .ThereWasAnIssueWithMyLoanerVehicleDetail), HelpDetail(title: .ThereWasAnIssueWithMyPaperwork, description: .ThereWasAnIssueWithMyPaperworkDetail), HelpDetail(title: .Other, description: .OtherDetail)]
    
    static let helpSectionProduct: [HelpDetail] = [HelpDetail(title: .ICantArrangeService, description: .ICantArrangeServiceDetail), HelpDetail(title: .NoParticipatingDealershipsInArea, description: .NoParticipatingDealershipsInAreaDetail), HelpDetail(title: .ICantCancelMyPickupOrDelivery, description: .ICantCancelMyPickupOrDeliveryDetail), HelpDetail(title: .TooFewLoanersAvailable, description: .TooFewLoanersAvailableDetail), HelpDetail(title: .NoneOfTheAvailableTimesWorkForMe, description: .NoneOfTheAvailableTimesWorkForMeDetail)]
    
    static let helpSectionApp: [HelpDetail] = [HelpDetail(title: .TheAppIsntWorkingCorrectly, description: .TheAppIsntWorkingCorrectlyDetail), HelpDetail(title: .IForgotMyPassword, description: .IForgotMyPasswordDetail), HelpDetail(title: .ICantUpdateMyPhone, description: .ICantUpdateMyPhoneDetail), HelpDetail(title: .MyCurrentLocationIsntWorking, description: .MyCurrentLocationIsntWorkingDetail), HelpDetail(title: .PushNotificationsArentWorking, description: .PushNotificationsArentWorkingDetail), HelpDetail(title: .TermsOfService, description: .TermsOfServiceDetail), HelpDetail(title: .PrivacyPolicyInformation, description: .PrivacyPolicyInformationDetail), HelpDetail(title: .RequestingDataFromLuxebyVolvo, description: .RequestingDataFromLuxebyVolvoDetail), HelpDetail(title: .DeleteMyLuxebyVolvoAccount, description: .DeleteMyLuxebyVolvoAccountDetail), HelpDetail(title: .Other, description:.AppOtherDetail)]
    
    let helpSections = [HelpSection(title: .HowLuxebyVolvoWorks, type: .product, sections: HelpViewController.helpSectionProduct), HelpSection(title: .TroubleWithTheLuxebyVolvoApp, type: .app, sections: HelpViewController.helpSectionApp)]
    
    let tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
    var headerView: HelpBookingView?
    
    let user: Customer?
    var booking: Booking?

    init() {
        user = UserManager.sharedInstance.getCustomer()
        
        super.init(screen: .help)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem()
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdIndicator)
        tableView.isScrollEnabled = false
        
        BookingAPI().getBookings(customerId: UserManager.sharedInstance.customerId()!, active: nil, sort: "-id").onSuccess { results in
            if let bookings = results?.data?.result {
                for booking in bookings {
                    if booking.getLastCompletedRequest() != nil {
                        self.booking = booking
                        self.tableView.reloadData()
                        break
                    }
                }
            }
            }.onFailure { error in
                
        }
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.equalsToTop(view: self.view, offset: 30)
        }
    }

    @objc private func headerTap() {
        if let headerView = headerView, let title = headerView.title {
            let headerSection = HelpSection(title: title, type: .booking, sections: HelpViewController.helpSectionBooking)
            let booking = headerView.booking
            let request = headerView.request
            self.pushViewController(HelpListViewController(helpSection: headerSection, booking: booking, request: request), animated: true)
        }
    }
}

extension HelpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpSections.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdIndicator, for: indexPath) as! SettingsCell
        cell.setText(text: helpSections[indexPath.row].title)
        cell.setCellType(type: .indicator)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.booking != nil {
            return CGFloat(HelpBookingView.height)
        } else {
            return 0
        }
    }
    
    
}

extension HelpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = helpSections[indexPath.row]
        if indexPath.row == 0 {
            self.pushViewController(HelpListViewController(helpSection: section), animated: true)
        } else {
            self.pushViewController(HelpListViewController(helpSection: section), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = HelpBookingView()
        header.booking = self.booking
        
        header.isUserInteractionEnabled = true
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(self.headerTap))
        header.addGestureRecognizer(headerTap)
        
        self.headerView = header
        
        return header
    }
}
