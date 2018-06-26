//
//  BookingRatingViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 6/8/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SlideMenuControllerSwift
import RealmSwift
import BrightFutures
import Alamofire
import Kingfisher
import MBProgressHUD


class BookingRatingViewController: ChildViewController, UITextViewDelegate {
    
    var retryCount = 0
    var isShowingComment = false
    var serviceCompleteHeight: CGFloat = 0
    var vehicle: Vehicle?
    var booking: Booking?

    var bookingFeedback: BookingFeedback?

    let vehicleTypeView = VLTitledLabel(title: .VolvoYearModel, leftDescription: "", rightDescription: "")
    let vehicleImageView = UIImageView(frame: .zero)
    let confirmButton = VLButton(type: .bluePrimary, title: (.Ok as String).uppercased(), kern: UILabel.uppercasedKern())
    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView(frame: .zero)
    let ratingSlider = VLMarkedSlider(step: 1, min: 1, max: 10, defaultValue: 8)
    
    var analyticScreenName = ""
    var screenTitle: String?
    var scrollViewSize: CGSize? = nil
    
    let serviceCompleteLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .DeliveryComplete
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let rateLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .Rating
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let ratingTextView: UITextView = {
        let ratingTextView = UITextView(frame: .zero)
        ratingTextView.font = .volvoSansProRegular(size: 16)
        ratingTextView.isScrollEnabled = false
        ratingTextView.text = .RatingReasonHint
        ratingTextView.textColor = .luxeLightGray()
        return ratingTextView
    }()
    
