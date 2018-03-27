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
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let descriptionLabel: UILabel = {
        let textView = UILabel(frame: .zero)
        textView.text = .NewServiceDescription
        textView.font = .volvoSansLight(size: 18)
        textView.textColor = .luxeDarkGray()
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }()
    
    let descriptionTextView: UITextView = {
        let descriptionTextView = UITextView(frame: .zero)
        descriptionTextView.font = .volvoSansLight(size: 18)
        descriptionTextView.isScrollEnabled = false
        return descriptionTextView
    }()
    
    let separator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.luxeDarkBlue()
        return view
    }()
    
    let descriptionTitle: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = UIColor.luxeDarkBlue()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.text = .AddDescription
        return titleLabel
    }()
    
    var scrollViewSize: CGSize? = nil

    let scrollView = UIScrollView(frame: .zero)
    let contentView = UIView(frame: .zero)

    let tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
    let confirmButton = VLButton(type: .bluePrimary, title: (.Next as String).uppercased(), actionBlock: nil)
    
    let drivability = [DrivableType.yes, DrivableType.no, DrivableType.notSure]
    var checkedCellIndex = 0
    let service: RepairOrder
    let vehicle: Vehicle
    
    init(vehicle: Vehicle, repairOrderType: RepairOrderType, services: [String]) {
        self.vehicle = vehicle
        var serviceTitle = String.Service + ": "
        for service in services {
            serviceTitle += "<br/>&bull; \(service). "
        }
        self.service = RepairOrder(repairOrderType: repairOrderType, customerDescription: serviceTitle, drivable: drivability[checkedCellIndex])
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ServiceCell.self, forCellReuseIdentifier: ServiceCell.reuseId)
        tableView.isScrollEnabled = false
        
        scrollView.keyboardDismissMode = .onDrag
        
        descriptionTextView.textContainer.maximumNumberOfLines = 10
        descriptionTextView.delegate = self
        
        confirmButton.setActionBlock {
            
            var notes = self.service.notes
            notes.append("<br/><br/>\(self.descriptionTextView.text ?? "")")
            notes.append("<br/><br/>\(String.IsVolvoDrivable) \(self.drivability[self.checkedCellIndex].rawValue)")

            self.service.notes = notes
            
            RequestedServiceManager.sharedInstance.setRepairOrder(repairOrder: self.service)
            StateServiceManager.sharedInstance.updateState(state: .needService)
            self.navigationController?.popToRootViewController(animated: false)
            self.appDelegate?.loadViewForVehicle(vehicle: self.vehicle, state: .needService)
            
        }
        //descriptionTextView.placeholder
        
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
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.left.top.width.height.equalTo(scrollView)
        }
        
        var labelHeight = volvoDrivableLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height
        
        volvoDrivableLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(volvoDrivableLabel.snp.bottom).offset(20)
            make.height.equalTo( Int(ServiceCell.height) * drivability.count)
        }
        
        labelHeight = descriptionLabel.sizeThatFits(CGSize(width: view.frame.width - 40, height: CGFloat(MAXFLOAT))).height
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalTo(volvoDrivableLabel)
            make.top.equalTo(tableView.snp.bottom).offset(30)
            make.height.equalTo(labelHeight)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.left.right.equalTo(volvoDrivableLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.height.equalTo(30)
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
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(VLButton.primaryHeight)
        }
        
        descriptionTextView.sizeToFit()
        descriptionTextView.backgroundColor = .clear
        
        
    }
    
    func getDrivabilityTitle(type: DrivableType) -> String {
        if type == .yes {
            return .Yes
        } else if type == .no {
            return .No
        } else {
            return .ImNotSure
        }
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
        let offset = CGPoint(x: 0, y: descriptionLabel.frame.origin.y)
        scrollView.setContentOffset(offset, animated: true)
        if let scrollViewSize = scrollViewSize {
            scrollView.contentSize = CGSize(width: scrollViewSize.width, height: scrollViewSize.height + 2)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let offset = CGPoint(x: 0, y: 0)
        if let scrollViewSize = scrollViewSize {
            scrollView.contentSize = scrollViewSize
        }
        scrollView.setContentOffset(offset, animated: true)

    }

    
}

extension OtherServiceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivability.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ServiceCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServiceCell.reuseId, for: indexPath) as! ServiceCell
        cell.setService(service: getDrivabilityTitle(type: drivability[indexPath.row]))
        cell.setChecked(checked: indexPath.row == checkedCellIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        checkedCellIndex = indexPath.row
        tableView.reloadData()
    }
    
}
