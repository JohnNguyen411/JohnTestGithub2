//
//  OtherServiceViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 3/14/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

class OtherServiceViewController: BaseViewController, UITextViewDelegate {
    
    let volvoDrivableLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .IsVolvoDrivable
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let descriptionLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .NewServiceDescription
        textView.font = .volvoSansProRegular(size: 16)
        textView.volvoProLineSpacing()
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let descriptionTextView: UITextView = {
        let descriptionTextView = UITextView(frame: .zero)
        descriptionTextView.font = .volvoSansProRegular(size: 16)
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.text = .TypeDescriptionHere
        descriptionTextView.textColor = .luxeLightGray()
        return descriptionTextView
    }()
    
    let separator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.luxeCobaltBlue()
        return view
    }()
    
    let descriptionTitle: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = UIColor.luxeCobaltBlue()
        titleLabel.font = .volvoSansProMedium(size: 12)
        titleLabel.text = .AddDescription
        return titleLabel
    }()
    
    var scrollViewSize: CGSize? = nil

    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView(frame: .zero)

    let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
    let confirmButton: VLButton
    
    let drivability: [Bool?] = [true, false, nil]
    var checkedCellIndex = 0
    let service: RepairOrder
    let vehicle: Vehicle
    let serviceTitle: String
    
    init(vehicle: Vehicle, repairOrderType: RepairOrderType, services: [String]) {
        self.vehicle = vehicle
        self.serviceTitle = services.joined(separator: ", ")
        self.service = RepairOrder(title: serviceTitle, repairOrderType: repairOrderType, customerDescription: serviceTitle, drivable: drivability[checkedCellIndex])
        
        confirmButton = VLButton(type: .bluePrimary, title: (.Next as String).uppercased(), kern: UILabel.uppercasedKern(), event: .next, screen: .serviceCustomNotes)
        
        super.init(screen: .serviceCustomNotes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CheckmarkCell.self, forCellReuseIdentifier: CheckmarkCell.reuseId)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        scrollView.keyboardDismissMode = .onDrag
        
        descriptionTextView.textContainer.maximumNumberOfLines = 8
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        descriptionTextView.delegate = self
        
        confirmButton.setActionBlock { [weak self] in
            guard let weakSelf = self else { return }
            
            var notes = "" // reset notes
            if weakSelf.descriptionTextView.text != .TypeDescriptionHere {
                notes = weakSelf.descriptionTextView.text ?? ""
            }
            weakSelf.service.notes = notes
            
            RequestedServiceManager.sharedInstance.setRepairOrder(repairOrder: weakSelf.service)
            StateServiceManager.sharedInstance.updateState(state: .needService, vehicleId: weakSelf.vehicle.id, booking: nil)
            weakSelf.pushViewController(ServiceCarViewController(title: .ServiceSummary, vehicle: weakSelf.vehicle, state: .needService), animated: true)

        }
        //descriptionTextView.placeholder
        self.navigationItem.title = .OtherMaintenance

    }
    
    override func setupViews() {
        super.setupViews()
        
        scrollView.contentMode = .scaleAspectFit
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(volvoDrivableLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(separator)
        contentView.addSubview(descriptionTitle)
        contentView.addSubview(confirmButton)
        
        scrollView.snp.makeConstraints { make in
            make.edgesEqualsToView(view: self.view)
        }
        
        contentView.snp.makeConstraints { make in
            make.left.top.width.height.equalTo(scrollView)
        }
        
        var labelHeight = volvoDrivableLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height
        
        volvoDrivableLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(BaseViewController.defaultTopYOffset)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.top.equalTo(volvoDrivableLabel.snp.bottom).offset(20)
            make.height.equalTo( Int(CheckmarkCell.height) * drivability.count + 1)
        }
        
        let tableViewSeparator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-20, height: 1))
        tableViewSeparator.backgroundColor = .luxeLightestGray()
        
        self.tableView.tableFooterView = tableViewSeparator
        
        labelHeight = descriptionLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalTo(volvoDrivableLabel)
            make.top.equalTo(tableView.snp.bottom).offset(40)
            make.height.equalTo(labelHeight)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.height.equalTo(35)
        }
        
        separator.snp.makeConstraints { make in
            make.left.right.equalTo(volvoDrivableLabel)
            make.top.equalTo(descriptionTextView.snp.bottom)
            make.height.equalTo(1)
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.left.right.equalTo(volvoDrivableLabel)
            make.top.equalTo(separator.snp.bottom).offset(5)
            make.height.equalTo(25)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalTo(volvoDrivableLabel)
            make.equalsToBottom(view: contentView, offset: -20)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        descriptionTextView.sizeToFit()
        descriptionTextView.backgroundColor = .clear
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if scrollViewSize == nil {
            scrollViewSize = self.scrollView.frame.size
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        // autoresize view
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        if newFrame.size != textView.frame.size {
            
            descriptionTextView.snp.updateConstraints { make in
                make.height.equalTo(newFrame.size.height)
            }
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let offset = CGPoint(x: 0, y: descriptionLabel.frame.origin.y - 10)
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
            textView.text = .TypeDescriptionHere
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

extension OtherServiceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivability.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CheckmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckmarkCell.reuseId, for: indexPath) as! CheckmarkCell
        cell.setTitle(title: RepairOrder.getDrivabilityTitle(isDrivable: drivability[indexPath.row]))
        cell.setChecked(checked: indexPath.row == checkedCellIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        checkedCellIndex = indexPath.row
        tableView.reloadData()
        Analytics.trackClick(button: .serviceCustomDrivable, screen: self.screen)
    }
    
}