    let separator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.luxeCobaltBlue()
        return view
    }()
    
    let textViewTitle: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = UIColor.luxeCobaltBlue()
        titleLabel.font = .volvoSansProMedium(size: 12)
        titleLabel.text = .YourFeedback
        return titleLabel
    }()
    
    
    convenience init(bookingFeedback: BookingFeedback) {
        self.init()
        self.bookingFeedback = bookingFeedback
    }
    
    //MARK: Lifecycle methods
    convenience init(vehicle: Vehicle) {
        self.init()
        self.vehicle = vehicle
        self.screenTitle = .ServiceComplete
    }
    
    init() {
        super.init(screenName: AnalyticsConstants.paramNameBookingFeedbackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = self.screenTitle {
            self.navigationItem.title = title
        }
        
        let uiBarButton = UIBarButtonItem(title: .Skip, style: .done, target: self, action: #selector(skip))
        self.navigationItem.rightBarButtonItem = uiBarButton
        
        scrollView.keyboardDismissMode = .onDrag
        
        ratingTextView.textContainer.maximumNumberOfLines = 6
        ratingTextView.textContainer.lineBreakMode = .byTruncatingTail
        ratingTextView.delegate = self
        
        ratingSlider.isUserInteractionEnabled = true
        vehicleImageView.contentMode = .scaleAspectFit
        
        loadData()
        
        confirmButton.setActionBlock { [weak self] in
            
            guard let weakSelf = self else { return }
            
            if !weakSelf.isShowingComment {
                weakSelf.showRatingTextView(show: true)
            } else {
                var commentText = weakSelf.ratingTextView.text ?? ""
                if commentText == .RatingReasonHint {
                    commentText = ""
                }
                
                weakSelf.sendFeedback(rating: weakSelf.ratingSlider.currentIntValue(), comment: commentText)
            }
        }
        
    }
    
    private func loadData() {
        if let vehicle = self.vehicle {
            booking = UserManager.sharedInstance.getLastBookingForVehicle(vehicle: vehicle)
            self.updateDealership(dealership: booking?.dealership)
            loadVehicle(vehicle: vehicle)
            return
        } else if let bookingFeedback = self.bookingFeedback {
            // load booking if needed
            if let realm = try? Realm() {
                if let booking = realm.objects(Booking.self).filter("id = \(bookingFeedback.bookingId)").first {
                    self.booking = booking
                    self.updateDealership(dealership: booking.dealership)
                    if let vehicle = booking.vehicle {
                        self.vehicle = vehicle
                        loadVehicle(vehicle: vehicle)
                        return
                    }
                }
            }
            guard let customerId = UserManager.sharedInstance.customerId() else { return }

            BookingAPI().getBooking(customerId: customerId, bookingId: bookingFeedback.bookingId).onSuccess { result in
                if let booking = result?.data?.result {
                    self.booking = booking
                    if let vehicle = booking.vehicle {
                        self.vehicle = vehicle
                        self.loadVehicle(vehicle: vehicle)
                    }
                    self.updateDealership(dealership: booking.dealership)
                }
                }.onFailure { error in
                    self.skipBookingFeedback(customerId: customerId, bookingId: bookingFeedback.bookingId, feedbackBookingId: bookingFeedback.id)
                }
        }
    }
    
    private func loadVehicle(vehicle: Vehicle) {
        vehicleTypeView.setLeftDescription(leftDescription: vehicle.vehicleDescription())
        vehicle.setVehicleImage(imageView: vehicleImageView)
    }
    
    private func updateDealership(dealership: Dealership?) {
        if let dealership = dealership {
            serviceCompleteLabel.text = String(format: NSLocalizedString(.DeliveryComplete), (dealership.name)!)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        serviceCompleteHeight = serviceCompleteLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height
        let rateLabelHeight = rateLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height
        
        scrollView.contentMode = .scaleAspectFit
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(confirmButton)
        contentView.addSubview(vehicleTypeView)
        contentView.addSubview(vehicleImageView)
        contentView.addSubview(serviceCompleteLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(separator)
        contentView.addSubview(textViewTitle)
        contentView.addSubview(ratingSlider)
        contentView.addSubview(ratingTextView)
        
        scrollView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self.view, edges: UIEdgeInsetsMake(0, 20, 20, 20))
        }
        
        contentView.snp.makeConstraints { make in
            make.left.top.width.height.equalTo(scrollView)
        }
        
        vehicleTypeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(BaseViewController.defaultTopYOffset)
            make.height.equalTo(VLTitledLabel.height)
        }
        
        vehicleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleTypeView.snp.bottom)
            make.height.equalTo(Vehicle.vehicleImageHeight)
        }
        
        serviceCompleteLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(vehicleImageView.snp.bottom)
            make.height.equalTo(serviceCompleteHeight)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(serviceCompleteLabel.snp.bottom).offset(13)
            make.height.equalTo(rateLabelHeight)
        }
        
        ratingSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(rateLabel.snp.bottom).offset(30)
            make.height.equalTo(60)
        }
        
        ratingTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(5)
            make.top.equalTo(serviceCompleteLabel.snp.bottom).offset(40)
            make.height.equalTo(35)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(ratingTextView.snp.bottom)
            make.height.equalTo(1)
        }
        
        textViewTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(5)
            make.height.equalTo(25)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        ratingTextView.sizeToFit()
        ratingTextView.backgroundColor = .clear
        showRatingTextView(show: false)
    }
    
    @objc func skip() {
        
        if isShowingComment {
            // send rating
            sendFeedback(rating: ratingSlider.currentIntValue(), comment: "")
        } else {
            guard let customerId = UserManager.sharedInstance.customerId() else { return }
            if let bookingFeedback = self.bookingFeedback {
                skipBookingFeedback(customerId: customerId, bookingId: bookingFeedback.bookingId, feedbackBookingId: bookingFeedback.id)
            } else if let booking = self.booking,
                booking.bookingFeedbackId  > -1 {
                skipBookingFeedback(customerId: customerId, bookingId: booking.id, feedbackBookingId: booking.bookingFeedbackId)
            }
        }
    }
    
    private func skipBookingFeedback(customerId: Int, bookingId: Int, feedbackBookingId: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        BookingAPI().skipBookingFeedback(customerId: customerId, bookingId: bookingId, feedbackBookingId: feedbackBookingId).onSuccess { result in
            self.goToNext()
            }.onFailure { error in
                // skip the skip?
                self.goToNext()
        }
    }
    
    @objc func sendFeedback(rating: Int, comment: String?) {
        guard let customerId = UserManager.sharedInstance.customerId() else { return }

        if let bookingFeedback = self.bookingFeedback {
            submitBookingFeedback(customerId: customerId, bookingId: bookingFeedback.bookingId, feedbackBookingId: bookingFeedback.id, rating: rating, comment: comment)
        } else if let booking = self.booking,
            booking.bookingFeedbackId  > -1 {
            submitBookingFeedback(customerId: customerId, bookingId: booking.id, feedbackBookingId: booking.bookingFeedbackId, rating: rating, comment: comment)
            
        }
    }
    
    private func submitBookingFeedback(customerId: Int, bookingId: Int, feedbackBookingId: Int, rating: Int, comment: String?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        BookingAPI().submitBookingFeedback(customerId: customerId, bookingId: bookingId, feedbackBookingId: feedbackBookingId, rating: rating, comment: comment).onSuccess { result in
            self.goToNext()
            }.onFailure { error in
                if self.retryCount > 2 {
                    // stop
                    self.goToNext()
                    return
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showDialog(title: .Error, message: .GenericError, buttonTitle: .Retry, completion: {
                    self.sendFeedback(rating: rating, comment: comment)
                }, analyticDialogName: AnalyticsConstants.paramNameErrorDialog, screenName: self.screenName)
                self.retryCount += 1
        }
    }
    
    func goToNext() {
        MBProgressHUD.hide(for: self.view, animated: true)
        if let appDelegate = self.appDelegate {
            appDelegate.loadMainScreen()
        }
    }
    
    func showRatingTextView(show: Bool) {
        isShowingComment = show
        ratingTextView.animateAlpha(show: show)
        textViewTitle.animateAlpha(show: show)
        separator.animateAlpha(show: show)
        rateLabel.animateAlpha(show: !show)
        ratingSlider.animateAlpha(show: !show)
        
        serviceCompleteLabel.text = show ? .RatingReason : .DeliveryComplete
        self.navigationItem.title = .Feedback
        
        confirmButton.setTitle(title: show ? String.Done.uppercased() : String.Ok.uppercased())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if scrollViewSize == nil {
            scrollViewSize = self.scrollView.frame.size
        }
    }
    
    
    //MARK: - TextView Management
    func textViewDidChange(_ textView: UITextView) {
        
        // autoresize view
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        if newFrame.size != textView.frame.size {
            
            ratingTextView.snp.updateConstraints { make in
                make.height.equalTo(newFrame.size.height)
            }
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let offset = CGPoint(x: 0, y: serviceCompleteLabel.frame.origin.y - 10)
        scrollView.setContentOffset(offset, animated: true)
        if let scrollViewSize = scrollViewSize {
            scrollView.contentSize = CGSize(width: scrollViewSize.width, height: scrollViewSize.height + 2)
        }
        if textView.textColor == .luxeLightGray() {
            textView.text = nil
            textView.textColor = .luxeDarkGray()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let offset = CGPoint(x: 0, y: 0)
        if let scrollViewSize = scrollViewSize {
            scrollView.contentSize = scrollViewSize
        }
        scrollView.setContentOffset(offset, animated: true)
        
        if textView.text.isEmpty {
            textView.text = .RatingReasonHint
            textView.textColor = .luxeLightGray()
        }
    }
    
    override func keyboardWillAppear(_ notification: Notification) {
        super.keyboardWillAppear(notification)
        if self.view.safeAreaBottomHeight > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.confirmButton.snp.updateConstraints { make in
                    make.equalsToBottom(view: self.contentView, offset: -(self.view.safeAreaBottomHeight+30))
                }
            })
        }
    }
    
    override func keyboardWillDisappear(_ notification: Notification) {
        super.keyboardWillDisappear(notification)
        
        if self.view.safeAreaBottomHeight > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.confirmButton.snp.updateConstraints { make in
                    make.equalsToBottom(view: self.contentView, offset: -20)
                }
            })
        }
    }
    
}
