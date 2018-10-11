//
//  HelpViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/25/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class HelpViewController: BaseViewController {
    
    static let helpSectionBooking: [HelpDetail] = [HelpDetail(title: .helpMyVehicleWasDamaged, description: .helpMyVehicleWasDamagedDetail), HelpDetail(title: .helpILostAnItem, description: .helpILostAnItemDetail), HelpDetail(title: .helpMyPickupDeliveryLocationWasWrong, description: .helpMyPickupDeliveryLocationWasWrongDetail), HelpDetail(title: .helpMyDriverWasLate, description: .helpMyDriverWasLateDetail), HelpDetail(title: .helpIMissedMyPickupDelivery, description: .helpIMissedMyPickupDeliveryDetail), HelpDetail(title: .helpMyDriverDidntMatchThePicture, description: .helpMyDriverDidntMatchThePictureDetail), HelpDetail(title: .helpICouldntContactMyDriver, description: .helpICouldntContactMyDriverDetail), HelpDetail(title: .helpMyDriverWasUnprofessional, description: .helpMyDriverWasUnprofessionalDetail), HelpDetail(title: .helpSomethingUnsafeHappened, description: .helpSomethingUnsafeHappenedDetail), HelpDetail(title: .helpThereWasAnIssueWithMyLoanerVehicle, description: .helpThereWasAnIssueWithMyLoanerVehicleDetail), HelpDetail(title: .helpThereWasAnIssueWithMyPaperwork, description: .helpThereWasAnIssueWithMyPaperworkDetail), HelpDetail(title: .helpOther, description: .helpOtherDetail)]
    
    static let helpSectionProduct: [HelpDetail] = [HelpDetail(title: .helpICantArrangeService, description: .helpICantArrangeServiceDetail), HelpDetail(title: .helpNoParticipatingDealershipsInArea, description: .helpNoParticipatingDealershipsInAreaDetail), HelpDetail(title: .helpICantCancelMyPickupOrDelivery, description: .helpICantCancelMyPickupOrDeliveryDetail), HelpDetail(title: .helpTooFewLoanersAvailable, description: .helpTooFewLoanersAvailableDetail), HelpDetail(title: .helpNoneOfTheAvailableTimesWorkForMe, description: .helpNoneOfTheAvailableTimesWorkForMeDetail)]
    
    static let helpSectionApp: [HelpDetail] = [HelpDetail(title: .helpTheAppIsntWorkingCorrectly, description: .helpTheAppIsntWorkingCorrectlyDetail), HelpDetail(title: .helpIForgotMyPassword, description: .helpIForgotMyPasswordDetail), HelpDetail(title: .helpICantUpdateMyPhone, description: .helpICantUpdateMyPhoneDetail), HelpDetail(title: .helpMyCurrentLocationIsntWorking, description: .helpMyCurrentLocationIsntWorkingDetail), HelpDetail(title: .helpPushNotificationsArentWorking, description: .helpPushNotificationsArentWorkingDetail), HelpDetail(title: .helpTermsOfService, description: .helpTermsOfServiceDetail), HelpDetail(title: .helpPrivacyPolicyInformation, description: .helpPrivacyPolicyInformationDetail), HelpDetail(title: .helpRequestingDataFromLuxebyVolvo, description: .helpRequestingDataFromLuxebyVolvoDetail), HelpDetail(title: .helpDeleteMyLuxebyVolvoAccount, description: .helpDeleteMyLuxebyVolvoAccountDetail), HelpDetail(title: .helpOther, description:.helpAppOtherDetail)]
    
    let helpSections = [HelpSection(title: String.helpHowLuxeByVolvoWorks, type: .product, sections: HelpViewController.helpSectionProduct), HelpSection(title: String.helpTroubleWithTheLuxebyVolvoApp, type: .app, sections: HelpViewController.helpSectionApp)]
    
    let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarItem()
    }
    
    override func setupViews() {
        super.setupViews()
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
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
